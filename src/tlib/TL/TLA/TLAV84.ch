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
% pConvertReal8ToReal4
%

parent "TLA.ch"

stub function TLAV84 (
	    value	: real8
	)	: nat4		% Really real4

body function TLAV84

#if IEEE then
    var hiOrder			: nat4
    var loOrder			: nat4

    TLAV8D (value, hiOrder, loOrder)

    var exponent		: int2	:= bits(hiOrder,Real8ExponentBits)
    var register mantissa	: nat4	:= bits(hiOrder,Real8MantissaBits)

    if (exponent = 0) and (mantissa = 0) then
	result 0
    end if

    exponent += Real4ExponentBias - Real8ExponentBias

    %
    % Fill up the rest of the real4 mantissa from loOrder.
    % Move 1 extra guard bit, and generate a sticky bit (see
    % TLAVN4) for proper IEEE rounding (grrr).
    %
    begin
	var register loBits	: nat4	:= loOrder

	for : Real8MantissaSize .. Real4MantissaSize
	    mantissa shl= 1
	    if (loBits and 16#80000000) ~= 0 then
		mantissa += 1
	    end if
	    loBits shl= 1
	end for

	%
	% Now generate the sticky bit.
	%
	mantissa shl= 1
	if loBits ~= 0 then
	    mantissa += 1
	end if
    end

    %
    % Round the mantissa value, and adjust the exponent if necessary.
    %
    mantissa += bits(mantissa, 1..2)
    if (mantissa and (1 shl (Real4MantissaSize + 2))) ~= 0 then
	mantissa := 0
	exponent += 1
    else
	mantissa shr= 2
    end if

    %
    % Check the final value for reasonableness.
    %
    if exponent < 0 then
#if CHECKED then
	if TLECU then
	    TLQUIT( "Value of real8 too small for real4 variable",  excpRealUnderflow )
	end if
#end if
	result 0
    end if
    if exponent >= Real4IllegalExponent then
#if not CHECKED then
	exponent := Real4IllegalExponent
#else
	TLQUIT( "Value of real8 too large for real4 variable",  excpRealOverflow )
    elsif TLECU and (exponent = 0) and (mantissa = 0) then
	TLQUIT( "Value of real8 too small for real4 variable",  excpRealUnderflow )
#end if
    end if

    %
    % Convert the value.
    %
    var answer			: nat4

    bits(answer,Real4SignBit)		:= bits(hiOrder,Real8SignBit)
    bits(answer,Real4ExponentBits)	:= exponent
    bits(answer,Real4MantissaBits)	:= mantissa

    result answer
#else
    TLQUIT( "TLAV84 unimplemented",  excpUnimplementedFeature )
#end if

end TLAV84
