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
% TLMCRSIG  - regular condition signal  (immediate signal)
%

parent "TLM.ch"

stub procedure TLMCRSIG ( register cd : TL_CDpointer )

body procedure TLMCRSIG

    if TL_Condition(cd).signalQ.head = nil(TL_Process) then
	%
	% Nobody waiting.
	%
	return
    end if
    
     %
     % Move the current process onto the monitor queue.
     %
    const register md	: TL_MDpointer	:= TL_Condition(cd).md

     % lock monitor descriptor
    var x : TL_lockStatus_t
    TLK.TLKLKON(TL_Monitor(md).mQLock,x)

    TL_Process(TLKPD).monitorQlink := nil(TL_Process)

      % put ourselves at END of monitor entryQ
      %
    if TL_Monitor(md).entryQ.head not= nil(TL_Process) then
	TL_Process(TL_Monitor(md).entryQ.tail).monitorQlink := TLKPD 
    else
	TL_Monitor(md).entryQ.head := TLKPD
    end if
    TL_Monitor(md).entryQ.tail := TLKPD

    TLK.TLKLKOFF(TL_Monitor(md).mQLock,x)

     %
     % Move the signalled process from the condition queue to the run queue.
     %
    const pd	: TL_PDpointer	:= TL_Condition(cd).signalQ.head
    TL_Condition(cd).signalQ.head := TL_Process(pd).monitorQlink
    TL_Process(pd).monitorQlink := nil(TL_Process)

     % wakeup up next process
    TLK.TLKSSYNC(pd)

     % put ourselves to sleep
    TLK.TLKSSYNC(TLKPD)

end TLMCRSIG
