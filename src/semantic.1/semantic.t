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

% This is the first semantic pass of the Turing Plus compiler

grant statistics, Error, stabInformation, stabStream, sysexit,
    var firstErrorFound, var noErrors, lineNumber, sourceFileName,
    errorIdent, var emitNewLineNumber, tracing, traceFile, maxstr, printWarnings
#if not PC then
    , Ident
#end if

var notice := "Copyright Univ of Toronto (c) 1986"

include "%system"
include "%limits"

include "semantic.def.t"

% Semantic Pass Limits 
include "semantic.glb"

% Primitive S/SL Table Operations:
% These will remain the same independent of the
% pass and form the fundamental table operations.
const *firstTableOperation := 0
const *firstPrimitiveOperation := 0
const *oCall := 0
const *oReturn := 1
const *oRuleEnd := 2
const *oJump := 3
const *oInput := 4
const *oInputAny := 5
const *oInputChoice := 6
const *oEmit := 7
const *oError := 8
const *oChoice := 9
const *oChoiceEnd := 10
const *oSetParameter := 11
const *oSetResult := 12
const *oSetResultFromInput := 13
const *lastPrimitiveOperation := 13

const *lastTableOperation := lastSemanticOperation

include "semantic.def"

% Table Walker State 
var sslPointer := 0
var operation: firstTableOperation .. lastTableOperation

% The S/SL Rule Call Stack:
% The Rule Call Stack implements Syntax/Semantic
% Language rule call and return.
% Each time an oCall operation is executed,
% the table return address is pushed onto the
% Rule Call Stack.  When an oReturn is executed,
% the return address is popped from the stack.
% An oReturn executed when the Rule Call Stack is
% empty terminates table execution.

const *sslStackSize := 511
var sslStack: array 1 .. sslStackSize of int

% Choice Match Flag:
% Set by the Choice Handler to indicate whether
% a match was made or the otherwise path was taken.
% Set to true if a match was made and false otherwise.
% This flag is used in input choices to indicate
% whether the choice input token should be accepted or
% not.

var choiceTagMatched: boolean

% Parameterized And Choice Semantic Operation Values:
% These are used to hold the decoded parameter value to
% a parameterized semantic operation and the result
% value returned by a choice semantic operation
% or rule respectively.
var parameterValue: int4
var resultValue: int4

% Error Identifier Index 
var noErrors: 0 .. maxErrors := 0

var errorIdent: int
const *noIdent := -1

var printWarnings := true

% Input Interface 
const inStream := 1

% Next Input Token 
var nextToken: InputTokens := firstNonCompoundToken  % arbitrary non-compound

% The Compound Token Buffer
% When a compound token is accepted by the pass,
% the token and its associated value are 
% saved for later access by the semantic operations.

var compoundToken: InputTokens
var compoundTokenValue: InputTokenValue

% Line Counters 
var nextLineNumber: nat2 := 0
var lineNumber: nat2
var emitNewLineNumber := false

% Current Input File 
var nextSourceFileName: string
var sourceFileName:	string := ""
var newSourceFile	:= false
var emitNewSourceFile	:= false

#if not PC then
% ident file index 
const identFile := 3

include "ident.mod"

var firstErrorFound := false	% used to save init cost on correct pgms
#end if

type *ErrorCodes : firstErrorCode .. lastErrorCode

% procedure Error 
child "error.st"

procedure ReadInputString (slength : 0..maxstr, var svalue: char(*))
    read :inStream, svalue: slength
end ReadInputString

% The Semantic Mechanisms of the Semantic Pass 

procedure AcceptInputToken
    var acceptedToken: nat1

    % Accept Token
    acceptedToken := nextToken
    lineNumber := nextLineNumber

    if newSourceFile then
	sourceFileName := nextSourceFileName
	newSourceFile := false
    end if

    if acceptedToken >= firstCompoundToken and 
	    acceptedToken <= lastCompoundToken then
	compoundToken := acceptedToken

	case compoundToken of
	    label aIdent, aPredefinedId :
		read :inStream, compoundTokenValue.identIndex
		if compoundToken = aPredefinedId then
		    read :inStream, compoundTokenValue.predefinedIdentIndex
		end if

	    label aIntegerLit :
		read :inStream, compoundTokenValue.integerKind,
		    compoundTokenValue.val

	    label aIdentText, aStringLit, aRealLit, aCharLit :
		read :inStream, compoundTokenValue.stringLen
		ReadInputString (compoundTokenValue.stringLen,
				 compoundTokenValue.stringText)
	end case
    end if

    % Get Next Input Token
    loop
	if acceptedToken = aEndOfFile then
	    nextToken := aEndOfFile
	    exit
	end if
	var tempToken : nat1
	read :inStream, tempToken
	nextToken := tempToken

	if nextToken = aNewLine then
	    read :inStream, nextLineNumber
	elsif nextToken = aNewFile then
	    var tlen : nat2
	    var tbuf : char(maxstr)

	    newSourceFile := true
	    emitNewSourceFile := true
	    read :inStream, tlen
	    ReadInputString (tlen, tbuf)
	    nextSourceFileName := tbuf(1..tlen)
	else
	    exit
	end if
    end loop

