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
% pSubStringCharExpnExpn
%

parent "TLS.ch"

stub procedure TLSCXX (
	    source	: char(*),	% Implicit 2nd size parameter
	    startIndex	: int,
	    endIndex	: int,
	var target	: string
	)

body procedure TLSCXX

#if CHECKED then
    if startIndex <= 0 then
	TLQUIT( "Left bound of substring is less than 1",
	         excpInvalidSubscriptCharString )
    end if
    if (startIndex - endIndex) > 1 then
	TLQUIT( "Left bound of substring exceeds right bound by more than 1",
	         excpLeftSubstringBoundExceedsRight )
    end if
    if endIndex > upper(source) then
	TLQUIT( "Right bound of substring greater than array size",
	         excpInvalidSubscriptCharString )
    end if
    if (endIndex - startIndex) >= upper(target) then
	TLQUIT( "Substring too large to fit into string",
	         excpResultStringTooBig )
    end if
#end if

    var register dst : addressint := addr(target)
    var register src : addressint := addr(source(startIndex))
    const lastAddr   : addressint := addr(source(endIndex))

    loop
	exit when src > lastAddr
#if CHECKED then
	%
	% Check if 0 (EndOfStringChar) or 128 (UninitChar)
	%
	if (nat1@(src) and 16#7F) = 0 then
	    TLQUIT(  "Illegal character in substring",
	             excpIllegalValueInStringConversion )
	end if
#end if
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop
    char@(dst) := '\0'

end TLSCXX
