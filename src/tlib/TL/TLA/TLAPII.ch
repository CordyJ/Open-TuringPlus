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
% pPowerII
%

parent "TLA.ch"

%
% Return left ** right.
%
stub function TLAPII (
	    right	: int,
	    left	: int
	)	: int

body function TLAPII

    if right <= 0 then
#if CHECKED then
	if right < 0 then
	    TLQUIT( "Both operands of ** are integers and exponent is negative",  excpIntegerTakenToNegativePower )
	end if
	if left = 0 then
	    TLQUIT( "Both operands of ** are zero",  excpZeroTakenToZeroPower )
	end if
#end if
	result 1
    end if

    if left = 0 then
	result 0
    end if

    var register product	: nat	:= 1
    const register factor	: nat	:= abs(left)
#if CHECKED then
    var register maxProduct	: nat
    if (left < 0) and ((right and 1) ~= 0) then
	maxProduct := -(minint div factor)
    else
	maxProduct := maxint div factor
    end if
#end if

    for decreasing : right .. 1
#if CHECKED then
	if product > maxProduct then
	    TLQUIT( "Overflow in \"**\" operation",  excpIntegerOverflow )
	end if
#end if
	unchecked
	product *= factor
    end for

    if (left < 0) and ((right and 1) ~= 0) then
	result -product
    else
	result product
    end if

end TLAPII
