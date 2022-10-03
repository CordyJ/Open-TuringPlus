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

parent "TLK.bd"

% TLKTQD (timeout queue dispatch)
%  Move processes that have finished waiting into the run queue 
%  Note that this queue contains both processes that are pause'ing and
%  those that are waiting on a timeout condition.
%
stub procedure TLKTQD

body procedure TLKTQD
    % -- loop to put all processes that have timed out on the run queue
    var register pd: TL_PDpointer 
    loop
	% -- only wakeup processes from "current epoch" timeoutQ (TLKTQH)
	pd := TLKTQH 
	exit when pd = nil(TL_Process) or TL_Process(pd).timeoutTime > TLKTIME

	% -- remove pd from timeout Q
	TLKTQH := TL_Process(pd).timeoutQ.flink
	if TLKTQH ~= nil(TL_Process) then
	    TL_Process(TLKTQH).timeoutQ.blink := nil(TL_Process)
	end if

	TL_Process(pd).timeoutQ.flink := nil(TL_Process)
	TL_Process(pd).timeoutQ.blink := nil(TL_Process)
	TL_Process(pd).timeoutTime    := 0
	TL_Process(pd).timeoutEpoch   := 0
	TL_Process(pd).timedOut       := true
	TL_Process(pd).tsyncWaiter    := nil(TL_Process)

	TLKRQI(pd)
    end loop
end TLKTQD
