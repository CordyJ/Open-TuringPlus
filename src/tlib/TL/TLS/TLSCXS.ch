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
% pSubStringCharExpnStar
%

parent "TLS.ch"

stub procedure TLSCXS (
	    source	: char(*),	% Implicit 2nd size parameter
	    startIndex	: int,
	    endOffset	: int,
	var target	: string
	)

body procedure TLSCXS

#if CHECKED then
    TLSCXX (source, startIndex, upper(source)+endOffset, target)
#else
    var register dst : addressint := addr(target)
    var register src : addressint := addr(source(startIndex))
    const lastAddr   : addressint := addr(source(*--endOffset))

    loop
	exit when src > lastAddr
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop
    char@(dst) := '\0'
#end if

end TLSCXS
