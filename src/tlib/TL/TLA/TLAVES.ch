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
% Return a string in E format approximating source, padded on the left
% as necessary to a length of width.  Width is increased as necessary
% to hold the resulting string.  fWidth is the number of digits to be
% given after the decimal point.  The displayed value is rounded to
% fWidth fractional digits, with ties rounded up.  eWidth is the
% number of exponent digits to be displayed; if it is larger than
% necessary, leading zeros are added to the exponent; if it is too
% small, it is increased as necessary.
% The string returned is of the form:
%      {blank} [-] digit . {digit} e sign digit {digit}
% We assume that width, fWidth, eWidth are all reasonable values.
% We check that the result fits in a string.  If it doesn't, error is
% set to true, otherwise error is false on return.  The resulting string
% is put in target.  If suppress is true, then trailing zeros in the
% fraction part are suppressed and if the fraction part is 0, the
% decimal point is also suppressed.  Leading zeros in the exponent are
% suppressed, and if the exponent sign is "+", it is suppressed.
%

parent "TLA.ch"

stub procedure TLAVES (
	    source	: real,
	    width	: int,
	    fWidth	: int,
	    eWidth	: int,
	var target	: string,
	    suppress	: boolean,
	var error	: boolean
	)

body procedure TLAVES

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
    var fWidthTaken	: nat2
    var giveDecPt	: boolean	:= true

    %
    % Convert fraction to string of digits.  Suppress trailing zeros
    % if suppression is specified.  Modify exponent so the implicit
    % decimal point is after the first digit in fractionString.
    %
    TLAVRS (fractionString, source, fWidth + 1, exponent, negative, true, error)
    if error then
	return
    end if

    if suppress then
	src := addr(fractionString) + fWidth
	for decreasing : fWidth .. 1
	    exit when char@(src) ~= '0'
	    src -= 1
	end for
	fWidthTaken := src - addr(fractionString)
	if fWidthTaken = 0 then
	    giveDecPt := false
	end if
	src += 1
	char@(src) := '\0'
    else
	fWidthTaken := fWidth
    end if
    if source ~= 0 then
	exponent -= 1
    end if

    %
    % Convert the exponent to a string, set eWidthNeeded to the
    % width needed to print it, and set eWidthTaken to eWidthNeeded
    % if suppress is specified.
    %
    var exponentString	: string(11)	:= intstr(abs(exponent))
    var eWidthNeeded	: nat2		:= length(exponentString)
    var eWidthTaken	: nat2

    if (eWidthNeeded > eWidth) or suppress then
	eWidthTaken := eWidthNeeded
    else
	eWidthTaken := eWidth
    end if

    %
    % Calculate width needed to print number as follows:
    %   widthNeeded := [sign] + [digit before decimal pt] + [decimal point]
    %		+ [digits after decimal point] + ['E'] + [exponent sign]
    %		+ [exponent]
    %
    %   Note that sign is given only if '-', decimal point is not given
    %   in certain cases if suppress is true, exponent sign is not given
    %   if '+' and suppress.
    %
    var widthNeeded	: nat2	:= 2 + fWidthTaken + eWidthTaken

    if negative then
	widthNeeded += 1
    end if
    if giveDecPt then
	widthNeeded += 1
    end if
    if (exponent < 0) or not suppress then
	widthNeeded += 1
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
    % Copy in leading digit, adding a '.' if necessary, then copy in
    % remaining digits.
    %
    src := addr(fractionString)
    char@(dst) := char@(src)
    dst += 1
    src += 1

    if giveDecPt then
	char@(dst) := '.'
	dst += 1
    end if

    loop
	exit when char@(src) = '\0'
	char@(dst) := char@(src)
	dst += 1
	src += 1
    end loop

    %
    % Add the exponent.  Do not add a sign if positive and suppress is true.
    %
    char@(dst) := 'e'
    dst += 1

    if exponent < 0 then
	char@(dst) := '-'
	dst += 1
    elsif not suppress then
	char@(dst) := '+'
	dst += 1
    end if

    for decreasing : eWidthTaken - eWidthNeeded .. 1
	char@(dst) := '0'
	dst += 1
    end for

    %
    % Now add exponent digits.
    %
    src := addr(exponentString)
    loop
	char@(dst) := char@(src)
	dst += 1
	exit when char@(src) = '\0'
	src += 1
    end loop

end TLAVES
