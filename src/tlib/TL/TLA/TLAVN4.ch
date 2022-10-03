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
% pConvertNatToReal4
%

parent "TLA.ch"

stub function TLAVN4 (
	    value	: nat
	)	: nat4		% Really real4

body function TLAVN4

#if IEEE then
    if value = 0 then
	%
	% Easy case.
	%
	result 0
    end if

    var register exponent	: nat2
    var register mantissa	: nat4	:= value

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

    if exponent < Real4MantissaSize then
	%
	% The entire mantissa will fit into the answer, but we have
	% to shift it first.  [ Recall that the first '1' in front of
	% the decimal point is implicit ].
	%
	mantissa shl= Real4MantissaSize - exponent
    elsif exponent > Real4MantissaSize then
	%
	% The mantissa won't fit.  Apparently IEEE defines that we're
	% supposed to round to the nearest even.  This can be done in
	% three steps.  First, shift the value by two less than necessary,
	% remembering if any of the shifted bits were set (this will have
	% to be explicitly tested for before the shift).  Then explicitly
	% set the low order bit of the shifted value if any of those
	% shifted bits were set (but do not clear it if they were not).
	% At this point, the value looks something like: "xxxlgs", where
	% 'l' is the low-order bit of the mantissa, 'g' is a guard bit,
	% and 's' is that specially modified sticky bit.  Now we get
	% tricky.  Add to this, the value whose bits are "000lg".  When
	% you stop to think about it, this ends up rounding, with the
	% value going to have the low-order bit being zero in the case
	% of a tie.
	%
	% Note that this might change the value of exponent if we happen
	% to round up a mantissa of all 1's.  Fortunately, this is easy
	% to check and correct for.
	%
	if exponent > (Real4MantissaSize + 2) then
	    %
	    % Check shifted bits.
	    %
	    const register shiftCount := exponent - (Real4MantissaSize + 2)

	    if (mantissa and ((1 shl shiftCount) - 1)) ~= 0 then
		mantissa shr= shiftCount
		mantissa or= 1
	    else
		mantissa shr= shiftCount
	    end if
	elsif exponent = (Real4MantissaSize + 1) then
	    %
	    % Make up a zero guard bit.
	    %
	    mantissa shl= 1
	end if

	%
	% Round the mantissa value, and adjust the exponent if necessary.
	%
	mantissa += bits(mantissa, 1..2)
	if (mantissa and (1 shl (Real4MantissaSize + 3))) ~= 0 then
	    mantissa := 0
	    exponent += 1
	else
	    mantissa shr= 2
	end if
    end if

    var answer			: nat4	:= 0

    bits(answer,Real4MantissaBits) := mantissa
    bits(answer,Real4ExponentBits) := exponent + Real4ExponentBias

    result answer
#else
    TLQUIT( "TLAVN4 unimplemented",  excpUnimplementedFeature )
#end if

end TLAVN4
