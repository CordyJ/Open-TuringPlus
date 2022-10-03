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
% pConvertReal4ToReal8
%

parent "TLA.ch"

stub function TLAV48 (
	    value	: nat4		% Really real4
	)	: real8

body function TLAV48

#if IEEE then
    const exponent	: nat2	:= bits(value,Real4ExponentBits)
    const mantissa	: nat4	:= bits(value,Real4MantissaBits)

    var answer		: real8

    if (exponent = 0) and (mantissa = 0) then
	%
	% Zero value.
	%
	type LongArray	: array 0 .. 1 of nat4
	type(LongArray,answer)(0) := 0
	type(LongArray,answer)(1) := 0
	result answer
    end if

    var hiOrder		: nat4
    var loOrder		: nat4

    %
    % Propagate the sign bit.
    %
    bits(hiOrder,Real8SignBit) := bits(value,Real4SignBit)

    %
    % Convert the exponent.
    %
    bits(hiOrder,Real8ExponentBits) :=
	    exponent + (Real8ExponentBias - Real4ExponentBias)

    %
    % Convert the mantissa.
    %
    bits(hiOrder,Real8MantissaBits) :=
	    mantissa shr (Real4MantissaSize - Real8MantissaSize)
    loOrder := mantissa shl (32 + Real8MantissaSize - Real4MantissaSize)

    TLAVD8 (hiOrder, loOrder, answer)

    result answer
#else
    TLQUIT( "TLAV48 unimplemented",  excpUnimplementedFeature )
#end if

end TLAV48
