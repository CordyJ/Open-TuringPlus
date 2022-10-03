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
% Convert string to real8.  This routine is called from TLSVS8 and TLIGR.
%
% Right now, this is a total kludge ... check the string, then punt to atof()!
%

parent "TLA.ch"

stub procedure TLAVS8 (
	    source	: string,
	var answer	: real8,
	var error	: boolean,
	quitOnError	: boolean
	)

body procedure TLAVS8

    %
    % assume no errors
    %
    error := false

    var register src		: addressint	:= addr(source)
    var register exponent	: int2		:= 0
    var register digitCount	: int2		:= 0
    var sawDigit		: boolean	:= false

    const BadFormat := "String passed to \"strreal\" is not in correct format"

    %
    % Skip leading blanks
    %
    loop
	exit when char@(src) ~= ' '
	src += 1
    end loop

    %
    % Check for optional '-' or '+'.
    %
    if (char@(src) = '-') or (char@(src) = '+') then
	src += 1
    end if

    %
    % Skip leading 0's.
    %
    loop
	exit when char@(src) ~= '0'
	src += 1
	sawDigit := true
    end loop

    %
    % Process integer mantissa.
    %
    loop
	exit when (char@(src) < '0') or (char@(src) > '9')
	src += 1
	sawDigit := true
	digitCount += 1
    end loop

    if char@(src) = '.' then
	%
	% Process fraction mantissa.
	%
	src += 1
	loop
	    exit when (char@(src) < '0') or (char@(src) > '9')
	    src += 1
	    sawDigit := true
	end loop
    end if

    if not sawDigit then
	if quitOnError then
	    TLQUIT( BadFormat, excpStringFormatIncorrect)
	end if
	error := true
	return
    end if

    if (char@(src) = 'e') or (char@(src) = 'E') then
	%
	% Process exponent.
	%
	const maxExponentValue := 3000	% To prevent overflows
	var exponentNegative : boolean := false

	src += 1
	sawDigit := false

	%
	% Check for optional '-' or '+'.
	%
	if char@(src) = '-' then
	    src += 1
	    exponentNegative := true
	elsif char@(src) = '+' then
	    src += 1
	end if

	%
	% Skip leading '0's for efficiency.
	%
	loop
	    exit when char@(src) ~= '0'
	    src += 1
	    sawDigit := true
	end loop

	%
	% Process exponent value.
	%
	loop
	    exit when (char@(src) < '0') or (char@(src) > '9')
	    if exponent <= maxExponentValue then
		exponent *= 10
		exponent += nat1@(src) - #'0'
	    end if
	    src += 1
	    sawDigit := true
	end loop

	if not sawDigit then
	    if quitOnError then
		TLQUIT( BadFormat, excpStringFormatIncorrect)
	    end if
	    error := true
	    return
	end if

	if exponentNegative then
	    exponent := -exponent
	end if
    end if

    if char@(src) ~= '\0' then
	if quitOnError then
	    TLQUIT( BadFormat, excpStringFormatIncorrect)
	end if
	error := true
	return
    end if

    exponent += digitCount
#if IEEE or VAXFLOAT then
#if IEEE then
    if exponent < -310 then
#elsif VAXFLOAT then
    if exponent < -39 then
#end if
	if TLECU then
	    error := true
	    if quitOnError then
		TLQUIT( "String passed to \"strreal\" is too small to convert",
			excpRealUnderflow)
	    end if
	else
	    answer := 0
	end if

	return

#if IEEE then
    elsif exponent > 310 then
#elsif VAXFLOAT then
    elsif exponent > 39 then
#end if
	if quitOnError then
	    TLQUIT( "String passed to \"strreal\" is too large to convert",
		    excpRealOverflow)
	end if
	error := true
	return
    end if
#end if

    TLX.TLXATF(source, answer)

end TLAVS8
