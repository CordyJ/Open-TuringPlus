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
% pRealAdd4
%
%
% Note:  IEEE specifies (or so T. Hull claims) that rounding is to be
% done to the nearest even value.  I don't fully understand when to
% apply the rounding, particularly in the case of subrtaction of
% magnitudes.  Is it done before the arithmetic to get both to the
% same exponent, or should there be a guard&sticky bit kept during
% the arithmetic, and the final result modified.  So, it true holtempire
% tradition, I'm going to ignore it and let someone else deal with it.
%

parent "TLA.ch"

%
% Return left + right.
%
stub function TLA4AD (
	    right	: nat4,		% Really real4
	    left	: nat4		% Really real4
	)	: nat4		% Really real4

body function TLA4AD

#if IEEE then
    %
    % Find the largest magnitude value.
    %
    var bigger			: nat4
    var bExponent		: nat2
    var bMantissa		: nat4
    var smaller			: nat4
    var sExponent		: nat2
    var sMantissa		: nat4

    const lExponent		: nat2	:= bits(left,Real4ExponentBits)
    const lMantissa		: nat4	:=
	    bits(left,Real4MantissaBits) or (1 shl Real4MantissaSize)
    const rExponent		: nat2	:= bits(right,Real4ExponentBits)
    const rMantissa		: nat4	:=
	    bits(right,Real4MantissaBits) or (1 shl Real4MantissaSize)

    if lExponent > rExponent then
	bigger		:= left
	bExponent	:= lExponent
	bMantissa	:= lMantissa
	smaller		:= right
	sExponent	:= rExponent
	sMantissa	:= rMantissa
    elsif lExponent < rExponent then
	bigger		:= right
	bExponent	:= rExponent
	bMantissa	:= rMantissa
	smaller		:= left
	sExponent	:= lExponent
	sMantissa	:= lMantissa
    elsif lMantissa > rMantissa then
	bigger		:= left
	bExponent	:= lExponent
	bMantissa	:= lMantissa
	smaller		:= right
	sExponent	:= rExponent
	sMantissa	:= rMantissa
    else
	bigger		:= right
	bExponent	:= rExponent
	bMantissa	:= rMantissa
	smaller		:= left
	sExponent	:= lExponent
	sMantissa	:= lMantissa
    end if

    %
    % Make sure infinities are handled properly (ie. +/-Inf + x = +/-Inf)
    %
    if bExponent = Real4IllegalExponent then
#if CHECKED then
	TLQUIT( "Infinite/indefinite value being added to", excpRealOverflow)
#else
	result bigger
#end if
    end if

    var exponent		: int2	:= bExponent
    var register mantissa	: nat4	:= sMantissa

    %
    % Normalize the smaller mantissa.  Keep a guard bit.
    %
    if bExponent > sExponent then
	if bExponent > (sExponent + 1) then
	    mantissa shr= bExponent - sExponent - 1
	end if
    else
	mantissa shl= 1
    end if

    if bits(bigger,Real4SignBit) = bits(smaller,Real4SignBit) then
	%
	% The signs are the same.  Add the mantissa's, and check for
	% an exponent change.
	%
	mantissa += bMantissa shl 1
	if (mantissa and (1 shl (Real4MantissaSize + 2))) ~= 0 then
	    %
	    % The exponent changed.  Be careful to round properly.
	    %
	    exponent += 1
	    mantissa += 2#10
	    mantissa shr= 2
	else
	    %
	    % Round up.  Be careful, since this might change the exponent.
	    %
	    mantissa += 1
	    if (mantissa and (1 shl (Real4MantissaSize + 2))) ~= 0 then
		exponent += 1
		mantissa shr= 2
	    else
		mantissa shr= 1
	    end if
	end if
    else
	%
	% The signs are different.  Subtract the mantissa's.
	% Watch for the two special cases:
	%	1) the result is zero
	%	2) the exponent changes.
	%
	mantissa := (bMantissa shl 1) - mantissa
	if (mantissa and (1 shl (Real4MantissaSize + 1))) ~= 0 then
	    mantissa += 1
	    mantissa shr= 1
	elsif mantissa = 0 then
	    result 0
	else
	    loop
		exponent -= 1
		exit when (mantissa and (1 shl Real4MantissaSize)) ~= 0
		mantissa shl= 1
	    end loop
	end if
    end if

    if exponent < 0 then
#if CHECKED then
	if TLECU then
	    TLQUIT( "Underflow in real4 addition", excpRealUnderflow)
	end if
#end if
	result 0
    end if
#if CHECKED then
    if exponent >= Real4IllegalExponent then
	TLQUIT( "Overflow in real4 addition",excpRealOverflow)
    end if
#else
    exponent := Real4IllegalExponent
#end if

    var answer			: nat4

    bits(answer,Real4SignBit)		:= bits(bigger,Real4SignBit)
    bits(answer,Real4ExponentBits)	:= exponent
    bits(answer,Real4MantissaBits)	:= mantissa

    result answer
#else
    TLQUIT( "TLA4AD unimplemented", excpUnimplementedFeature )
#end if

end TLA4AD
