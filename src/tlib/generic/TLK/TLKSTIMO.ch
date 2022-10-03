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

% TLKSTIMO (synchronize with timeout)
%  Same as TLKSSYNC but timeout after "interval" if not synched by then.
%
stub procedure TLKSTIMO ( interval : nat, var timedOut : boolean )

body procedure TLKSTIMO
    if TL_Process(TLKPD).tsyncWaiter = nil(TL_Process) then
	% -- barrier not attained yet, so block on timer queue
	TLKTQI(TLKPD, interval)

	% -- check for a very fast timeout
	if not TL_Process(TLKPD).timedOut then
	    % -- record the fact that this process is sleeping
	    TL_Process(TLKPD).tsyncWaiter := TLKPD

	    % -- run another process
	    TL_Process(TLKPD).ready := false
	    TLKRQD     

	    % -- The signaller, or the timeout, is responsible for
	    % -- resetting "signaller" to nil.
	    % -- Don't do it here because you don't know how long it's
	    % -- been since you timed out.
	end if

	% -- get here when TLKPD wakes up either by timeout or tsync
	timedOut := TL_Process(TLKPD).timedOut
    else
	% -- barrier attained, so unblock other process
	TLKRQI(TL_Process(TLKPD).tsyncWaiter)
	TL_Process(TLKPD).tsyncWaiter := nil(TL_Process)

	% -- might have unblocked a higher priority process
	TLKRQI(TLKPD)
	TLKRQD
    end if
end TLKSTIMO
