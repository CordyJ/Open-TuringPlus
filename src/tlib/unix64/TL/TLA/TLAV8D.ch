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
% Convert a real8 into its hiOrder and loOrder longwords.
% This is done by examining the real representation of 1.0 at
% initialization time and intuiting the ordering.  This may be
% overridden machine-dependently if this test does not work.
%

parent "TLA.ch"

stub procedure TLAV8D (
	    value	: real8,
	var hiOrder	: nat4,
	var loOrder	: nat4
	)

body procedure TLAV8D

#if IEEE then
    if TLA8HI not= TLA8LO then
	type LongArray : array 0 .. 1 of nat4

	hiOrder := type(LongArray,value)(TLA8HI)
	loOrder := type(LongArray,value)(TLA8LO)
    else
	TLQUIT( "TLAV8D unimplemented",  excpUnimplementedFeature )
    end if
#else
    TLQUIT( "TLAV8D unimplemented",  excpUnimplementedFeature )
#end if

end TLAV8D
