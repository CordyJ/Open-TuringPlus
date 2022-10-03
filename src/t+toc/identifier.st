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

parent "t+toc.t"

stub module Identifier
    import var Token, var strings, prefixIdentifiers, var maxIdentSeen
    export OutputIdentifier, SetIdentText, ReadMapNames, String,
	   OverrideIdentText, AppendText, PushName, PopName, PushBoundary,
	   EnterName

    %   Turing Plus to C Translator
    %   Module:Identifier Name Module
    %   By:    Mark Mendell
    %   Date:  30 Oct 1986

    procedure OutputIdentifier (i : int, stream : int)

    function String (i : int) : string

    procedure SetIdentText (i : int, s : TokenString, slen : int)

    procedure AppendText (id : int, s : char(*))

    procedure OverrideIdentText (i : int, s : TokenString, slen : int)

    procedure ReadMapNames

    procedure PushName(i : int)

    procedure PushBoundary

    procedure PopName

    procedure EnterName(i : int)

end Identifier
