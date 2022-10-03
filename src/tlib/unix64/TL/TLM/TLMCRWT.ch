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
% pWait    - regular condition wait
%

parent "TLM.ch"

stub procedure TLMCRWT ( register cd : TL_CDpointer )

body procedure TLMCRWT

     %
     % Move the current process (TLKPD) onto END of the condition queue.
     % since queue is FIFO
     %
    if TL_Condition(cd).signalQ.head not= nil(TL_Process) then
	TL_Process(TL_Condition(cd).signalQ.tail).monitorQlink := TLKPD
    else
	TL_Condition(cd).signalQ.head := TLKPD
    end if
    TL_Condition(cd).signalQ.tail := TLKPD
    TL_Process(TLKPD).monitorQlink := nil(TL_Process)

    %
    % Allow a process trying to enter the monitor to run.
    %

    const register md : TL_MDpointer := TL_Condition(cd).md

    %
    % -- need a check for device monitor in case TLMCDWT() calls this routine
    %
    if not TL_Monitor(md).deviceMonitor then
	% -- if not in a device monitor then we need to examine entryQ

	% -- lock monitor descriptor
	var x : TL_lockStatus_t
	TLK.TLKLKON(TL_Monitor(md).mQLock,x)

	 %
	 % check if anyone is waiting to enter monitor
	 %
	var pd : TL_PDpointer
	TLMGNEP (md, pd)

	if pd not= nil(TL_Process) then
	     % unlock monitor descriptor
	    TLK.TLKLKOFF(TL_Monitor(md).mQLock,x)

	     % wakeup this process
	    TLK.TLKSSYNC(pd)
	else
	     % no-one is waiting, so indicate that monitor is free
	     %
	    TL_Monitor(md).entryParameter := TL_MonitorFree

	     % unlock monitor descriptor
	    TLK.TLKLKOFF(TL_Monitor(md).mQLock,x)
	end if
    end if

     % put ourselves to sleep
    TLK.TLKSSYNC(TLKPD)

end TLMCRWT
