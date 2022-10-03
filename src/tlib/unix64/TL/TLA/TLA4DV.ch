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
% pRealDiv4
%

parent "TLA.ch"

%
% Return left div right.
%
stub function TLA4DV (
	    right	: nat4,		% Really real4
	    left	: nat4		% Really real4
	)	: int

body function TLA4DV

    const quotient : real8 := type(real4,left) / type(real4,right)

    if quotient < 0 then
#if CHECKED then
	if quotient < minint then
	    TLQUIT( "Integer overflow in real8 div", excpIntegerOverflow)
	end if
#end if
	result ceil(quotient)
    else
#if CHECKED then
	if quotient > maxint then
	    TLQUIT( "Integer overflow in real8 div", excpIntegerOverflow)
	end if
#end if
	result floor(quotient)
    end if

end TLA4DV
