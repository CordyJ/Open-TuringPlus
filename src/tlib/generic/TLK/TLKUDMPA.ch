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

% TLKUDMPA (utility dump all)
%  Dump the state of all currently active processes.
%
stub procedure TLKUDMPA

body procedure TLKUDMPA
    var foundOne: boolean 
    var register pd: TL_PDpointer

    foundOne := false

    % -- dump the currently running process
    % -- (if there is one and if it's not acting as the dispatcher)
    if not TLKDISP and TLKPD ~= nil(TL_Process) then
	put:0, skip, "****** Running:"
	foundOne := true
	TLKUDMPP(TLKPD)
    end if

    % -- dump all ready to run processes
    if TLKRQH ~= nil(TL_Process) then
	if not foundOne then
	    put:0, skip, "****** Running:"
	end if
	pd := TLKRQH
	loop
	    exit when pd = nil(TL_Process)
	    TLKUDMPP(pd)
	    pd := TL_Process(pd).runQlink
	end loop
    end if

    % -- print out processes paused in this epoch
    foundOne := false
    for epoch: TLKEPOCH .. TLKEPOCH + 1
	% -- choose either this epoch or the next for the search.
	pd := nil(TL_Process)
	if epoch = TLKEPOCH then
	    pd := TLKTQH
	elsif epoch = TLKEPOCH + 1 then
	    pd := TLKTQ2H
	end if

	% -- print out all pausing processes on the list headed by "pd"
	loop
	    exit when pd = nil(TL_Process)
	    if TL_Process(pd).pausing then
		if not foundOne then
		    foundOne := true
		    put:0, skip, "****** Paused:"
		end if
		TLKUDMPP(pd)
	    end if
	    pd := TL_Process(pd).timeoutQ.flink
	end loop
    end for

    % -- print out processes waiting elsewhere
    TLM.TLMUDUMP
    TLI.TLIUDUMP
end TLKUDMPA