#if DEBUG then
    % Trace Input
    if tracing then
	put :traceFile, "Input token accepted ", acceptedToken,
	    ";  Line ", lineNumber, " of ", sourceFileName,
	    ";  Next input token ", nextToken
    end if
#end if
end AcceptInputToken


% The Mechanisms 
child "context.st"
child "symbol.st"
child "type.st"
child "count.st"
child "loop.st"
child "actuals.st"
child "scope.st"
child "predefined.st"
child "emit.st"


procedure CheckSemanticMechanisms
    assert Scope.ScoStackEmpty
    assert Symbol.SymStackEmpty
    assert Types.TypStackEmpty
    assert Count.CouStackEmpty
    assert Loop.LoopDepth = 0
    assert Actuals.ActStackEmpty
    assert Emit.EmiStackEmpty
    assert Context.ConFinally
end CheckSemanticMechanisms

% The S/SL Table 
include "semantic.sst.t"


#if DEBUG then
procedure SslTrace
    if tracing then
	put :traceFile, ":", sslPointer-1, " ", operation, " ",
	    sslTable(sslPointer)
    end if
end SslTrace
#end if


type *FailureCodes : firstFailureCode .. lastFailureCode


procedure CheckDump
#if DEBUG then
    Context.DumpContext
    Actuals.DumpActuals	
    Scope.DumpScopes
    Symbol.DumpSymbols
    Types.DumpTypes
#else
    put "Debug temporarily turned off"
#end if
end CheckDump


procedure SslFailure (failCode: FailureCodes)
#if DEBUG then
    put "### S/SL semantic pass failure:  " ..

    case failCode of
	label fSemanticChoiceFailed :
	    put "Semantic choice failed"
	label fChoiceRuleFailed :
	    put "Choice rule returned without a value"
	label fInputStreamSyntaxError :
	    put "Input token stream syntax error"
	label fUnimplementedOperation :
	    put "Unimplemented semantic operation"
    end case

    put "while processing line ", lineNumber, " of file ", sourceFileName
    SslTrace
    if tracing then
	CheckDump
    end if
    sysexit (1)
#end if
end SslFailure


procedure SslSyntaxError
    % In a semantic or emitter pass, a syntax error
    % indicates either an error in the S/SL logic or
    % an error in the previous pass.	
    SslFailure (fInputStreamSyntaxError)
end SslSyntaxError


procedure SslGeneratedCompoundToken (expectedToken: InputTokens)
    compoundToken := expectedToken
    compoundTokenValue.identIndex := 0
    compoundTokenValue.stringLen := 0
    compoundTokenValue.integerKind := vIntNat
    compoundTokenValue.val := 0
end SslGeneratedCompoundToken


procedure ParseOptions
    for i : firstOptionArgument .. nargs
	var arg := fetcharg(i)
	if length (arg) >= 2 and arg(1) = "-" then
	    case type (char(3), arg)(2) of
#if DEBUG then
		label 't' :
		    tracing := true
		    open (traceFile, traceFileName, "w")

		label 's' :
		    statistics := true

		label 'D' :
		    desperate := true
#end if
		label 'd' :
		    stabInformation := true

		label 'w' :
		    if arg = "-w" then
		    	printWarnings := false
		    end if
		label :
		    put "Unknown option '", arg, "'"
	    end case
	end if
    end for
end ParseOptions


procedure Finalize
    if tracing then
	CheckDump
    end if

#if DEBUG then
    if statistics then
	Symbol.SymStats
	Types.TypStats
	Scope.ScopeStats
#if not PC then
	Ident.IdentStats
#end if
	Count.CountStats
	Actuals.ActStats
    end if
