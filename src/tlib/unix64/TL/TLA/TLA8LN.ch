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
% pLn
%

parent "TLA.ch"

%
% Return ln(value).
%
stub function TLA8LN (
	    value	: real8
	)	: real8

body function TLA8LN

#if IEEE or VAXFLOAT then
    const sqrt1ov2	:=  0.70710678118654752440
    const p2		:= -0.78956112887491257267e0
    const p1		:=  0.16383943563021534222e2
    const p0		:= -0.64124943423745581147e2
    const q2		:= -0.35667977739034646171e2
    const q1		:=  0.31203222091924532844e3
    const q0		:= -0.76949932108494879777e3
    const ln2a		:=  0.693359375
    const ln2b		:= -2.121944400546905827679e-4

    var n	: int
    var f, znum, zden, z, w, res	: real

#if CHECKED then
    if value <= 0 then
	TLQUIT( "Zero or negative value passed to Ln",  excpDomainError )
    end if
#end if

    n := TLA8GX(value)
    f := TLA8SX(value, 0)

    if f > sqrt1ov2 then
	znum := f - 1
	zden := f * 0.5 + 0.5
    else
	n -= 1
	znum := f - 0.5
	zden := znum * 0.5 + 0.5
    end if

    z := znum / zden
    w := z * z

    res := ((p2 * w + p1) * w + p0) * w
    res := res / (((w + q2) * w + q1) * w + q0)
    res := z + z * res

    result (res + n * ln2b) + n * ln2a

#else
    TLQUIT( "TLA8LN unimplemented",  excpUnimplementedFeature )
#end if

end TLA8LN
