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
% Convert string to int.
% This can be called from TLSVSI (pStrInt) in the CHECKED case,
% and also from TLIGI (pGetInt) and TLIGIB (pGetSubrange) in any case.
%
% Note that base is known to be valid.
%

parent "TLA.ch"

stub procedure TLAVSI (
	    source	: string,
	    base	: nat1,
	var answer	: int,
	var error	: boolean,
	quitOnError	: boolean
	)

body procedure TLAVSI

    error := false

    var register src	: addressint	:= addr(source)
    var register value	: nat		:= 0
    var isNegative	: boolean	:= false
    var maxValueDivBase	: nat
    var maxValueModBase	: nat1

    %
    % Skip leading blanks.
    %
    loop
	exit when char@(src) ~= ' '
	src += 1
    end loop

    %
    % Process optional '-' or '+'.
    %
    if char@(src) = '-' then
	src += 1
	isNegative := true
	maxValueDivBase := -(minint div base)
	maxValueModBase := -(minint mod base)
    else
	maxValueDivBase := maxint div base
	maxValueModBase := maxint mod base
	if char@(src) = '+' then
	    src += 1
	end if
    end if

    if char@(src) = '\0' then
	if quitOnError then
	    TLQUIT( "String passed to \"strint\" is not in correct format",
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
		TLQUIT( "Illegal character in string passed to \"strint\"",
			excpStringFormatIncorrect)
	    end if
	    error := true
	    return
	end if
	if (value > maxValueDivBase) or ((value = maxValueDivBase)
		and (digit > maxValueModBase)) then
	    if quitOnError then
		TLQUIT("Overflow in result of \"strint\"", excpIntegerOverflow)
	    end if
	    error := true
	    return
	end if

	unchecked
	value *= base
	value += digit
    end loop

    if isNegative then
	answer := -value
    else
	answer := value
    end if

end TLAVSI
