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
% pGetCharString
%

parent "TLI.ch"

stub procedure TLIGC (
	    getWidth	: int,
	var getItem	: char(*),	% Implicit 2nd size parameter
	    streamNo	: int2
	)

body procedure TLIGC

#if CHECKED then
    if getWidth < 0 then
	TLQUIT(  "Negative get width specified",
	         excpNegativeFieldWidthSpecified )
    end if
    if getWidth > upper(getItem) then
	TLQUIT(  "Get item width greater than item size",
	         excpGetWidthTooLargeForParameter )
    end if
#end if

    if getWidth = 0 then
	return
    end if

    bind var register stream to TLIS(streamNo)

    var register dst	: addressint	:= addr(getItem)
    const lastAddr	: addressint	:= addr(getItem) + getWidth

    if stream.atEof then
	loop
	    char@(dst) := '\0'
	    dst += 1
	    exit when dst >= lastAddr
	end loop
	return
    end if

    var register ch : Cint

    loop
	ch := TLIFGC(stream.info)
	if ch = EndOfFileChar then
	    stream.atEof := true
	    loop
		char@(dst) := '\0'
		dst += 1
		exit when dst >= lastAddr
	    end loop
	    return
	end if

	nat1@(dst) := #ch
	dst += 1

	exit when dst >= lastAddr
    end loop

end TLIGC
