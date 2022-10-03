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
% pPowerRI
%

parent "TLA.ch"

%
% Return left ** right.
%
stub function TLAPRI (
	    right	: int,
	    left	: real8
	)	: real8

body function TLAPRI

    if left = 0 then
#if CHECKED then
	if right = 0 then
	    TLQUIT( "Both operands of ** are zero",  excpZeroTakenToZeroPower )
	end if
#end if
	result 0
    end if

    var register product	: real	:= 1.

    if right < 0 then
	for : right .. -1
	    unchecked
	    product /= left
	end for
    else
	for decreasing : right .. 1
	    unchecked
	    product *= left
	end for
    end if

#if CHECKED then
    if product = 0 then
	if TLECU then
	    TLQUIT( "Underflow in \"**\" operation",  excpRealUnderflow )
	end if
    else
#if IEEE then
	var hiOrder	: nat4
	var loOrder	: nat4

	TLAV8D (product, hiOrder, loOrder)

	if bits(hiOrder,Real8ExponentBits) = Real8IllegalExponent then
	    TLQUIT( "Overflow in \"**\" operation",  excpRealOverflow )
	end if
#else
	%
	% Hmmm.  Some sort of homebrew real format, eh?  Well,
	% assuming they have some sort of infinity representation
	% and that they do intelligent things with it, we can use
	% the fact that infinity/2 = infinity.
	%
	unchecked
	if (product / 2) = product then
	    TLQUIT( "Overflow in \"**\" operation",  excpRealOverflow )
	end if
#end if
    end if
#end if

    result product

end TLAPRI
