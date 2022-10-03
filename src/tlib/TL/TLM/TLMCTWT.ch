% Turing+ v6.2, Sept 2022
% Copyright 1986 University of Toronto, 2022 Queen's University at Kingston
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software
% and associated documentation files (the “Software”), to deal in the Software without restriction,
% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
% subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all copies
% or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
% AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%
% pTimeOutWait
%

parent "TLM.ch"

stub procedure TLMCTWT ( waitTimeout : nat,
			register cd : TL_CDpointer )

body procedure TLMCTWT

    const register md	: TL_MDpointer	:= TL_Condition(cd).md
    var timedOut : boolean := false

    if TL_Monitor(md).deviceMonitor then
	TLMDCTWT(waitTimeout, cd)
	return
    end if
    
    % here if NOT device monitor

     % lock monitor descriptor
     % NOTE: this lock used to lock both monitorQ and timeout conditionQ
     %
    var x : TL_lockStatus_t
    TLK.TLKLKON(TL_Monitor(md).mQLock,x)

      %
      % insert outselves at end of condition queue
      %
    if TL_Condition(cd).signalQ.head not= nil(TL_Process) then
	TL_Process(TL_Condition(cd).signalQ.tail).monitorQlink := TLKPD
    else
	TL_Condition(cd).signalQ.head := TLKPD
    end if
    TL_Condition(cd).signalQ.tail := TLKPD
    TL_Process(TLKPD).monitorQlink := nil(TL_Process)

      %
      % indicate we are on timeout conditionQ
      %
    TL_Process(TLKPD).waitParameter := waitTimeout

      % reset the "was signalled" flag
    bits(TL_Process(TLKPD).timeOutStatus, Signalled) := 0

     %
     % Get a new process from the monitor queue to put on the run queue.
     %
    var pd : TL_PDpointer

    TLMGNEP (md, pd)
    if pd not= nil(TL_Process) then
	 % unlock monitor descriptor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)

	 % wake up this 'new' process.
	TLK.TLKSSYNC(pd)
    else
	%
	% no one waiting to get into monitor, so indicate that it is not busy
	%
	TL_Monitor(md).entryParameter := TL_MonitorFree

	 % unlock monitor descriptor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)
    end if

      %
      % put ourselves to sleep with a timeout wakeup
      %

    TLK.TLKSTIMO(waitTimeout, timedOut)

    %
    % -------------------------
    %
    % NOW, we have returned from the tsyncTimeout.
    %      Check if we timed out or was signalled
    %

    if not timedOut then

	% -- We did not timeout; We were signalled to wake up.
	% -- So just continue to execute

#if CHECKED then
	% -- assert TL_Process(TLKPD).timeOutCondSignalled
	if bits(TL_Process(TLKPD).timeOutStatus, Signalled) = 0 then
	    TLQUIT(  "TLMCTWT: LIBRARY ABORT - timeOutCondSignalled is false.",
	             excpAssertConditionFalse )
	end if
#end if  % CHECKED

        return

    end if


    % -- here if we DID timeout

    % -- lock monitor Q 
    % -- 'timeOutCondSignalled' field must be in critical section
    TLK.TLKLKON(TL_Monitor(md).mQLock, x)

    if bits(TL_Process(TLKPD).timeOutStatus, Signalled) = 1 then
	% -- between the time we got timed out and now, we were also
	% -- signalled  (see TLMCTSIG.ch)
	% -- So now wait until we get tsync'd when we 
	% -- eventually get removed from monitor (re)entry queue
	%

	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)
	TLK.TLKSSYNC(TLKPD)
    else
	%
	% we timed out and  we were NOT signalled (via TLMCTSIG())
	%
	
	%
	% -- remove ourselves from the timeout condition queue
	%

	if TL_Condition(cd).signalQ.head = TLKPD then
	    TL_Condition(cd).signalQ.head := TL_Process(TLKPD).monitorQlink
	else
	    var register last :TL_PDpointer := TL_Condition(cd).signalQ.head

	    loop
#if CHECKED then
	      if last = nil(TL_Process) then
		  TLQUIT(  
		          "TLMCTWT: LIBRARY ABORT - TLKPD not found in conditon Q",
		           excpAssertConditionFalse )
	      end if
#end if
	      exit when TL_Process(last).monitorQlink = TLKPD
	      last := TL_Process(last).monitorQlink
	    end loop
	    TL_Process(last).monitorQlink := TL_Process(TLKPD).monitorQlink

	     %
	     % assume last entry in Q is null-terminated,
	     % so if we remove last entry we must update the tail ptr
	     %
	    if TL_Process(last).monitorQlink = nil(TL_Process) then
		TL_Condition(cd).signalQ.tail := last
	    end if
	end if

	TL_Process(TLKPD).monitorQlink := nil(TL_Process)

	% now try to re-enter the monitor
    
	if TL_Monitor(md).entryParameter = TL_MonitorFree then
	     % monitor not busy, so enter
	    TL_Monitor(md).entryParameter := TL_MonitorBusy
	    TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)
	else
	    % -- we timed out; treat this as if a TLMCTSIG() occured!

	    % -- put process on monitor reEntryQ
	    %
	    if TL_Monitor(md).reEntryQ.head not= nil(TL_Process) then
		TL_Process(TL_Monitor(md).reEntryQ.tail).monitorQlink := TLKPD
	    else
		TL_Monitor(md).reEntryQ.head := TLKPD
	    end if
	    TL_Monitor(md).reEntryQ.tail := TLKPD

	     % unlock monitor descriptor
	    TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)

	     % wait for monitor to become unbusy
	    TLK.TLKSSYNC(TLKPD)
	end if
    end if

end TLMCTWT
