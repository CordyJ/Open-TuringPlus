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
% pRealCompare8
%

parent "TLA.ch"

%
% Return -1 if left<right, 0 if left=right, and 1 if left>right.
%
stub function TLA8CM (
	    right	: real8,
	    left	: real8
	)	: int

body function TLA8CM

#if IEEE then
    var hiOrderL	: nat4
    var loOrderL	: nat4
    var hiOrderR	: nat4
    var loOrderR	: nat4

    TLAV8D (left, hiOrderL, loOrderL)
    TLAV8D (right, hiOrderR, loOrderR)

    const exponentL	: nat2	:= bits(hiOrderL,Real8ExponentBits)
    const mantissaL	: nat4	:= bits(hiOrderL,Real8MantissaBits)
    const exponentR	: nat2	:= bits(hiOrderR,Real8ExponentBits)
    const mantissaR	: nat4	:= bits(hiOrderR,Real8MantissaBits)

    if bits(hiOrderL,Real8SignBit) ~= bits(hiOrderR,Real8SignBit) then
	%
	% Left and right have opposite signs.
	%
	if (exponentL = 0) and (mantissaL = 0) and (loOrderL = 0)
		and (exponentR = 0) and (mantissaR = 0) and (loOrderR = 0) then
	    result 0
	elsif bits(hiOrderL,Real8SignBit) ~= 0 then
	    result -1
	else
	    result 1
	end if
    elsif bits(hiOrderL,Real8SignBit) ~= 0 then
	%
	% Left and right are both negative.
	%
	if exponentL > exponentR then
	    result -1
	elsif exponentL < exponentR then
	    result 1
	elsif mantissaL > mantissaR then
	    result -1
	elsif mantissaL < mantissaR then
	    result 1
	elsif loOrderL > loOrderR then
	    result -1
	elsif loOrderL < loOrderR then
	    result 1
	else
	    result 0
	end if
    else
	%
	% Left and right are both positive.
	%
	if exponentL > exponentR then
	    result 1
	elsif exponentL < exponentR then
	    result -1
	elsif mantissaL > mantissaR then
	    result 1
	elsif mantissaL < mantissaR then
	    result -1
	elsif loOrderL > loOrderR then
	    result 1
	elsif loOrderL < loOrderR then
	    result -1
	else
	    result 0
	end if
    end if
#else
    TLQUIT( "TLA8CM unimplemented",  excpUnimplementedFeature )
#end if

end TLA8CM
