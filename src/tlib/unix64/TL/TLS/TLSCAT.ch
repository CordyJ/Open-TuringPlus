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
% pStringConcatenate
%

parent "TLS.ch"

stub procedure TLSCAT (
	    left	: string,
	    right	: string,
	var target	: string
	)
	import maxstr, TLQUIT

body procedure TLSCAT

    var register dst	: addressint := addr(target)
#if CHECKED then
    const lastAddr	: addressint := addr(target) + maxstr %% upper(target)
#end if

    var register src	: addressint := addr(left)

    loop
	exit when char@(src) = '\0'
#if CHECKED then
	if dst >= lastAddr then
	    TLQUIT( "Initial string in string concatenation exceeds maximum length of string",
	             excpStringValueTooLarge )
	end if
#end if
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop

    src := addr(right)

    loop
	exit when char@(src) = '\0'
#if CHECKED then
	if dst >= lastAddr then
	    TLQUIT( "Result of string concatenation exceeds maximum length of string",
	             excpStringValueTooLarge )
	end if
#end if
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop

    char@(dst) := '\0'

end TLSCAT
