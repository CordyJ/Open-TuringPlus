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
% pNatreal
%

parent "TLA.ch"

stub function TLAVN8 (
	    value	: nat
	)	: real8

body function TLAVN8

#if IEEE then
    var answer			: real8

    if value = 0 then
	%
	% Easy case.
	%
	type LongArray		: array 0 .. 1 of nat4
	type(LongArray,answer)(0) := 0
	type(LongArray,answer)(1) := 0
	result answer
    end if

    var register exponent	: nat2
    var register mantissa	: nat4	:= value
    var hiOrder			: nat4
    var loOrder			: nat4

    %
    % Find the first set bit (and hence the eventual exponent) in the
    % value to convert.
    %
    begin
	var register bitTest	: nat4	:= 16#80000000

	for decreasing firstBitSet : 31 .. 0
	    if (mantissa and bitTest) ~= 0 then
		exponent := firstBitSet
		exit
	    end if
	    bitTest shr= 1
	end for
    end

    loOrder := 0

    if exponent < Real8MantissaSize then
	%
	% The entire mantissa will fit into the hiLongWord, but we
	% have to shift it first.  [ Recall that the first '1' in
	% front of the decimal point is implicit ].
	%
	mantissa shl= Real8MantissaSize - exponent
    elsif exponent > Real8MantissaSize then
	%
	% Some of the mantissa must go into the loLongWord.
	%
	loOrder := mantissa shl (32 + Real8MantissaSize - exponent)
	mantissa shr= exponent - Real8MantissaSize
    end if

    hiOrder := 0
    bits(hiOrder,Real8MantissaBits) := mantissa
    bits(hiOrder,Real8ExponentBits) := exponent + Real8ExponentBias

    TLAVD8 (hiOrder, loOrder, answer)

    result answer
#else
    TLQUIT( "TLAVN8 unimplemented",  excpUnimplementedFeature )
#end if

end TLAVN8
