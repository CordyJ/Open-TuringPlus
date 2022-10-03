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

% TLKRQD
%  Dispatch the process at the head of the run queue.  If there is none,
%  check other queues.
%
stub procedure TLKRQD

body procedure TLKRQD

    % -- indicate that TLKPD is the process dispatcher, and not a process itself
    TLKDISP := true

    % -- find a process to dispatch
    loop
	exit when TLKRQH ~= nil(TL_Process)

	const timeouts := TLKTQH ~= nil(TL_Process) or 
			  TLKTQ2H ~= nil(TL_Process)

	if timeouts then
	    % -- This is a simulation mode timeout.
	    % -- Advance time up to first process dispatch time.
	    if TLKTQH not= nil(TL_Process) then
		TLKTIME := TL_Process(TLKTQH).timeoutTime
		TLKTQD
	    elsif TLKTQ2H not= nil(TL_Process) then
		% --  Go to next epoch: 
		TLKTQH := TLKTQ2H
		TLKTQ2H := nil(TL_Process)
		TLKTIME := TL_Process(TLKTQH).timeoutTime
		TLKEPOCH += 1
		TLKTQD
	    end if
	else
	    % -- Nothing left to run.
	    TLKUEXIT(0)
	end if
    end loop

    % -- dispatch first process in runQ
    if TLKRQH = TLKPD then
	TLKRQH := TL_Process(TLKRQH).runQlink
	TL_Process(TLKPD).runQlink := nil(TL_Process)
    else
	% -- Doesn't return until sometime after TLKPD is put back onto 
	% -- the run queue.
	% -- This may either be now (though not at the head), or never
	% -- (if TLKPD is now on TLKTPQ and therefore terminated).
	TLKPCS
    end if

    % -- Release stacks for processes that have died.
    loop
	var register pd := TLKFQH
	exit when pd = nil(TL_Process)

	TLKFQH := TL_Process(pd).runQlink
	TLB.TLBMFR (TL_Process(pd).memoryBase)
    end loop

    TL_Process(TLKPD).quantumCntr := TL_Process(TLKPD).quantum
    TLKDISP := false

end TLKRQD
