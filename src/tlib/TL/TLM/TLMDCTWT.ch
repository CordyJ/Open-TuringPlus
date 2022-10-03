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
% pTimeOutWait in device monitors
%

parent "TLM.ch"

stub procedure TLMDCTWT ( waitTimeout : nat,
		 	  register cd : TL_CDpointer )

body procedure TLMDCTWT

    const register md	: TL_MDpointer	:= TL_Condition(cd).md
    var timedOut : boolean := false

    % -- DEVICE MONITOR assumptions:
    % --  1. User knows what he/she is doing
    % --  2. In multi-cpu systems, only processes on SAME cpu
    % --     can call/use the same device monitor.
    % --     This means that 2 processes cannot simultaneously be
    % --     executing in the same device monitor.
    % --  3. On single cpu systems, user must ensure that 
    % --     pre-emption (e.g time_slicing) cannot occur
    % --     This ensures that 2 processes cannot be executing
    % --     in same device monitor at the same time

    % -- Since we assume that 2 processes cannot be executing in
    % -- the device monitor at a time, we don't need to use 
    % -- TLKLKON() to lock the monitor descriptor.

    %
    % -- insert outselves at end of condition queue
    %
    if TL_Condition(cd).signalQ.head not= nil(TL_Process) then
	TL_Process(TL_Condition(cd).signalQ.tail).monitorQlink := TLKPD
    else
	TL_Condition(cd).signalQ.head := TLKPD
    end if
    TL_Condition(cd).signalQ.tail := TLKPD
    TL_Process(TLKPD).monitorQlink := nil(TL_Process)

    % -- indicate we are on timeout conditionQ
    % -- and reset the "was signalled" flag
    %
    TL_Process(TLKPD).waitParameter := waitTimeout
    bits(TL_Process(TLKPD).timeOutStatus, Signalled) := 0

    %
    % -- put ourselves to sleep with a timeout wakeup
    %
    TLK.TLKSTIMO(waitTimeout, timedOut)

    %
    % -------------------------
    %
    % -- NOW, we have returned from the tsyncTimeout.
    % -- Check if we timed out or was signalled
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

    % -- get here if we DID timeout

    if bits(TL_Process(TLKPD).timeOutStatus, Signalled) = 1 then
	% -- between the time we got timed out and now, we were also
	% -- signalled  (see TLMCTSIG.ch)

	% DO nothing - the signaller is NOT waiting since
	% the signaller's tsync() was done to a 'timedout' process 
	% and this was a no-op. (which means signaller did NOT block)
	% 

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
		  TLQUIT("TLMCTWT: LIBRARY ABORT - TLKPD not found in conditon Q",
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
    end if

    return

end TLMDCTWT
