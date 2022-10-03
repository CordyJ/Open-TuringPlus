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
% pIntStr
%

parent "TLS.ch"

stub procedure TLSVIS (
	    value	: int,
	    width	: int,
	    base	: int,
	var target	: string
	)

body procedure TLSVIS

#if CHECKED then
    if width < 0 then
	TLQUIT(  "Negative width passed to \"intstr\"",
	         excpNegativeFieldWidthSpecified )
    end if
    if width > upper(target) then
	TLQUIT( "String generated by \"intstr\" is too long",
	         excpResultStringTooBig )
    end if
    if (base < 2) or (base > 36) then
	TLQUIT( "Illegal conversion base passed to \"intstr\"",
	         excpIllegalStringConversionBase )
    end if
#end if

    var buffer		: string
    var register buf	: addressint	:= addr(buffer) + upper(buffer)
    var register count	: int		:= 1

    %
    % Generate the string in reversed order.
    %
    if value < 0 then
	var register tmp : int := value

	loop
	    buf -= 1
	    nat1@(buf) := - (tmp mod base)
	    if nat1@(buf) < 10 then
		nat1@(buf) += #'0'
	    else
		nat1@(buf) += #'A' - 10
	    end if
	    tmp div= base
	    exit when tmp = 0
	    count += 1
	end loop
	buf -= 1
	char@(buf) := '-'
	count += 1
    else
	var register tmp : int := value

	loop
	    buf -= 1
	    nat1@(buf) := tmp mod base
	    if nat1@(buf) < 10 then
		nat1@(buf) += #'0'
	    else
		nat1@(buf) += #'A' - 10
	    end if
	    tmp div= base
	    exit when tmp = 0
	    count += 1
	end loop
    end if

    var register dst	: addressint	:= addr(target)

    %
    % Insert appropriate number of spaces.
    %
    for decreasing : width - count .. 1
	char@(dst) := ' '
	dst += 1
    end for

    %
    % Insert translated string from buffer.
    %
    loop
	char@(dst) := char@(buf)
	dst += 1
	buf += 1
	count -= 1
	exit when count = 0
    end loop

    char@(dst) := '\0'

end TLSVIS
