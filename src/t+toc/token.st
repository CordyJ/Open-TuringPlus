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
stub module Token
     import maxstr, Error, var LineInfo, var currentLineNumber, tNode
     export In, TokenType, FileNameType, Dump, TokenToString

    %   Turing Plus to C Translator
    %  Module:Token: Token input & output.
    %   By:    Mark Mendell
    %   Date:  28 Oct 1986

     type FileNameType:       string %% (MaxStringTokenSize)
     type TokenType   :
	 record 
	    tokenKind:		int
	    intValue:		int4
	    intKind:		int
	    stringText:		TokenString
	    stringLen:		0..maxstr+1
	    ident:		int
	    predefinedIdent:int
	 end record 


     procedure In (var t : TokenType, stream : int)

     procedure Dump (t : TokenType, stream : int)

     function TokenToString (n : int) : string

end  Token