#end if

    % Check Semantic Mechanisms Finalized
    CheckSemanticMechanisms
end Finalize


procedure SslWalker
    handler (quitCode)
	put "Line ", lineNumber, " of ", sourceFileName,
		": Internal Semantic(1) Error!"
	quit >
    end handler

    var register localSslPointer := 0
    var register localSslTop: 0..sslStackSize := 0
    var register numberOfChoices: int
    var b:		boolean
    var errCode:	ErrorCodes
    var firstAlias, secondAlias: int


    % initialize
    ParseOptions

    % Check Semantic Mechanisms Initialized
    CheckSemanticMechanisms

    AcceptInputToken

    % Walk the S/SL Table
    loop
	operation := sslTable(localSslPointer)
	localSslPointer += 1

	% Trace Execution
    #if DEBUG then
	if tracing then
	    sslPointer := localSslPointer
	    SslTrace
	end if
    #end if

	case operation of
	    label oCall :
		assert localSslTop < sslStackSize 
		localSslTop += 1
		sslStack(localSslTop) := localSslPointer + 1
		localSslPointer := sslTable(localSslPointer)

	    label oReturn :
		if localSslTop = 0 then
		    % Return from main S/SL procedure
		    exit
		else
		    localSslPointer := sslStack(localSslTop)
		    localSslTop -= 1
		end if

	    label oRuleEnd :
		    sslPointer := localSslPointer
		    SslFailure (fChoiceRuleFailed)

	    label oJump :
		localSslPointer := sslTable(localSslPointer)

	    label oInput :
		if sslTable(localSslPointer) = nextToken then
		    AcceptInputToken
		else
		    % Syntax error in input
		    sslPointer := localSslPointer
		    SslSyntaxError
		end if
		localSslPointer += 1

	    label oInputAny :
		if nextToken not = aEndOfFile then
		    AcceptInputToken
		else
		    % Premature end of file
		    sslPointer := localSslPointer
		    SslSyntaxError
		end if

	    label oInputChoice :
		localSslPointer := sslTable(localSslPointer)
		numberOfChoices := sslTable(localSslPointer)
		localSslPointer += 1

		for : 1.. numberOfChoices
		    if sslTable(localSslPointer) = nextToken then
			localSslPointer := sslTable(localSslPointer+1)
			AcceptInputToken
			exit
		    end if
		    localSslPointer += 2
		end for

	    label oEmit :
		Emit.EmitOutputToken (sslTable(localSslPointer))
		localSslPointer += 1

	    label oError :
		errCode := sslTable(localSslPointer)
		if errCode = ePredefinedMisused then
		    errorIdent := compoundTokenValue.identIndex
		else
		    errorIdent := Symbol.SymbolIdent
		end if
    #if DEBUG then
		if desperate then
		    put :0, "Error ", errCode, " at ssl location ", localSslPointer
		end if
    #end if
		Error (errCode)
		localSslPointer += 1

	    label oChoice :
		localSslPointer := sslTable(localSslPointer)
		numberOfChoices := sslTable(localSslPointer)
		localSslPointer += 1

		for : 1..numberOfChoices
		    if sslTable(localSslPointer) = resultValue then
			localSslPointer:=sslTable(localSslPointer+1)
			exit
		    end if
			localSslPointer += 2
		end for

	    label oChoiceEnd :
		sslPointer := localSslPointer
		SslFailure (fSemanticChoiceFailed)

	    label oSetParameter :
		parameterValue := sslTable(localSslPointer)
		localSslPointer += 1

	    label oSetResult :
		resultValue := sslTable(localSslPointer)
		localSslPointer += 1
	    
	    label oSetResultFromInput :
		resultValue := nextToken

	    % Semantic Mechanism Operations
	    include "symbol.ops"
	    include "type.ops"
	    include "scope.ops"
	    include "count.ops"
	    include "loop.ops"
	    include "emit.ops"
	    include "context.ops"
	    include "actuals.ops"
	    include "predefined.ops"

	    label oCheckDump :
		CheckDump

	    label :
		sslPointer := localSslPointer
		SslFailure (fUnimplementedOperation)
	end case
    end loop

    % Make sure we processed it all
    if nextToken not = aEndOfFile then
	sslPointer := localSslPointer
	SslFailure (fInputStreamSyntaxError)
    end if

end SslWalker

SslWalker
Finalize

% Don't Continue Compile if Errors Present 
if noErrors > 0 then
    sysexit (1)
else
    sysexit (0)
end if
