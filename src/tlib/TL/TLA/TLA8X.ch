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
% Return e**value.  If the calculation overflows, set error=1.
% If the calculation underflows, set error=2.  Else set error=0.
%

parent "TLA.ch"

stub procedure TLA8X (
	    value	: real8,
	var answer	: real8,
	var error	: int
	)

body procedure TLA8X

#if IEEE or VAXFLOAT then
    error := 0

    % minarg and maxarg should be such that the
    % true result would be slightly less than the
    % machine's largest value and greater than the
    % smallest.

    const minarg	:= -708.3964185322641
    const maxarg	:=  710.47586

    const eps		:=  5.55111512312578270211815834e-17
    const ovln2		:=  0.14426950408889634074e1
    const ln2a		:=  0.693359375e0
    const ln2b		:= -2.1219444005469058277e-4
    const p2		:=  0.165203300268279130e-4
    const p1		:=  0.694360001511792852e-2
    const p0		:=  0.249999999999999993e0
    const q2		:=  0.495862884905441294e-3
    const q1		:=  0.555538666969001188e-1
    const q0		:=  0.5

    var n		: int
    var g, z, num, denom, res	: real

    if value > maxarg then
	error := 1
	return
    elsif value < minarg then
	error := 2
	return
    elsif abs(value) < eps then
	answer := 1.0;
    else
	n := round(value * ovln2)
	g := (value - n * ln2a) - n * ln2b
	z := g * g
	num := ((p2 * z + p1) * z + p0) * g
	denom := (q2 * z + q1) * z + q0
	res := 0.5 + num / (denom - num)
	answer := TLA8SX(res, TLA8GX(res) + n + 1)
    end if

#else
    TLQUIT( "TLA8LN unimplemented",  excpUnimplementedFeature )
#end if

end TLA8X
