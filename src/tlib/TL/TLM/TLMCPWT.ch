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
% pPriorityWait
%

parent "TLM.ch"

stub procedure TLMCPWT ( waitPriority : nat,
			register cd  : TL_CDpointer )

body procedure TLMCPWT

    TL_Process(TLKPD).waitParameter := waitPriority
    
    %
    %  Move the process into the condition queue.
    %
    %   - monitorQlink field is used to link together processes in both
    %     the monitorEntryQ and the conditionQs
    %     since a process can only be on one of them at a time!
    %
    %   - don't use signalQ.tail since the list is in priority order
    %     and must be scanned each time - cannot do inserts at the tail!
    %

    if TL_Condition(cd).signalQ.head = nil(TL_Process) then
	  % conditionQ is empty
	TL_Condition(cd).signalQ.head := TLKPD
	TL_Process(TLKPD).monitorQlink := nil(TL_Process)
    else
	 %
	 % scan condition queue looking for appropriate place to put process
	 %
	var register next	: TL_PDpointer	:= TL_Condition(cd).signalQ.head
	var register last	: TL_PDpointer	:= nil(TL_Process)

	loop
	    exit when waitPriority < TL_Process(next).waitParameter
	    last := next
	    next := TL_Process(next).monitorQlink
	    exit when next = nil(TL_Process)
	end loop
	  %
	  % install TLKPD in linked list
	  %
	TL_Process(TLKPD).monitorQlink := next
	if last not= nil(TL_Process) then
	    TL_Process(last).monitorQlink := TLKPD
	else
	    TL_Condition(cd).signalQ.head := TLKPD
	end if
    end if

     %
     % Get a new process from the monitor entryQ and put it on the run queue.
     %
    const register md 	: TL_MDpointer := TL_Condition(cd).md

    var x : TL_lockStatus_t
    TLK.TLKLKON(TL_Monitor(md).mQLock,x)

    var pd : TL_PDpointer
    TLMGNEP (md, pd)

    if pd not= nil(TL_Process) then

	 % unlock monitor descriptor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock,x)

	 % wakeup next process
	TLK.TLKSSYNC(pd)
    else
	 %
	 % indicate that there is no one left inside monitor
	 %
	 TL_Monitor(md).entryParameter := TL_MonitorFree

	 % unlock monitor descriptor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock,x)
    end if

     % put ourselves to sleep
    TLK.TLKSSYNC(TLKPD)

end TLMCPWT
