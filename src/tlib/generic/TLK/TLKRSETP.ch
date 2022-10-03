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

% TLKRSETP (run queue set priority)
%
stub procedure TLKRSETP ( pd : TL_PDpointer, prio : nat )

body procedure TLKRSETP
    TL_Process(pd).dispatchPriority := prio

    % -- if process is on the run queue adjust its position
    if pd ~= TLKPD and TL_Process(pd).runQlink ~= nil(TL_Process) then
	var register next : TL_PDpointer := TLKRQH
	var register last : TL_PDpointer := nil(TL_Process)
	loop
	    exit when (next = pd)
	    last := next
	    next := TL_Process(next).runQlink
	end loop

	if last ~= nil(TL_Process) then
	    TL_Process(last).runQlink := TL_Process(pd).runQlink
	else
	    TLKRQH := TL_Process(pd).runQlink
	end if
	TL_Process(pd).runQlink := nil(TL_Process)

	% -- reinsert process in runQ
	TLKRQI(pd)
    end if

    % -- resched
    TLKRQI(TLKPD)
    TLKRQD
end TLKRSETP
