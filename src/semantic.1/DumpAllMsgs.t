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

% Print a list of all error messages in Semantic pass 1

include "semantic.lim"
include "semantic.def.t"
include "semantic.def"
const *errorIdent := -1

module Ident 
    export PutIdent

    procedure PutIdent(id : int)
	put " \"Ident\" " ..
    end PutIdent
end Ident


procedure SemError (errCode: int)
    put "Error ", errCode, ": " ..

    if errCode >= firstWarningCode and
       errCode <  firstSeriousErrorCode then
	put "(Warning) " ..
    elsif errCode >= firstFatalErrorCode and
	   errCode <= lastErrorCode then
	put "(Implementation Restriction) " ..
    end if

    case errCode of
	include "semerr1.msg"
	label :
	    put "Unknown semantic error - ", errCode
    end case
end SemError

for count : firstErrorCode .. lastErrorCode
    SemError(count)
end for
