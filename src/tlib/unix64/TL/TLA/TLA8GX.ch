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
% Return the exponent of the given real number.
%

parent "TLA.ch"

stub function TLA8GX (
	    value	: real8
	)	: int

body function TLA8GX

    if value = 0 then
	result 0
    end if

#if IEEE then
    var hiOrder, loOrder : nat4

    TLAV8D (value, hiOrder, loOrder)

    result type(int,bits(hiOrder,Real8ExponentBits):4) - (Real8ExponentBias - 1)

#elsif VAXFLOAT then
    var hiOrder, loOrder : nat4

    TLAV8D (value, hiOrder, loOrder)

    result type(int,bits(loOrder,Real8ExponentBits):4) - Real8ExponentBias

#elsif IBMFLOAT then
    var hiOrder, loOrder : nat4

    TLAV8D (value, hiOrder, loOrder)

    result type(int,bits(hiOrder,Real8ExponentBits):4) - Real8ExponentBias

#else
    TLQUIT( "TLA8GX unimplemented",  excpUnimplementedFeature )
#end if

end TLA8GX
