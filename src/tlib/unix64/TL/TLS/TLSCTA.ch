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
% pStringConcatenateAssign
%

parent "TLS.ch"

stub procedure TLSCTA (
	var target	: string(*),	% Implicit second parameter
	    right	: string
	)

body procedure TLSCTA

    var register dst	: addressint
    var firstAddr	: addressint
#if CHECKED then
    const lastAddr	: addressint := addr(target) + upper(target)
#end if

    var register src	: addressint := addr(right)

    %
    % Check if right is a string of at least length one.
    % We don't want to extend target right away, since that might also
    % be extending right (if addr(right) = addr(target), so we start
    % the copy from the second char and put the first char in last.
    %
    const firstChar	: char := char@(src)

    if firstChar = '\0' then
	return
    end if
    src += 1

    %
    % Find the end of the target and go one past.
    %
    dst := addr(target)
    loop
	exit when char@(dst) = '\0'
	dst += 1
    end loop
    firstAddr := dst
    dst += 1

    loop
	exit when char@(src) = '\0'
#if CHECKED then
	if dst >= lastAddr then
	    % Leave something reasonable for recovery.
	    char@(dst) := '\0'
	    char@(firstAddr) := firstChar

	    TLQUIT( "Result of string concatenation assign exceeds maximum length of string",
	             excpStringValueTooLarge )
	end if
#end if
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop

    char@(dst) := '\0'
    char@(firstAddr) := firstChar

end TLSCTA
