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

% Computer Systems Research Group
% University of Toronto
% Module:  Turing Plus Scanner/Parser  V1.0
% Author:  Mark Mendell
% Date:    24 Jan 1986

grant var Scanner, var nextToken, var nextTokenText, var nextTokenTextLen,
      var nextTokenValue, InputTokens, TokenValue, var dotOption,
      var noErrors, var aborted, var dummyIdentIndex, var processing,
      var scannerFileName, maxstr, sysexit, nargs, fetcharg, maxnat, maxint

var notice := "Copyright Univ of Toronto (c) 1986"

/*
 * system files
 */
include "%limits"
include "%system"


/* Scanner/Parser Limits */
include "scanparse.lim"

/* Dummy Identifier - used in syntax error recovery */
var dummyIdentIndex: int2 


/*
 * Scanner / Parser Interface
 * When the Parser requires the next token from the
 * input stream, it calls "Scanner.Scan" which scans
 * the next token and leaves the token number in
 * "nextToken".  The text and length of text for
 * identifiers, strings and char literals is
 * left in "nextTokenText" and "nextTokenTextLen".
 * The value of integer literals and identifier
 * indices is left in "nextTokenValue"
 */

type InputTokens : -1..255
const tNewLine := 153

var nextToken: InputTokens := tNewLine

/* Token Text */
var nextTokenTextLen: 0..maxstr+1 := 0
var nextTokenText: char(maxstr+1)

var scannerFileName: string := ""

const *maxIdentifierLength := 50

/* Token Value */
const *vInt := 0
const *vIntNat := 1
const *vNat := 2

type *ValueKinds : vInt..vNat

type TokenValue :
    record
	kind:	ValueKinds
	value:	nat4
	pred:	int2
    end record

var nextTokenValue: TokenValue

/* Scanner/Parser State */
var processing	:= true
var aborted	:= false

/* scanner "dot" option */
var dotOption	:= false

/* Error Counter */
const *maxErrors := 100
var noErrors: 0 .. maxErrors := 0

/* The Scanner */
child "scanner.st"

/* The Parser */
child "parser.st"
