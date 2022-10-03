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
% pCosD
%

parent "TLA.ch"

%
% Return cos(angle), where angle is in degrees.
%
stub function TLA8CD (
	    angle	: real8
	)	: real8

body function TLA8CD

    const radAngle	:= angle * DegreesToRadians

#if CHECKED then
    const MaxAngle	:= 0.84331486e9

    if abs(radAngle) > MaxAngle then
	TLQUIT( "Argument too large in \"cosd\"",  excpTrigArgumentTooLarge )
    end if
#end if

    const piov2		:= 1.57079632679489661923

    result TLA8T(radAngle, abs(radAngle) + piov2, 1)

end TLA8CD
