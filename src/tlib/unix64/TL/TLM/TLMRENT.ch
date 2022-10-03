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
% pEnterMonitor
%

parent "TLM.ch"

stub procedure TLMRENT ( register md : TL_MDpointer )

body procedure TLMRENT

     % lock monitor descriptor
    var x : TL_lockStatus_t
    TLK.TLKLKON(TL_Monitor(md).mQLock,x)
    
     % check if monitor is available (not busy)
    if TL_Monitor(md).entryParameter = TL_MonitorFree then
	 %
	 % we are first to arrive, so just return
	 %
	TL_Monitor(md).entryParameter := TL_MonitorBusy
	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)
    else
	 %
	 % put process at END of monitor entry queue
	 %
	if TL_Monitor(md).entryQ.head = nil(TL_Process) then
	    TL_Monitor(md).entryQ.head := TLKPD
	else
	    TL_Process(TL_Monitor(md).entryQ.tail).monitorQlink := TLKPD
        end if
        TL_Monitor(md).entryQ.tail := TLKPD
	TL_Process(TLKPD).monitorQlink := nil(TL_Process)

	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)

	 % 
	 % put ourselves to sleep until monitor is available
	 %
	TLK.TLKSSYNC(TLKPD)
    end if

end TLMRENT
