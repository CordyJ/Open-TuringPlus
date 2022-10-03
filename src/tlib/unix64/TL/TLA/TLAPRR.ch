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
% pPowerRR
%

parent "TLA.ch"

%
% Return left ** right.
%
stub function TLAPRR (
	    right	: real,
	    left	: real
	)	: real

body function TLAPRR

    if left = 0 then
#if CHECKED then
	if right < 0 then
	    TLQUIT( "0.0 raised to negative power",  excpZeroTakenToNegativePower )
	end if
	if right = 0 then
	    TLQUIT( "0.0 raised to power 0.0",  excpZeroTakenToZeroPower )
	end if
#end if
	result 0
#if CHECKED then
    elsif left < 0 then
	TLQUIT( "Attempt to raise a negative number to a real power",  excpNegativeValueTakenToRealPower )
#end if
    end if

    var answer	: real8
    var error	: int
    
    TLA8X (ln(left) * right, answer, error)

    case error of
	label 0:
	label 1:
	    TLQUIT( "Overflow in real \"**\" operation",  excpRealOverflow )
	label 2:
	    if TLECU then
		TLQUIT( "Underflow in real \"**\" operation",  excpRealUnderflow )
	    else
		result 0
	    end if
    end case

    result answer

end TLAPRR
