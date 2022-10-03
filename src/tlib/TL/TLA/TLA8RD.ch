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
% pRound
%

parent "TLA.ch"

%
% Return round(value).
%
stub function TLA8RD (
	    value	: real8
	)	: int

body function TLA8RD

    if value < 0 then
#if CHECKED then
	if (value + 0.5) < minint then
	    TLQUIT( "Integer overflow in \"round\"",  excpIntegerOverflow )
	end if
#end if
	if value <= minint then
	    %
	    % Let's not run into trouble with the upcoming floor().
	    %
	    result minint
	end if
    else
#if CHECKED then
	if (value - 0.5) >= maxint then
	    TLQUIT( "Integer overflow in \"round\"",  excpIntegerOverflow )
	end if
#end if
    end if

    var answer	: int	:= floor(value)

    %
    % Round up in case of a tie.
    %
    if (value - answer) >= 0.5 then
	answer += 1
    end if

    result answer

end TLA8RD
