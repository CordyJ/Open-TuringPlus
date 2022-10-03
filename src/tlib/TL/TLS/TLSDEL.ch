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
% pStrDelete
%

parent "TLS.ch"

stub procedure TLSDEL (
	var target	: string(*),	% Implicit 2nd size parameter
	    delLength	: int,
	    dstIndex	: int
	)

body procedure TLSDEL

    const srcIndex := dstIndex + delLength

#if CHECKED then
    if dstIndex <= 0 then
	TLQUIT( "Starting index of \"strdelete\" is less than 1",
	         excpInvalidSubscriptCharString )
    end if
    if srcIndex > (length(target) + 1) then
	TLQUIT( "Attempt to \"strdelete\" past the string length",
	         excpInvalidSubscriptCharString )
    end if
#end if

    if delLength > 0 then
	%
	% We actually have to do something!
	%
	var register dst : addressint := addr(target) + dstIndex - 1
	var register src : addressint := addr(target) + srcIndex - 1

	loop
	    char@(dst) := char@(src)
	    dst += 1
	    exit when char@(src) = '\0'
	    src += 1
	end loop
    end if

end TLSDEL
