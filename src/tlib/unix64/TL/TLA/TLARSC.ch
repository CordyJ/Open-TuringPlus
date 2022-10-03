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
% Calculate the next random number in the given sequence.
% Note that sequence number 0 is allowed (it is used by rand and randint).
%

parent "TLA.ch"

stub procedure TLARSC (
	var answer	: real,
	    seqNo	: int
	)

body procedure TLARSC

    bind var register value to TLARS(seqNo)
    var tmp : real

    unchecked

    %
    % calculate next random integer
    %
    value *= RandomNumber

    %
    % convert to a real number between 0 and 1 (e.g. 0 < r < 1 )
    % Assumes that TLARS(seqNo) and value are 'nat4's
    %
    tmp := value
    answer := TLA8SX(tmp, TLA8GX(tmp) - 32)	% Assumes 32 bit nat's.

end TLARSC
