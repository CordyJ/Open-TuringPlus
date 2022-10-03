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
% Convert a double to a string in decimal.  If eFormat is true,
% digitCount is the total number of digits to convert.  If eFormat
% is false, digitCount is the number of digits after the decimal
% point to convert.  Exponent is set to the position of the decimal
% point relative to the beginning of the string (negative values
% mean to the left of the string).  Negative is set according to the
% source value.
%
% The result is rounded to the number of digits specified; ties are
% rounded up
%

parent "TLA.ch"

stub procedure TLAVRS (
	var target	: string,
	    source	: real8,
	    digitCount	: int,
	var exponent	: int,
	var negative	: boolean,
	    eFormat	: boolean,
	var error	: boolean
	)

body procedure TLAVRS

    TLQUIT( "TLAVRS unimplemented",  excpUnimplementedFeature )

end TLAVRS
