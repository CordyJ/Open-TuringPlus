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
% pRandInt	( predefined procedure randint(var i:int, low, high : int) )
%
%  sets i to the next value of a sequence of pseudo random integers
%  that approximates a uniform distribution 
%  over the range low <= i <= high
%

parent "TLA.ch"

stub procedure TLARNI (
	var answer	: int,
	    lowLimit	: int,
	    highLimit	: int
	)

body procedure TLARNI

#if CHECKED then
    %
    % assert (lowLimit <= highLimit)
    %
    if lowLimit > highLimit then
	TLQUIT( "Low value passed to \"randint\" greater than high value",  excpIllegalRangeForRandInt )
    end if
#end if

    var value : real

    %
    % Get next random number in this sequence.
    % Sequence 0 is used by rand and randint.
    %
    TLARSC (value, 0)

    %
    % convert real 'value' to an integer in the specified range
    %
    answer := floor((highLimit - lowLimit + 1) * value)
    answer += lowLimit

end TLARNI
