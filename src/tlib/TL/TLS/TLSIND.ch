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
% pIndex
%

parent "TLS.ch"

stub function TLSIND (
	    source	: string,
	    pattern	: string
	)	: int

body function TLSIND

    const firstPatternChar := char@(addr(pattern))

    if firstPatternChar = '\0' then
	%
	% Empty pattern.
	%
	result 1
    end if

    var register src : addressint := addr(source)

    loop
	exit when char@(src) = '\0'

	if char@(src) = firstPatternChar then
	    %
	    % Potential match.  Check out the rest of pattern.
	    %
	    var register chk : addressint := src + 1
	    var register pat : addressint := addr(pattern) + 1

	    loop
		if char@(pat) = '\0' then
		    %
		    % Successful match
		    %
		    result src - addr(source) + 1
		end if
		exit when char@(pat) ~= char@(chk)
		pat += 1
		chk += 1
	    end loop
	end if

	src += 1
    end loop

    result 0

end TLSIND
