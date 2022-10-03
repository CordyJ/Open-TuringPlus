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
% pArcTan
%

parent "TLA.ch"

%
% Return arctan(value) in radians.
%
stub function TLA8TR (
	    value	: real8
	)	: real8

body function TLA8TR

    const twomsqrt3	:= 0.26794919243112270647
    const sqrt3m1	:= 0.73205080756887729353
    const sqrt3		:= 1.73205080756887729353
    const eps		:= 0.1490116119384765625e-7

    const p3		:= -0.837582993681500592740
    const p2		:= -0.84946240351320683534e1
    const p1		:= -0.20505855195861651981e2
    const p0		:= -0.13688768894191926929e2
    const q3		:=  0.15024001160028576121e2
    const q2		:=  0.59578436142597344465e2
    const q1		:=  0.86157349597130242515e2
    const q0		:=  0.41066306682575781263e2


    const a		: array 0 .. 3 of real8	:= init (
				0.0,
				0.52359877559829887308,
				1.57079632679489661923,
				1.04719755119659774615)
    var n		: int
    var f, g, tmpResult	: real

    f := abs(value)
    if f > 1 then
	f := 1 / f
	n := 2
    else
	n := 0
    end if

    if f > twomsqrt3 then
	f := ((sqrt3m1 * f - 1) + f) / (sqrt3 + f)
	n += 1
    end if

    if abs(f) < eps then
	tmpResult := f
    else
	g := f * f
	tmpResult := (((p3 * g + p2) * g + p1) * g + p0) * g
	tmpResult /= ((((g + q3) * g + q2) * g + q1) * g + q0)
	tmpResult *= f
	tmpResult += f
    end if

    if n > 1 then
	tmpResult := -tmpResult
    end if

    tmpResult += a(n)

    if value < 0 then
	result -tmpResult
    else
	result tmpResult
    end if

end TLA8TR
