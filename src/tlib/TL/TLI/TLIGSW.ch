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
% pGetStringWidth
%

parent "TLI.ch"

stub procedure TLIGSW (
	    itemSize	: int,
	    getWidth	: int,
	    getItem	: addressint,
	    streamNo	: int2
	)

body procedure TLIGSW

#if CHECKED then
    if getWidth < 0 then
	TLQUIT( "Negative get width specified",
		excpNegativeFieldWidthSpecified )
    end if
    if getWidth > itemSize then
	TLQUIT( "Width specified is longer than string variable size",
		excpGetWidthTooLargeForParameter )
    end if
#end if

    bind var register stream to TLIS(streamNo)

    var register dst	: addressint	:= getItem
    const lastAddr	: addressint	:= dst + getWidth

    if (getWidth = 0) or stream.atEof then
	char@(dst) := '\0'
	return
    end if

    var register ch : Cint

    loop
	ch := TLIFGC(stream.info)
	if ch = EndOfFileChar then
	    stream.atEof := true
	    exit
	end if

	if (ch and 16#7F) = 0 then
	    char@(dst) := '\0'
	    TLQUIT( "Illegal character in string", excpGetItemIllegal )
	end if

	char@(dst) := chr(ch)
	dst += 1

	exit when (chr(ch) = '\n') or (dst >= lastAddr)
    end loop
    char@(dst) := '\0'

end TLIGSW
