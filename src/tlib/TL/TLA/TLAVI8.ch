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
% pIntreal
%

parent "TLA.ch"

stub function TLAVI8 (
	    value	: int
	)	: real8

body function TLAVI8

#if IEEE then
    var absValue	: nat
    var answer		: real8

    if value < 0 then
	absValue := -value
	answer := absValue

	%
	% Now fix the sign bit.
	%
	var hiOrder	: nat4
	var loOrder	: nat4

	TLAV8D (answer, hiOrder, loOrder)
	bits(hiOrder,Real8SignBit) := 1
	TLAVD8 (hiOrder, loOrder, answer)
    else
	absValue := value
	answer := absValue
    end if

    result answer
#else
    TLQUIT( "TLAVI8 unimplemented",  excpUnimplementedFeature )
#end if

end TLAVI8
