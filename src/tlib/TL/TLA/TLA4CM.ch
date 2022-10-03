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
% pRealCompare4
%

parent "TLA.ch"

%
% Return -1 if left<right, 0 if left=right, and 1 if left>right.
%
stub function TLA4CM (
	    right	: nat4,		% Really real4
	    left	: nat4		% Really real4
	)	: int

body function TLA4CM

#if IEEE then
    const lExponent	: nat2	:= bits(left,Real4ExponentBits)
    const lMantissa	: nat4	:= bits(left,Real4MantissaBits)
    const rExponent	: nat2	:= bits(right,Real4ExponentBits)
    const rMantissa	: nat4	:= bits(right,Real4MantissaBits)

    if bits(left,Real4SignBit) ~= bits(right,Real4SignBit) then
	%
	% Left and right have opposite signs.
	%
	if (lExponent = 0) and (lMantissa = 0) and (rExponent = 0)
		and (rMantissa = 0) then
	    result 0
	elsif bits(left,Real4SignBit) ~= 0 then
	    result -1
	else
	    result 1
	end if
    elsif bits(left,Real4SignBit) ~= 0 then
	%
	% Left and right are both negative.
	%
	if lExponent > rExponent then
	    result -1
	elsif lExponent < rExponent then
	    result 1
	elsif lMantissa > rMantissa then
	    result -1
	elsif lMantissa < rMantissa then
	    result 1
	else
	    result 0
	end if
    else
	%
	% Left and right are both positive.
	%
	if lExponent > rExponent then
	    result 1
	elsif lExponent < rExponent then
	    result -1
	elsif lMantissa > rMantissa then
	    result 1
	elsif lMantissa < rMantissa then
	    result -1
	else
	    result 0
	end if
    end if
#else
    TLQUIT( "TLA4CM unimplemented", excpUnimplementedFeature)
#end if

end TLA4CM
