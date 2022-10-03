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
% pSqrt
%

parent "TLA.ch"

%
% Return sqrt(value).
%
stub function TLA8QR (
	    value	: real8
	)	: real8

body function TLA8QR

#if IEEE or VAXFLOAT then
    const p0			:= 0.41731
    const p1			:= 0.59016
    const basetominushalf	:= 0.7071067811865475244008443621048490392848

    if value <= 0 then
#if CHECKED then
	if value < 0 then
	    TLQUIT( "Negative value passed to Sqrt",  excpDomainError )
	end if
#end if
	result 0
    end if

    var n	: int	:= TLA8GX(value)
    var temp	: real	:= p0 + p1 * TLA8SX(value, 0)

    if (n mod 2) ~= 0 then
	temp *= basetominushalf
	n += 1
    end if

    temp := TLA8SX(temp, TLA8GX(temp) + n div 2)
    temp += value / temp
    temp := 0.25 * temp + value / temp

    result 0.5 * (temp + value / temp)

#else
    TLQUIT( "TLA8QR unimplemented",  excpUnimplementedFeature )
#end if

end TLA8QR
