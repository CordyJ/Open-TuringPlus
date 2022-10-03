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

module Ident
    import identFile, statistics
    export PutIdent, InitIdent, IdentStats

    %  File:    Turing Plus Identifier Handler for Semantic Pass 1 V1.00
    %	Author:  S.G. Perelgut, M. Mendell
    %	Date: 12 march 1986

    /* The Ident Table */
    var identChars: char(maxIdentChars+maxIdents)
    var identTop: 0..maxIdents-1 := 0
    var identIndex: array 0..maxIdents-1 of 1..maxIdentChars+maxIdents


    procedure IdentStats
	put "Ident\n\tNumber of Identifiers = ", identTop, "/", maxIdents
    end IdentStats

    procedure PutIdent (ident: int)
	pre ident >= 0
	if ident > identTop then
	    identTop := ident
	end if
	var register i := identIndex(ident)
	loop
	    exit when identChars(i) = '\n'
	    i += 1
	end loop

	put "'", identChars(identIndex(ident)..i-1), "'" ..
    end PutIdent


    procedure InitIdent
	var register identCharsTop : 1..maxIdentChars+maxIdents+1 := 1
	var s : string
	for i : 0..maxIdents-1
	    get :identFile, s:*
	    bind register st to s
	    identIndex(i) := identCharsTop
	    for j : 1..length(st)
		identChars(identCharsTop) := st(j)
		identCharsTop += 1
	    end for
	    identChars(identCharsTop) := '\n'
	    identCharsTop += 1
	end for
	close (identFile)
    end InitIdent
end Ident
