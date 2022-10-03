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
% Return a string in F format approximating source, padded on the left
% as necessary to a length of width.  Width is increased as necessary
% to hold the resulting string.  fWidth is the number of digits to be
% given after the decimal point.  The displayed value is rounded to
% fWidth fractional digits, with ties rounded up.
% The string returned is of the form:
%      {blank} [-] digit {digit} . {digit}
% We assume that width, fWidth are reasonable values.
% We check that the result fits in a string.  If it doesn't, error is
% set to true, otherwise error is false on return.  The resulting string
% is put in target.  If suppress is true, then trailing zeros in the
% fraction part are suppressed and if the fraction part is 0, the
% decimal point is also suppressed.
%

parent "TLA.ch"

stub procedure TLAVFS (
	    source	: real,
	    width	: int,
	    fWidth	: int,
	var target	: string,
	    suppress	: boolean,
	var error	: boolean
	)

body procedure TLAVFS

#if IEEE then
    begin
	%
	% Check for Inf and NaN values.
	%
	var hiOrder	: nat4
	var loOrder	: nat4

	TLAV8D (source, hiOrder, loOrder)

	if bits(hiOrder,Real8ExponentBits) = Real8IllegalExponent then
	    const mantissa	: nat4 := bits(hiOrder,Real8MantissaBits)
	    var register dst	: addressint := addr(target)

	    if mantissa = 0 and loOrder = 0 then
		for decreasing : width .. 4
		    char@(dst) := ' '
		    dst += 1
		end for
		if bits(hiOrder,Real8SignBit) = 0 then
		    % +Inf
		    char@(dst) := '+'
		    dst += 1
		else
		    % -Inf
		    char@(dst) := '-'
		    dst += 1
		end if
		char@(dst) := 'I'
		dst += 1
		char@(dst) := 'n'
		dst += 1
		char@(dst) := 'f'
		dst += 1
	    else
		% NaN
		for decreasing : width .. 3
		    char@(dst) := ' '
		    dst += 1
		end for
		char@(dst) := 'N'
		dst += 1
		char@(dst) := 'a'
		dst += 1
		char@(dst) := 'N'
		dst += 1
	    end if
	    char@(dst) := '\0'
	    error := false
	    return
	end if
    end
#end if

    var fractionString	: string
    var register src	: addressint
    var exponent	: int
    var negative	: boolean
    var giveDecPt	: boolean	:= true

    %
    % Convert fraction to string of digits.  Suppress trailing zeros
    % if suppression is specified.
    %
    TLAVRS (fractionString, source, fWidth, exponent, negative, false, error)
    if error then
	return
    end if

    if suppress then
	var register fWidthTaken : nat2 := fWidth

	src := addr(fractionString) + length(fractionString) - 1
	loop
	    exit when char@(src) ~= '0'
	    src -= 1
	    fWidthTaken -= 1
	    exit when fWidthTaken <= 0
	end loop
	if fWidthTaken = 0 then
	    giveDecPt := false
	end if
	src += 1
	char@(src) := '\0'
    end if

    %
    % Calculate width needed to print number as follows:
    %   widthNeeded := [sign] + [digits before decimal pt] + [decimal point]
    %		+ [digits after decimal point]
    %
    %   Note that sign is given only if '-', decimal point is not given
    %   in certain cases if suppress is true.
    %
    var widthNeeded	: nat2	:= length(fractionString)

    if negative then
	widthNeeded += 1
    end if
    if giveDecPt then
	widthNeeded += 1
    end if
    if exponent <= 0 then
	widthNeeded += 1 - exponent
    end if

    if widthNeeded > upper(target) then
	error := true
	return
    end if

    var register dst	: addressint	:= addr(target)

    %
    % Pad with leading blanks.
    %
    for decreasing : width - widthNeeded .. 1
	char@(dst) := ' '
	dst += 1
    end for

    %
    % Add '-' if negative.
    %
    if negative then
	char@(dst) := '-'
	dst += 1
    end if

    %
    % Copy in the digits of the fraction, inserting the decimal point
    % in the appropriate place.
    %
    src := addr(fractionString)
    if exponent > 0 then
	for decreasing : exponent .. 1
	    char@(dst) := char@(src)
	    dst += 1
	    src += 1
	end for
	if giveDecPt then
	    char@(dst) := '.'
	    dst += 1
	end if
    else
	char@(dst) := '0'
	dst += 1
	if giveDecPt then
	    char@(dst) := '.'
	    dst += 1
	    for : exponent .. -1
		char@(dst) := '0'
		dst += 1
	    end for
	end if
    end if
    loop
	char@(dst) := char@(src)
	dst += 1
	exit when char@(src) = '\0'
	src += 1
    end loop

end TLAVFS
