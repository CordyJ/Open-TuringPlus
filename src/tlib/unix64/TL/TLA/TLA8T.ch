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
% Trig sin/cos calculations.
%

parent "TLA.ch"

stub function TLA8T (
	    x		: real8,
	    y		: real8,
	    sgn		: int
	)	: real8

body function TLA8T

    const ovpi	:=  0.31830988618379067154
    const pia	:=  3.1416015625
    const pib	:= -8.9089102067615373566e-6
    const eps	:=  0.1490116119384765625e-7
    const p8	:=  0.27204790957888846175e-14
    const p7	:= -0.76429178068910467734e-12
    const p6	:=  0.16058936490371589114e-9
    const p5	:= -0.25052106798274584544e-7
    const p4	:=  0.27557319210152756119e-5
    const p3	:= -0.19841269841201840457e-3
    const p2	:=  0.83333333333331650314e-2
    const p1	:= -0.16666666666666665052e0

    var n		: int
    var f, g, res	: real8
    var s		: int

    n := round(y*ovpi)
    if (n and 1) ~= 0 then
	s := -sgn
    else
	s := sgn
    end if
    f := (y - n * pia) - n * pib
    if abs(f) < eps then
	result f * s
    end if
    g := f * f
    res := (((((((p8 * g + p7) * g + p6) * g + p5) * g + p4) * g + p3) * g
	    + p2) * g + p1) * g
    result (f + f * res) * s

end TLA8T
