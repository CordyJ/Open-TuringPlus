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

% TLKUDMPP (utility dump process)
%  Dump the sate of a single process.
%
stub procedure TLKUDMPP ( pd : TL_PDpointer )

body procedure TLKUDMPP
    var timestr    : string
    var lineNumber : nat4
    var fileName   : addressint

    % -- find the line and file of this process.
    TLE.TLELF(TL_Process(pd).lineAndFile, TL_Process(pd).fileTable,
	       lineNumber, fileName)

    % -- compute the time left to timeout and store it in "timestr"
    timestr := ""
    if TL_Process(pd).timeoutTime not= 0 then
	var timeLeft: nat := 0

	if TL_Process(pd).timeoutEpoch = TLKEPOCH then
	    timeLeft := TL_Process(pd).timeoutTime - TLKTIME
	else
	    timeLeft := TL_Process(pd).timeoutTime + (maxnat - TLKTIME)
	end if

	if timeLeft not= 0 then
	    % -- put a '+' sign in front of number
	    % -- This should make it clear that the time we are printing out
	    % -- is the time until the timeout event.
	    % -- (and NOT the absolute time of the timeout event)
	    if timeLeft > maxnat div #10 then	% #10 == SUN4 C compiler bug
		timestr := ", timeout > maxnat/10"
	    else
		timestr := ", timeout = +" + natstr(timeLeft)
	    end if
	end if
    end if

    % -- print name[(id)]
    var name := string@(TL_Process(pd).name)
    if TL_Process(pd).pid ~= 0 then
	name += " [" + natstr(TL_Process(pd).pid) + "]"
    end if
    put: 0, "   ", name:20 ..	% (:xx LEFT justifies strings)
    
    % -- print line and file if available
    if fileName ~= 0 then
	put: 0, " Line ", intstr(lineNumber), " of ", string@(fileName) ..
    end if

    % -- print process priority
    if TL_Process(pd).dispatchPriority ~= defaultPriority then
	put: 0, ", priority = ", TL_Process(pd).dispatchPriority ..
    end if

    % -- print timeout
    put: 0, timestr
end TLKUDMPP
