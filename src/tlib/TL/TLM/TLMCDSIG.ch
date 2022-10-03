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
% pDeferredSignal   ( a non-immediate signal )
%

parent "TLM.ch"

stub procedure TLMCDSIG ( register cd	: TL_CDpointer )


body procedure TLMCDSIG

    var register pd	: TL_PDpointer	:= TL_Condition(cd).signalQ.head

    if pd = nil(TL_Process) then
	%
	% Nobody waiting.
	%
	return
    end if
    
     %
     % We are assumed to be the only process in the monitor,
     % thus we can modify the condition queue without any locks
     %

     %
     % remove pd from condition queue
     %
    TL_Condition(cd).signalQ.head := TL_Process(pd).monitorQlink
    TL_Process(pd).monitorQlink := nil(TL_Process)

    const register md	: TL_MDpointer	:= TL_Condition(cd).md

    if TL_Monitor(md).deviceMonitor then
	TLK.TLKSWAKE(pd)
    else

	% --lock monitor descriptor
	%
	var x : TL_lockStatus_t
	TLK.TLKLKON(TL_Monitor(md).mQLock, x)

	%
	% -- put signalled process at end of monitor reEntryQ
	% -- (so it runs before those processes on 'entryQ')
	%
	if TL_Monitor(md).reEntryQ.head not= nil(TL_Process) then
	    TL_Process(TL_Monitor(md).reEntryQ.tail).monitorQlink := pd
	else
	    TL_Monitor(md).reEntryQ.head := pd
	end if
	TL_Monitor(md).reEntryQ.tail := pd

	 % unlock monitor descriptor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)
    end if

end TLMCDSIG
