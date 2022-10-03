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
% Return the value of the given real with the exponent set to the
% given value.
%

parent "TLA.ch"

stub function TLA8SX (
	    source	: real8,
	    expValue	: int
	)	: real8

body function TLA8SX

    if source = 0 then
	result 0
    end if

#if IEEE then
    var exponent	: nat2
    var answer		: real8

    if expValue < (1 - Real8ExponentBias) then
#if CHECKED then
	if TLECU then
	    TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
	end if
#end if
	result 0
    elsif expValue > (Real8IllegalExponent - Real8ExponentBias) then
#if CHECKED then
	TLQUIT( "Result of \"setexp\" overflows",  excpRealOverflow )
#else
	exponent := Real8IllegalExponent + 1 - Real8ExponentBias
#end if
    else
	exponent := expValue + Real8ExponentBias - 1
    end if

    var hiOrder	: nat4
    var loOrder	: nat4

    TLAV8D (source, hiOrder, loOrder)

#if CHECKED then
    if TLECU and (exponent = 0) and (loOrder = 0)
	    and (bits(hiOrder,Real8MantissaBits) = 0) then
	%
	% It underflows to *exactly* zero.
	%
	TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
    end if
#end if

    bits(hiOrder,Real8ExponentBits) := exponent

    TLAVD8 (hiOrder, loOrder, answer)

    result answer

#elsif VAXFLOAT then
    var exponent	: nat2
    var answer		: real8

    if expValue < (1 - Real8ExponentBias) then
#if CHECKED then
	if TLECU then
	    TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
	end if
#end if
	result 0
    elsif expValue > Real8ExponentBias then
#if CHECKED then
	TLQUIT( "Result of \"setexp\" overflows",  excpRealOverflow )
#else
	exponent := 2 * Real8ExponentBias - 1
#end if
    else
	exponent := expValue + Real8ExponentBias
    end if

    var hiOrder, loOrder : nat4

    TLAV8D (source, hiOrder, loOrder)

#if CHECKED then
    if TLECU and (exponent = 0) and (hiOrder = 0)
	    and ((loOrder and Real8MantissaMask) = 0) then
	%
	% It underflows to *exactly* zero.
	%
	TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
    end if
#end if

    bits(loOrder,Real8ExponentBits) := exponent

    TLAVD8 (hiOrder, loOrder, answer)

    result answer

#elsif IBMFLOAT then
    var exponent	: nat2
    var answer		: real8

    if expValue < - Real8ExponentBias then
#if CHECKED then
	if TLECU then
	    TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
	end if
#end if
	result 0
    elsif expValue > Real8ExponentBias then
#if CHECKED then
	TLQUIT( "Result of \"setexp\" overflows",  excpRealOverflow )
#else
	exponent := Real8ExponentBias
#end if
    else
	exponent := expValue + Real8ExponentBias
    end if

    var hiOrder	: nat4
    var loOrder	: nat4

    TLAV8D (source, hiOrder, loOrder)

#if CHECKED then
    if TLECU and (exponent = 0) and (loOrder = 0)
	    and (bits(hiOrder,Real8MantissaBits) = 0) then
	%
	% It underflows to *exactly* zero.
	%
	TLQUIT( "Result of \"setexp\" underflows",  excpRealUnderflow )
    end if
#end if

    bits(hiOrder,Real8ExponentBits) := exponent

    TLAVD8 (hiOrder, loOrder, answer)

    result answer

#else
    TLQUIT( "TLA8SX unimplemented",  excpUnimplementedFeature )
#end if

end TLA8SX
