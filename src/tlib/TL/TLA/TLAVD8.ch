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
% Convert the hiOrder and loOrder longwords of a real8 into a real8.
% This is machine dependent, since it depends on the order of the
% longwords within the real8.  However, the ordering can be run-time
% intuited.  See TLA.var and TLA.def for details.
%

parent "TLA.ch"

stub procedure TLAVD8 (
	    hiOrder	: nat4,
	    loOrder	: nat4,
	var answer	: real8
	)

body procedure TLAVD8

#if IEEE then
    if TLA8HI not= TLA8LO then
	type LongArray : array 0 .. 1 of nat4

	type(LongArray,answer)(TLA8HI) := hiOrder
	type(LongArray,answer)(TLA8LO) := loOrder
    else
	TLQUIT( "TLAVD8 unimplemented",  excpUnimplementedFeature )
    end if
#else
    TLQUIT( "TLAVD8 unimplemented",  excpUnimplementedFeature )
#end if

end TLAVD8
