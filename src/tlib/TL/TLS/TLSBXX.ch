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
% pSubStringExpnExpn
%

parent "TLS.ch"

stub procedure TLSBXX (
	var target	: string,
	    endIndex	: int,
	    startIndex	: int,
	    source	: string
	)

body procedure TLSBXX

#if CHECKED then
    if startIndex <= 0 then
	TLQUIT( "Left bound of substring is less than 1",
	         excpInvalidSubscriptCharString )
    end if
    if (startIndex - endIndex) > 1 then
	TLQUIT( "Left bound of substring exceeds right bound by more than 1",
	         excpLeftSubstringBoundExceedsRight )
    end if
    if endIndex > length(source) then
	TLQUIT( "Right bound of substring is greater than length of string",
	         excpInvalidSubscriptCharString )
    end if
#end if

    var register dst : addressint := addr(target)
    var register src : addressint := addr(source) + startIndex - 1
    const lastAddr   : addressint := addr(source) + endIndex

    loop
	exit when src >= lastAddr
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop
    char@(dst) := '\0'

end TLSBXX
