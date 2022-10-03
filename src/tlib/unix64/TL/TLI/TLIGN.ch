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
% pGetNat
%

parent "TLI.ch"

stub procedure TLIGN (
	    getItem	: addressint,
	    itemSize	: int,
	    streamNo	: int2
	)

body procedure TLIGN

    var token : string
    var value : nat
    var error : boolean

    TLIGT (streamNo, token)

    TLA.TLAVSN (token, 10, value, error, false /*don't quit on error*/)
    if error then
	TLQUIT(  "Invalid nat input",
	         excpGetItemIllegal )
    end if

    if itemSize = 4 then
	nat4@(getItem) := value
    elsif itemSize = 2 then
	unchecked
	nat2@(getItem) := value
	if nat2@(getItem) ~= value then
	    TLQUIT( "Integer value too large for nat2 variable",
	             excpGetItemIllegal )
	end if
    else % itemSize = 1
	unchecked
	nat1@(getItem) := value
	if nat1@(getItem) ~= value then
	    TLQUIT( "Integer value too large for nat1 variable",
	             excpGetItemIllegal )
	end if
    end if

end TLIGN
