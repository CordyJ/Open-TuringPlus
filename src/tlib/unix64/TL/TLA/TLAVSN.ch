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
% Convert string to nat.
% This can be called from TLSVSN (pStrNat) in the CHECKED case,
% and also from TLIGN (pGetNat) in any case.
%
% Note that base is known to be valid.
%

parent "TLA.ch"

stub procedure TLAVSN (
	    source	: string,
	    base	: nat1,
	var answer	: nat,
	var error	: boolean,
	quitOnError	: boolean
	)

body procedure TLAVSN

    error := false

    var register src	: addressint	:= addr(source)
    var register value	: nat		:= 0
    const maxValueDivBase : nat		:= maxnat div base
    const maxValueModBase : nat1	:= maxnat mod base

    %
    % Skip leading blanks.
    %
    loop
	exit when char@(src) ~= ' '
	src += 1
    end loop

    %
    % Process optional '+'.
    %
    if char@(src) = '+' then
	src += 1
    end if

    if char@(src) = '\0' then
	if quitOnError then
	    TLQUIT( "String passed to \"strnat\" is not in correct format",
		    excpStringFormatIncorrect)
	end if
	error := true
	return
    end if

    %
    % Skip leading '0's for efficiency.
    %
    loop
	exit when char@(src) ~= '0'
	src += 1
    end loop

    %
    % Process value.
    %
    loop
	var register digit : nat1 := nat1@(src)
	src += 1
	exit when digit = #'\0'

	if (digit >= #'0') and (digit <= #'9') then
	    digit -= #'0'
	elsif (digit >= #'A') and (digit <= #'I') then
	    digit -= #'A' - 10
	elsif (digit >= #'a') and (digit <= #'i') then
	    digit -= #'a' - 10
	elsif (digit >= #'J') and (digit <= #'R') then
	    digit -= #'J' - 19
	elsif (digit >= #'j') and (digit <= #'r') then
	    digit -= #'j' - 19
	elsif (digit >= #'S') and (digit <= #'Z') then
	    digit -= #'S' - 28
	elsif (digit >= #'s') and (digit <= #'z') then
	    digit -= #'s' - 28
	else
	    error := true
	end if
	if error or (digit >= base) then
	    if quitOnError then
		TLQUIT( "Illegal character in string passed to \"strnat\"",
			excpStringFormatIncorrect)
	    end if
	    error := true
	    return
	end if
	if (value > maxValueDivBase) or ((value = maxValueDivBase)
		and (digit > maxValueModBase)) then
	    if quitOnError then
		TLQUIT( "Overflow in result of \"strnat\"",
			excpIntegerOverflow )
	    end if
	    error := true
	    return
	end if

	unchecked
	value *= base
	value += digit
    end loop

    answer := value

end TLAVSN
