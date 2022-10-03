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
% pFloor
%

parent "TLA.ch"

%
% Return floor(value).
%
stub function TLA8FL (
	    value	: real8
	)	: int

body function TLA8FL

#if IEEE then
    var hiOrder	: nat4
    var loOrder	: nat4

    TLAV8D (value, hiOrder, loOrder)

    var register mantissa	: nat4	:= bits(hiOrder,Real8MantissaBits)
    var register exponent	: int2	:= bits(hiOrder,Real8ExponentBits)

    if (exponent = 0) and (mantissa = 0) and (loOrder = 0) then
	result 0
    end if

    exponent -= Real8ExponentBias
    mantissa or= 1 shl Real8MantissaSize

    var register remainder	: nat4	:= loOrder

    if exponent < 0 then
	remainder or= mantissa
	mantissa := 0
    elsif exponent < Real8MantissaSize then
	remainder or= mantissa and ((1 shl (Real8MantissaSize - exponent)) - 1)
	mantissa shr= Real8MantissaSize - exponent
#if CHECKED then
    elsif exponent >= 32 then
	TLQUIT( "Integer overflow in \"floor\"",  excpIntegerOverflow )
#end if
    else
	for decreasing : exponent .. Real8MantissaSize + 1
	    mantissa shl= 1
	    if (remainder and 16#80000000) ~= 0 then
		mantissa += 1
	    end if
	    remainder shl= 1
	end for
    end if

    var answer	: int

    if bits(hiOrder,Real8SignBit) ~= 0 then
#if CHECKED then
	if mantissa > -minint then
	    TLQUIT( "Integer overflow in \"floor\"",  excpIntegerOverflow )
	end if
#end if
	answer := -mantissa
	if remainder ~= 0 then
#if CHECKED then
	    if answer = minint then
		TLQUIT( "Integer overflow in \"floor\"",  excpIntegerOverflow )
	    end if
#end if
	    answer -= 1
	end if
    else
#if CHECKED then
	if mantissa > maxint then
	    TLQUIT( "Integer overflow in \"floor\"",  excpIntegerOverflow )
	end if
#end if
	answer := mantissa
    end if

    result answer
#else
    TLQUIT( "TLA8FL unimplemented",  excpUnimplementedFeature )
#end if

end TLA8FL
