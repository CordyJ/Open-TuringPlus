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
% pStrReplaceS
%

parent "TLS.ch"

stub procedure TLSRES (
	var target	: string(*),	% Implicit 2nd size parameter
	    source	: string,
	    dstIndex	: int,
	    rplLength	: int
	)

body procedure TLSRES

#if CHECKED then
    const tgtLength := length(target)

    if dstIndex <= 0 then
	TLQUIT( "Starting index of \"strreplace\" is less than 1",
	         excpInvalidSubscriptCharString )
    end if
    if rplLength < 0 then
	TLQUIT( "Replacement length for \"strreplace\" is less than 0",
	         excpStringReplaceLengthNegative )
    end if
    if rplLength > (tgtLength - dstIndex + 1) then
	TLQUIT( "Attempt to \"strreplace\" past the string length",
	         excpInvalidSubscriptCharString )
    end if
#end if

    const extraSpace := length(source) - rplLength

    var register dst : addressint
    var register src : addressint

    if extraSpace > 0 then
	%
	% Must make room in target.
	%
#if CHECKED then
	if (tgtLength + extraSpace) > upper(target) then
	    TLQUIT( "Result of \"strreplace\" is larger than string size",
	             excpResultStringTooBig )
	end if
#else
	const tgtLength := length(target)
#end if
	dst := addr(target) + tgtLength + extraSpace + 1
	src := addr(target) + tgtLength + 1
	const lastAddr : addressint := addr(target) + dstIndex + rplLength

	loop
	    dst -= 1
	    src -= 1
	    char@(dst) := char@(src)
	    exit when src < lastAddr
	end loop
    end if

    %
    % Copy source to hole in target.
    %
    dst := addr(target) + dstIndex - 1
    src := addr(source)

    loop
	exit when char@(src) = '\0'
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop

    if extraSpace < 0 then
	%
	% Must close up the hole in target.
	%
	src := dst - extraSpace
	loop
	    char@(dst) := char@(src)
	    dst += 1
	    exit when char@(src) = '\0'
	    src += 1
	end loop
    end if

end TLSRES
