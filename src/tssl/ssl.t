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

% This is the Turing S/SL (Syntax/Semantic Language) processor

include "%system"

% This program is the processor for Syntax/Semantic Langauge programs.  
% An S/SL program must be processed by this program, which will output Turing (or Euclid) 
% declarations for the constants defining the input tokens, output tokens, error codes, 
% type values and semantic operation codes used in the S/SL program and an array constant 
% declaration for the S/SL table for the program.  
% These declarations must be merged into the global declarations in the Turing (Euclid) S/SL Walker.		

% Input files:
%   sourceFile - the S/SL program source	

% Output files:
%   outDefFile - the output constant definitions
%		 for the program
%   outSslFile - the output S/SL table file for 
%		 the program
%   listFile -   a listing of the S/SL source 
%		 program with table coordinates 
%		 in the left margin (if requested) 

% The following are recognized options:

%   l - produce a listing of the S/SL source
%	program with table coordinates in the 
%	left margin in listFile
%   s - summarize usage of symbol and output 
%	tables
%   t - produce Turing tables rather than Euclid
%   e - produce Euclid tables rather than Turing
%   T - trace S/SL processor execution		


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

% Pass Dependent Semantic Operations:
% These will be different for each pass.  The
% semantic operations are implemented by the
% Semantic Mechanisms of the pass.
% There are two basic kinds of semantic operations:
% Update operations, which cause an update to the
% Semantic Mechanism, and Choice operations, which
% return a value based on the state of the Semantic
% Mechanism which is then used as the tag in a semantic
% choice.  Both Update and Choice operations may be
% parameterized by a single constant value.		

const *firstSemanticOperation := 14
const *oEnterCall := 14
const *oEmitNullCallAddress := 15
const *oResolveCalls := 16
const *oSetClass := 17
const *oSetClassFromSymbolClass := 18
const *oxSetClassFromSymbolValue := 19
const *oySetClassFromSymbolResultClass := 20
const *ozSetClassFromSymbolParameterClass := 21
const *ovSetClassFromChoiceClass := 22
const *oChooseClass := 23
const *oSetClassValue := 24
const *owSetClassValueFromSymbolValue := 25
const *oIncrementClassValue := 26
const *oEnterNewSymbol := 27
const *oLookupSymbol := 28
const *oChangeSymbolClass := 29
const *oChooseSymbolClass := 30
const *oVerifySymbolClass := 31
const *oxEnterNewSymbolValue := 32
const *oEnterSecondNewSymbolValue := 33
const *oEnterSymbolValueFromAddress := 34
const *oxChooseSymbolValue := 35
const *oEmitSymbolValue := 36
const *oxVerifySymbolClassValue := 37
const *oxEnterSymbolParameterClass := 38
const *oyEnterSymbolResultClass := 39
const *oyChooseSymbolResultClass := 40
const *oSaveEnclosingSymbol := 41
const *oRestoreEnclosingSymbol := 42
const *oSaveCurrentSymbol := 43
const *oRestoreCurrentSymbol := 44
const *oPushCycle := 45
const *oPopCycle := 46
const *oChooseCycleDepth := 47
const *oEmitCycleAddress := 48
const *oEnterCycleExit := 49
const *oResolveCycleExits := 50
const *oxChooseCycleExits := 51
const *oPushChoice := 52
const *oPopChoice := 53
const *oChangeChoiceClass := 54
const *oChooseChoiceClass := 55
const *oVerifyChoiceSymbolLabel := 56
const *oEnterChoiceSymbolLabel := 57
const *oxEnterChoiceMerge := 58
const *oResolveChoiceMerges := 59
const *oEmitChoiceTable := 60
const *oxResolveChoiceTableAddress := 61
const *oEmitFirstChoiceValue := 62
const *oxEmitFirstChoiceAddress := 63
const *oStartRules := 64
const *oBeginRule := 65
const *oSaveRule := 66
const *oEndRules := 67
const *oGenerateDefinitions := 68
const *oGenerateTable := 69
const *oEmitValue := 70
const *oEmitNullAddress := 71
const *lastSemanticOperation := 71
const *lastTableOperation := lastSemanticOperation

% S/SL Table Size 
const *sslTableSize := 40000	% Maximum 

% The S/SL Rule Call Stack Size 
const *sslStackSize := 127

% Operation Result Values 
const *valid := 1
const *invalid := 0

% Maximum Source Lines 
const *maxLineNumber := 9999

% S/SL System Failure Codes 
const *firstFailureCode := 0
const *fSemanticChoiceFailed := 0
const *fChoiceRuleFailed := 1
const *lastFailureCode := 1

% Error Signal Codes 
const *firstErrorCode := 0
const *eNoError := 0
const *eSyntaxError := 1
const *ePrematureEndOfFile := 2
const *eExtraneousProgramText := 3

% Semantic Errors 
const *eCycleHasNoExits := 10
const *eDuplicateLabel := 11
const *eExitNotInCycle := 12
const *eIllegalParameterClass := 13
const *eIllegalResultClass := 14
const *eIllegalNonvaluedReturn := 15
const *eIllegalStringSynonym := 16
const *eIllegalValuedReturn := 17
const *eSymbolPreviouslyDefined := 18
const *eUndefinedSymbol := 19
const *eWrongDeclaredResultClass := 20
const *eWrongLabelClass := 21
const *eWrongParameterClass := 22
const *eWrongResultClass := 23
const *eWrongSymbolClass := 24

% Non-S/SL Semantic Errors 
const *eUnresolvedRule := 30
const *eSymbolTooLong := 31
const *eNumberTooLarge := 32
const *eStringTooLong := 33
const *eValueOutOfRange := 34
const *eJumpOutOfRange := 35

% Fatal Errors 
const *firstFatalErrorCode := 40
const *eSslStackOverflow := 40
const *eCallStackOverflow := 41
const *eTooManyTotalSymbolChars := 42
const *eTooManySymbols := 43
const *eTableTooLarge := 44
const *eCyclesTooDeep := 45
const *eTooManyExits := 46
const *eChoicesTooDeep := 47
const *eTooManyLabels := 48
const *eTooManyMerges := 49
const *eTooManyCalls := 50
const *eRuleTooLarge := 51
const *lastErrorCode := 51

% Maximum Error Count 
const *maxErrors := 100

% Input Tokens 
const *firstInputToken := -1

% Nonexistent input token used only in syntax error recovery 
const *tSyntaxError := -1

% Compound Input Tokens 
const *firstCompoundToken := 0
const *tIdent := 0
const *tString := 1
const *tInteger := 2
const *lastCompoundToken := 2

% Non-Compound Input Tokens 
const *tColon := 3
const *tSemicolon := 4
const *tEqual := 5
const *tQuestionMark := 6
const *tPeriod := 7
const *tErrorSignal := 8
const *tCall := 9
const *tExit := 10
const *tReturn := 11
const *tLeftParen := 12
const *tRightParen := 13
const *tCycle := 14
const *tCycleEnd := 15
const *tChoice := 16
const *tChoiceEnd := 17
const *tComma := 18
const *tOr := 19
const *tOtherwise := 20
const *tInput := 21
const *tOutput := 22
const *tError := 23
const *tType := 24
const *tMechanism := 25
const *tRules := 26
const *tEnd := 27
const *tNewLine := 28
const *tEndOfFile := 29

% Special token returned by Input Scanner for garbage 
const *tIllegal := 30
const *lastInputToken := 30

% Input Scanner Limits and Parameters 
const *maxInputTokenLength := 100	% must be <= 127 
const *maxIdentLength := maxInputTokenLength
const *maxStringLiteralLength := maxIdentLength
const *maxNumberLength := 5
const *maxInteger := 32767
const *minInteger := -32767
const *ordCharFirst := 1	% avoid Turing eos character
const *ordCharLast := 127	% 127 in ASCII, 255 in EBCDIC 

% Keyword Table Sizes 
const *noKeywords := 11
const *noKeywdsPlus1 := 12
const *noKeywordChars := 45

% Character Constants 
const *newline := '\n'
const *tab := '\t'
const *blank := ' '
const *quote := '\''
const *breakChar := '_'

% Output Tokens for the S/SL Processor,
% these are the primitive operations of S/SL 
const *firstOutputToken := 0
const *aCall := oCall
const *aReturn := oReturn
const *aRuleEnd := oRuleEnd
const *aJump := oJump
const *aInput := oInput
const *aInputAny := oInputAny
const *aInputChoice := oInputChoice
const *aEmit := oEmit
const *aError := oError
const *aChoice := oChoice
const *aChoiceEnd := oChoiceEnd
const *aSetParameter := oSetParameter
const *aSetResult := oSetResult
const *aSetResultFromInput := oSetResultFromInput
const *lastOutputToken := 13

% Input/Output File Assignments 
const *sourceFile := 1
const *outDefFile := 2
const *outSslFile := 3
const *listFile := 4
const *optionsArg := 5

% Limits on the Assembled Output S/SL Table 
const *maxOutputTableSize := 40000
const *nullAddress := -7777

% Limits and Constants Associated with the
% Semantic Mechanisms of the S/SL Processor 

% The Symbol Table 

% Classes of Symbols 
const *cNotFound := 0
const *cInput := 1
const *cOutput := 2
const *cInputOutput := 3
const *cError := 4
const *cType := 5
const *cMechanism := 6
const *cUpdateOp := 7
const *cParmUpdateOp := 8
const *cChoiceOp := 9
const *cParmChoiceOp := 10
const *cRule := 11
const *cChoiceRule := 12
const *firstTypeClass := 13
const *maxClasses := 50

% Symbol Table Limits 
const *maxSymbolChars := 40000	% Total length of all identifiers 
const *maxSymbols := 2500

% Symbol index of nonexistent symbol 
const *notFound := 0

% First values for classes 
const *firstUserErrorSignalValue := 10
const *firstUserSemanticOperationValue := 14

% Undefined value 
const *nullValue := -9999

% The Call Table 
const *maxCalls := 5000
const *maxCallsPlusOne := maxCalls + 1

% The Cycle Stack 
const *maxExits := 30		% Pending resolution 
const *maxCycles := 15	% Deep 

% The Choice Stack 
const *maxMerges := 100	% Pending resolution 
const *maxLabels := 100	% Active 
const *maxChoices := 15	% Deep 


% Input Token Type 
type *InputTokens : firstInputToken .. lastInputToken
type *InputText : char(maxInputTokenLength)

% Output Token Type 
type *OutputTokens : firstOutputToken .. lastOutputToken

% Assembled S/SL Table Index 
type *OutputAddress : 0 .. maxOutputTableSize

% Error Code Type 
type *ErrorCodes : firstErrorCode .. lastErrorCode

% S/SL System Failure Code Type 
type *FailureCodes : firstFailureCode .. lastFailureCode

% Types Used in the Semantic Mechanisms of the S/SL Processor 

% The Symbol Table 
type *SymbolClasses : cNotFound .. maxClasses
type *SymbolIndex : 0 .. maxSymbols


% Standard Characters 
const *newpage := '\f'
const *endfile := '\0'

% The Syntax/Semantic Table
% The S/SL table file produced by the S/SL Processor 
include "ssl.sst.t"

% Table Walker State 
var processing: boolean := true
var sslPointer: 0 .. sslTableSize := 0
var operation: firstTableOperation .. lastTableOperation

% Option Control 
var tracing: boolean := false
var listing: boolean := false
var summarize: boolean := false

% Output Format 
const *euclid := 0
const *turing := 1
var format: euclid..turing := euclid

% Abort Flag 
var aborted: boolean := false

% The S/SL Rule Call Stack:
% The Rule Call Stack implements Syntax/Semantic
% Language rule call and return.
% Each time an oCall operation is executed,
% the table return address is pushed onto the
% Rule Call Stack.  When an oReturn is executed,
% the return address is popped from the stack.
% An oReturn executed when the Rule Call Stack is
% empty terminates table execution.		
var sslStack: array 1 .. sslStackSize of 0 .. sslTableSize
var sslTop: 0 .. sslStackSize := 0

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
var parameterValue: int
var resultValue: int

% Line Counters 
var nextLineNumber: 0 .. maxLineNumber	:= 0
var lineNumber: 0 .. maxLineNumber

% Error Counter 
var noErrors: -1 .. maxErrors := 0

% Input Interface 
var nextToken: InputTokens
var nextTokenValue: int
var nextTokenText: InputText

% The Compound Input Token Buffer
% When a compound input token is accepted from
% the input stream, its associated value is
% saved in the compound token buffer for use by
% the Semantic Mechanisms of the pass.		
var compoundToken: InputTokens	% Last compound input token accepted 
var compoundValue: int		% Its associated value 
var compoundText: InputText

% Variables Used in Syntax Error Recovery 
var newInputLine: boolean := false
var savedToken: InputTokens

% Input Scanner Interface and Tables 

% Lookahead Character 
var nextChar: char

% Letter Normalization Map 
var lowerCaseMap: array ordCharFirst .. ordCharLast of char

% Keyword Token Table 
const keywordText:
    array 1..noKeywords of string(12) := 
	init ("mechanism", "output", "input", "error", "rules",
		"type", "end", "do", "od", "if", "fi")
const keywordToken:
    array 1..noKeywords of InputTokens :=
	init (tMechanism, tOutput, tInput, tError, tRules,
	      tType, tEnd, tCycle, tCycleEnd, tChoice, tChoiceEnd)

% Special Symbol Token Table
var specialChar: array InputTokens of char

% First read flag 
var firstChar: boolean := true

% The Assembled Table 
var outputTable: array OutputAddress of int
var outputPointer: OutputAddress := 0

% The Semantic Mechanism Data Structures of the S/SL Processor 

% The Symbol Table 

% The Symbol Table 
var symClass:
    array 0 .. maxSymbols of SymbolClasses 
var symText, symLowText:
    array 0 .. maxSymbols of string(maxIdentLength)
var symValue:
    array 0 .. maxSymbols of int
var symParmClass:
    array 0 .. maxSymbols of SymbolClasses
var symResultClass:
    array 0 .. maxSymbols of SymbolClasses
var symTop:
    SymbolIndex := 0

% symIndex is the index in the Symbol Table
% of the symbol last referenced  symIndex = 0 (notFound)
% indicates the referenced symbol is not present in the table. 
var symIndex:
    SymbolIndex

% savedSymIndex is used to save the
% the value of symIndex for later recall 
var savedSymIndex:
    SymbolIndex

% enclosingSymIndex is used to save the symbol index of the
% enclosing S/SL rule or type for later recall			
var enclosingSymIndex:
    SymbolIndex

% Next Symbol Value 
var symNextValue:
    array SymbolClasses of int

% Current Definition Class 
var symCurrentClass:
    SymbolClasses := cNotFound

% The Call Table 

var callAddress:
    array 1 .. maxCalls of OutputAddress
% callRule is the SymbolIndex of the called rule and
% is later resolved to an OutputAddress			
var callRule:
    array 1 .. maxCalls of int
var callTop:
    0 .. maxCalls := 0

% The Cycle Stack 

% The Cycle Exit Stack 
var exitAddress:
    array 1 .. maxExits of OutputAddress
var exitTop:
    0 .. maxExits := 0

% The Cycle Stack 
var cycleAddress:
    array 1 .. maxCycles of OutputAddress
% cycleExitIndex is the origin of the
% portion of the Exit Stack for the cycle 
var cycleExitIndex:
    array 1 .. maxCycles of 0 .. maxExits
var cycleTop:
    0 .. maxCycles := 0

% The Choice Stack 

% The Choice Merge Stack:  used to save the addresses
% of the merge branches following each alternative of a choice 
var mergeAddress:
    array 1 .. maxMerges of OutputAddress
var mergeTop:
    0 .. maxMerges := 0

% The Choice Label Stack:  used to save the alternative
% values and corresponding table addresses in a choice 
var labelValue:
    array 1 .. maxLabels of int
var labelAddress:
    array 1 .. maxLabels of OutputAddress
var labelTop:
    0 .. maxLabels := 0

% The Choice Stack 
var choiceClass:
    array 1 .. maxChoices of SymbolClasses
var choiceAddress:
    array 1 .. maxChoices of OutputAddress
% choiceMergeIndex is the origin of the portion
% of the Merge Stack for the choice		
var choiceMergeIndex:
    array 1 .. maxChoices of 0 .. maxMerges
% choiceLabelIndex is the origin of the portion
% of the Label Stack for the choice		
var choiceLabelIndex:
    array 1 .. maxChoices of 0 .. maxLabels
var choiceTop:
    0 .. maxChoices := 0


procedure LowerCase (source: type char(300), var target : type char(300))
    var register i := 1

    loop
	const register c : char := source(i)
	exit when c = '\0'
	target(i) := lowerCaseMap(ord(c))
	i += 1
    end loop
    target(i) := '\0'
end LowerCase


procedure Assign (source: type char(300), var target : type char(300))
    var register i := 1

    loop
	const register c : char := source(i)
	exit when c = '\0'
	target(i) := c
	i += 1
    end loop
    target(i) := '\0'
end Assign


procedure Error (errCode: ErrorCodes)
    import (nextLineNumber, lineNumber, nextTokenText, compoundText, 
	var noErrors, var aborted, var processing)

    % This procedure Emits the error message associated with errCode 
    pre errCode not = eNoError

    put "Line " ..

    if errCode = eSyntaxError then
	% Syntax errors are in the lookahead token 
	put nextLineNumber ..
    else
	% Semantic errors are in the accepted token 
	put lineNumber ..
    end if

    put ": " ..

    case errCode of
	label eSyntaxError:
	    put "Syntax error at " + nextTokenText
	label ePrematureEndOfFile:
	    put "Unexpected end of file"
	label eExtraneousProgramText:
	    put "Extraneous program text"
	label eSymbolTooLong:
	    put "Symbol too long"
	label eNumberTooLarge:
	    put "Integer value too large (or small)"
	label eStringTooLong:
	    put "String too long"
	label eUndefinedSymbol:
	    put "Symbol " + compoundText + " undefined"
	label eSymbolPreviouslyDefined:
	    put "Symbol " + compoundText + " previously defined"
	label eWrongSymbolClass:
	    put "Illegal context for symbol " + compoundText
	label eUnresolvedRule:
	    put "Rule "  + compoundText + " undefined"
	label eValueOutOfRange:
	    put "Symbol value not in table value range"
	label eJumpOutOfRange:
	    put "Jump distance exceeds table value range"
	label eIllegalStringSynonym:
	    put "Illegal string synonym"
	label eTooManyTotalSymbolChars:
	    put "Too many symbols (chars)"
	label eTooManySymbols:
	    put "Too many symbols"
	label eTableTooLarge:
	    put "Table too large"
	label eRuleTooLarge:
	    put "Rule too large"
	label eTooManyCalls:
	    put "Too many rule calls"
	label eCyclesTooDeep:
	    put "Cycles too deep"
	label eChoicesTooDeep:
	    put "Choices too deep"
	label eTooManyExits:
	    put "Too many cycle exits"
	label eTooManyLabels, eTooManyMerges:
	    put "Too many alternatives"
	label eCycleHasNoExits:
	    put "(Warning) Cycle does not contain a cycle exit"
	    noErrors -= 1
	label eExitNotInCycle:
	    put "Cycle exit not in cycle"
	label eDuplicateLabel:
	    put "Duplicate alternative label"
	label eIllegalParameterClass, eIllegalResultClass:
	    put "Type name required as parameter or result type"
	label eIllegalNonvaluedReturn:
	    put "Non-valued return in choice rule"
	label eIllegalValuedReturn:
	    put "Valued return in procedure rule"
	label eWrongLabelClass:
	    put "Alternative label is wrong type"
	label eWrongParameterClass:
	    put "Parameter is wrong type"
	label eWrongDeclaredResultClass:
	    put "Result type does not match previous use"
	label eWrongResultClass:
	    put "Result value is wrong type"
    end case

    noErrors += 1

    if (errCode >= firstFatalErrorCode) or (noErrors = maxErrors) then
	put "*** Processing aborted"
	aborted := true
	processing := false
    end if
end Error


procedure ReadNextChar
    import (listing, var nextChar, var firstChar, outputPointer)

    if listing then
	if firstChar then
	    firstChar := false
	elsif nextChar = newline then
	    put :listFile, ""
	else
	    put :listFile, nextChar ..
	end if

	if nextChar = newline then
	    put :listFile, outputPointer: 4, "\t" ..
	end if
    end if

    get :sourceFile, nextChar
end ReadNextChar


procedure EvaluateNumber
    import (nextToken, nextTokenText, Error, var nextTokenValue)

    pre nextToken = tInteger

    var i: 0 .. maxNumberLength 
    var value: int
    var increment: int

    if nextTokenText(1) = '-' then
	i := 1
    else
	i := 0
    end if

    value := 0

    loop
	i += 1

	exit when nextTokenText(i) = '\0'

	if value <= maxInteger div 10 then
	    value := value * 10
	    increment := ord (nextTokenText(i)) - ord ('0')

	    if increment <= maxInteger - value then
		value := value + increment
	    else
		Error (eNumberTooLarge)
		value := 0
	    end if
	else
	    Error (eNumberTooLarge)
	    value := 0
	end if
    end loop

    if nextTokenText(1) = '-' then
	value := -value
    end if

    nextTokenValue := value
end EvaluateNumber


procedure LookupKeyword
    pre (nextToken = tIdent) and nextTokenText(1) not= '\0'

    var nt : string
    LowerCase(nextTokenText, nt)

    % The keyword table is ordered by length, longest first 

    if length(nt) <= length(keywordText(1)) /* the longest */ then
	for i: 1..noKeywords
	    if nt = keywordText(i) then
		nextToken := keywordToken(i)
		exit
	    end if
	end for
    end if
end LookupKeyword


procedure GetNextInputToken
    pre (maxInputTokenLength >= maxIdentLength) and
	    (maxInputTokenLength >= maxStringLiteralLength) and
	    (maxInputTokenLength >= maxNumberLength)

    var errCode: ErrorCodes := eNoError
    var t: firstInputToken .. lastInputToken 

    % Skip blanks and comments 
    loop
	exit when (nextChar not = blank) and (nextChar not = tab)
	    and (nextChar not = newpage) and (nextChar not = '%')

	if nextChar = '%' then
	    % Skip comment 
	    loop
		ReadNextChar
		exit when (nextChar = newline) or (nextChar = endfile)
	    end loop
	else
	    ReadNextChar
	end if
    end loop

    % Scan and set nextToken 
    var nextCharPos := 1
    nextTokenText(1) := '\0'
    nextTokenValue := 0

    if ((nextChar >= 'a') and (nextChar <= 'z')) or
	    ((nextChar >= 'A') and (nextChar <= 'Z')) then
	% Scan identifier 
	loop
	    if nextCharPos - 1 < maxIdentLength then
		nextTokenText(nextCharPos) := nextChar
		nextCharPos += 1
	    else
		errCode := eSymbolTooLong
	    end if

	    ReadNextChar
	    exit when not (((nextChar >= 'a') and (nextChar <= 'z')) or
		((nextChar >= 'A') and (nextChar <= 'Z')) or
		((nextChar >= '0') and (nextChar <= '9')) or
		(nextChar = breakChar))
	end loop
	nextTokenText(nextCharPos) := '\0'

	nextToken := tIdent

	% Test for Keyword 
	LookupKeyword

    elsif (nextChar = '-') or
	    ((nextChar >= '0') and (nextChar <= '9')) then
	% Scan number 
	if nextChar = '-' then
	    nextTokenText(nextCharPos) := nextChar
	    nextCharPos += 1 
	    ReadNextChar
	end if

	assert maxInputTokenLength > maxNumberLength+1
	loop
	    if nextCharPos - 1 < maxNumberLength+2 then
		nextTokenText(nextCharPos) := nextChar
		nextCharPos += 1 
	    end if

	    ReadNextChar
	    exit when (nextChar < '0') or (nextChar > '9')
	end loop

	nextTokenText(nextCharPos) := '\0'
	nextToken := tInteger

	if (nextCharPos - 1 > maxNumberLength+1) or
		((nextTokenText(1) not = '-' ) and
		(nextCharPos - 1 > maxNumberLength)) then
	    errCode := eNumberTooLarge
	    nextTokenValue := 0
	else
	    EvaluateNumber
	end if

    elsif nextChar = quote then
	% Scan String 
	loop
	    if nextCharPos - 1 < maxStringLiteralLength-1 then
		nextTokenText(nextCharPos) := nextChar
		nextCharPos += 1 
	    else
		errCode := eStringTooLong
	    end if

	    ReadNextChar
	    exit when (nextChar = quote) or (nextChar = newline) or
		(nextChar = endfile)
	end loop

	nextTokenText(nextCharPos) := quote
	nextCharPos += 1 
	nextTokenText(nextCharPos) := '\0'

	if nextChar = quote then
	    ReadNextChar
	end if

	nextToken := tString

    else
	% Special Symbols 
	assert lastInputToken = tIllegal
	t := firstInputToken
	loop
	    exit when (specialChar(t) = nextChar) or (t = lastInputToken)
	    t += 1
	end loop

	nextToken := t
	nextTokenText(1) := nextChar
	nextTokenText(2) := '\0'
	ReadNextChar

	if (nextToken = tExit) and (nextChar = '>') then
	    nextToken := tReturn
	    ReadNextChar
	elsif (nextToken = tIllegal) and (nextTokenText(1) = '!') then
	    % Alternate for tOr 
	    nextToken := tOr
	end if
    end if

    if errCode not = eNoError then
	Error (errCode)
    end if
end GetNextInputToken


procedure InitInputScanner
    import (var lowerCaseMap, var specialChar, var nextChar,
	var firstChar, listing)

    % Initialize Letter Normalization Map 
    % The following works for both ASCII and EBCDIC 
    for c: ordCharFirst..ordCharLast
	lowerCaseMap(c) := chr(c)
    end for

    for c: ord('A')..ord('Z')
	lowerCaseMap(c) := chr(c+ord('a')-ord('A'))
    end for

    % Initialize Special Character Table 
    for t: firstInputToken..lastInputToken
	specialChar(t) := blank
    end for

    specialChar(tColon) := ':'
    specialChar(tSemicolon) := ';'
    specialChar(tEqual) := '='
    specialChar(tQuestionMark) := '?'
    specialChar(tPeriod) := '.'
    specialChar(tErrorSignal) := '#'
    specialChar(tCall) := '@'
    specialChar(tExit) := '>'
    specialChar(tReturn) := blank	% tReturn handled specially 
    specialChar(tLeftParen) := '('
    specialChar(tRightParen) := ')'
    specialChar(tCycle) := '{'
    specialChar(tCycleEnd) := '}'
    specialChar(tChoice) := '['
    specialChar(tChoiceEnd) := ']'
    specialChar(tComma) := ','
    specialChar(tOr) := '|'	% alternate "!" handled specially 
    specialChar(tOtherwise) := '*'
    specialChar(tNewLine) := newline
    specialChar(tEndOfFile) := endfile
    specialChar(tIllegal) := blank	% tIllegal handled specially 

    % Initialize Lookahead 
    nextChar := newline
    firstChar := true
end InitInputScanner


procedure AcceptInputToken
    import ( nextToken, nextTokenText, var compoundToken, var compoundText,
	nextTokenValue, var compoundValue, var lineNumber,
	var nextLineNumber, var newInputLine, tracing, GetNextInputToken)

    pre nextToken not = tEndOfFile

    var acceptedToken: InputTokens

    % Accept Token 
    acceptedToken := nextToken

    if (acceptedToken = tIdent) or (acceptedToken = tString) or
	    (acceptedToken = tInteger) then
	compoundToken := acceptedToken
	compoundText := nextTokenText
	compoundValue := nextTokenValue
    end if

    % Update Line Number 
    lineNumber := nextLineNumber

    % Get Next Input Token 
    newInputLine := false
    loop
	GetNextInputToken

	if nextToken = tNewLine then
	    % Update Line Counter and Set Flag 
	    newInputLine := true

	    if nextLineNumber < maxLineNumber then
		nextLineNumber += 1
	    else
		nextLineNumber := 0
	    end if
	end if

	exit when nextToken not = tNewLine
    end loop


    % Trace input 
    if tracing then
	put "Input token accepted ", acceptedToken: 1, "  Line ", lineNumber: 1,
	    "  Next input token ", nextToken: 1
    end if
end AcceptInputToken


% The following procedures are null because this version
% of the S/SL processor assembles the entire table in memory
% rather than paging by rule.

procedure StartRules
end StartRules

procedure BeginRule
end BeginRule

procedure SaveRule
end SaveRule

procedure RestoreRule
end RestoreRule

procedure EndRules
end EndRules


procedure Emit (value: int)
    % Emit an output table element to the assembled table 
    import (var outputTable, var outputPointer, Error, tracing)

    if outputPointer < maxOutputTableSize then
	outputTable(outputPointer) := value
	outputPointer += 1

	% Trace Table Assembly 
	if tracing then
	    put "Output emitted at ", outputPointer-1: 1, ": ", value: 1
	end if

    else
	Error (eTableTooLarge)
    end if
end Emit


procedure EmitFixup (fixupAddress: OutputAddress, value: int)
    % Fixup a previously emitted table location to a resolved value 
    import (var outputTable, outputPointer, tracing)

    pre (fixupAddress >= 0) and (fixupAddress < outputPointer)
	    and outputTable(fixupAddress) = nullAddress

    outputTable(fixupAddress) := value

    % Trace Table Assembly 
    if tracing then
	put "Output fixup at ", fixupAddress: 1, ": ", value: 1
    end if
end EmitFixup


procedure EmitNullAddress
    % Reserve a table location to be fixed up 
    import (Emit, nullAddress)
    Emit (nullAddress)
end EmitNullAddress


procedure EmitJumpAddress (targetAddress: OutputAddress)
    % Emit a backward jump address.  Jump addresses are absolute. 
    import (outputPointer, Emit, Error)
    Emit (targetAddress)
end EmitJumpAddress


procedure EmitJumpFixup (jumpAddress: OutputAddress)
    % Fixup a forward jump address.  Jump addresses are absolute. 
    import (outputPointer, EmitFixup, Error)
    EmitFixup (jumpAddress, outputPointer)
end EmitJumpFixup


procedure EmitNullCallAddress
    import (EmitNullAddress)
    EmitNullAddress
end EmitNullCallAddress


procedure EmitCallFixup (callAddress_: OutputAddress,
	calledRuleAddress: OutputAddress)
    % Fixup a rule call address.  Rule addresses are absolute. 
    import (EmitFixup)
    EmitFixup (callAddress_, calledRuleAddress)
end EmitCallFixup


% The Symbol Table Mechanism 

% The Symbol Table is used to keep track of defined symbols
% in the S/SL program.  It provides facilities to save defined
% symbols, resolve referenced symbols, and keep track of symbol
% values and parameter and result types.				


procedure EnterNewSymbol
    pre ((compoundToken = tIdent) or (compoundToken = tString))
	    and (compoundText(1) not= '\0')

    % Enter in the Symbol Table 
    if symTop < maxSymbols then
	symTop += 1
	Assign (compoundText, symText(symTop))
	LowerCase(compoundText, symLowText(symTop))
	symClass(symTop) := symCurrentClass
	symValue(symTop) := nullValue
	symParmClass(symTop) := cNotFound
	symResultClass(symTop) := cNotFound
    else
	Error (eTooManySymbols)
    end if

    symIndex := symTop
end EnterNewSymbol


procedure LookupSymbol
    % This procedure looks up a symbol (or string) in the symbolTable 
    pre (compoundToken = tIdent) or (compoundToken = tString)

    var ct : string
    LowerCase(compoundText, ct)

    symIndex := symTop

    loop
	exit when symIndex = notFound or symLowText(symIndex) = ct
	symIndex -= 1
    end loop

    % symIndex is now the index in the Symbol Table of the 
    % entry for the symbol if present and notFound otherwise 
end LookupSymbol


procedure xEnterNewSymbolValue
    import (symTop, symNextValue, symCurrentClass, var symValue)
    pre symTop > 0
    symValue(symTop) := symNextValue(symCurrentClass)
end xEnterNewSymbolValue


procedure EnterSecondNewSymbolValue
    import (symTop, symNextValue, symCurrentClass, var symValue)
    pre symTop >= 2
    symValue(symTop-1) := symNextValue(symCurrentClass)
end EnterSecondNewSymbolValue


procedure EnterSymbolValueFromAddress
    import (var symValue, symIndex, outputPointer)
    symValue(symIndex) := outputPointer
end EnterSymbolValueFromAddress


procedure xSymbolClass (var result_: SymbolClasses)
    import (symClass, symIndex)
    result_ := symClass(symIndex)
end xSymbolClass


procedure SymbolValue (var result_: int)
    import (symValue, symIndex)
    result_ := symValue(symIndex)
end SymbolValue


procedure CurrentSymbolIndex (var result_: SymbolIndex)
    import (symIndex)
    result_ := symIndex
end CurrentSymbolIndex


procedure SetCurrentSymbol (newIndex: SymbolIndex)
    import (var symIndex)
    symIndex := newIndex
end SetCurrentSymbol


procedure xSetCurrentClass (newClass: SymbolClasses)
    import (var symNextValue, var symCurrentClass)

    var nextOpValue: int

    % Synchronize operation values 
    if (symCurrentClass = cUpdateOp) or
	    (symCurrentClass = cParmUpdateOp) or
	    (symCurrentClass = cChoiceOp) or
	    (symCurrentClass = cParmChoiceOp) then
	    nextOpValue := symNextValue(symCurrentClass)
	    symNextValue(cUpdateOp) := nextOpValue
	    symNextValue(cParmUpdateOp) := nextOpValue
	    symNextValue(cChoiceOp) := nextOpValue
	    symNextValue(cParmChoiceOp) := nextOpValue
    end if

    % Synchronize input/output token values 
    if ((symCurrentClass = cInput) or (symCurrentClass = cOutput)) and
	    (symNextValue(symCurrentClass) >
	    symNextValue(cInputOutput)) then
	symNextValue(cInputOutput) := symNextValue(symCurrentClass)
    end if

    symCurrentClass := newClass
end xSetCurrentClass


procedure CurrentClass (var result_: SymbolClasses)
    import (symCurrentClass)
    result_ := symCurrentClass
end CurrentClass


procedure SetNextValueOfCurrentClass (newValue: int)
    import (var symNextValue, symCurrentClass)
    symNextValue(symCurrentClass) := newValue
end SetNextValueOfCurrentClass


procedure IncrementCurrentClassValue
    import (var symNextValue, symCurrentClass)
    symNextValue(symCurrentClass) += 1
end IncrementCurrentClassValue


procedure CopySymbolTextToTokenBuffer
    import (var compoundText, symIndex, symText)
    compoundText := symText(symIndex)
end CopySymbolTextToTokenBuffer


procedure ChangeSymbolClass
    import (symIndex, var symClass, symCurrentClass)
    pre symIndex not = notFound
    symClass(symIndex) := symCurrentClass
end ChangeSymbolClass


procedure xEnterSymbolParameterClass
    import (symIndex, var symParmClass, symCurrentClass)
    pre symIndex not = notFound
    symParmClass(symIndex) := symCurrentClass
end xEnterSymbolParameterClass


procedure yEnterSymbolResultClass
    import (symIndex, var symResultClass, symCurrentClass)
    pre symIndex not = notFound
    symResultClass(symIndex) := symCurrentClass
end yEnterSymbolResultClass


procedure SymbolParameterClass (var result_: SymbolClasses)
    import (symIndex, symParmClass)
    pre symIndex not = notFound
    result_ := symParmClass(symIndex)
end SymbolParameterClass


procedure SymbolResultClass (var result_: SymbolClasses)
    import (symIndex, symResultClass)
    pre symIndex not = notFound
    result_ := symResultClass(symIndex)
end SymbolResultClass


procedure SaveCurrentSymbol
    import (var savedSymIndex, symIndex)
    savedSymIndex := symIndex
end SaveCurrentSymbol


procedure RestoreCurrentSymbol
    import (var symIndex, savedSymIndex)
    symIndex := savedSymIndex
end RestoreCurrentSymbol


procedure SaveEnclosingSymbol
    import (var enclosingSymIndex, symIndex)
    enclosingSymIndex := symIndex
end SaveEnclosingSymbol


procedure RestoreEnclosingSymbol
    import (var symIndex, enclosingSymIndex)
    symIndex := enclosingSymIndex
end RestoreEnclosingSymbol


procedure InitSymbolTable
    import (var symCurrentClass, var symTop, var symClass, var symValue,
        var symText, var symNextValue)

    var i: SymbolClasses

    % Initialize Symbol Table 
    symCurrentClass := cNotFound
    assert notFound = 0
    symTop := notFound
    symClass(notFound) := cNotFound
    symText(notFound) := "?"

    % Initialize Next Values 
    symNextValue(cNotFound) := nullValue
    i := cNotFound
    loop
	i += 1
	symNextValue(i) := 0
	exit when i = maxClasses
    end loop

    symNextValue(cError) := firstUserErrorSignalValue
    symNextValue(cUpdateOp) := firstUserSemanticOperationValue
    symNextValue(cParmUpdateOp) := firstUserSemanticOperationValue
    symNextValue(cChoiceOp) := firstUserSemanticOperationValue
    symNextValue(cParmChoiceOp) := firstUserSemanticOperationValue
    symNextValue(cType) := firstTypeClass
end InitSymbolTable


% The Call Table Mechanism 

% The Call Table is used to keep track of calls to rules
% and provides operations to resolve the call addresses. 


procedure EnterCall
    import (var callTop, var callAddress, var callRule, outputPointer,
	CurrentSymbolIndex, Error)

    var s: SymbolIndex

    if callTop < maxCalls then
	callTop += 1
	callAddress(callTop) := outputPointer - 1
	CurrentSymbolIndex (s)
	callRule(callTop) := s
    else
	Error (eTooManyCalls)
    end if
end EnterCall


procedure ResolveCalls
    import (callTop, SetCurrentSymbol, SymbolValue, callRule,
	callAddress, EmitFixup, CopySymbolTextToTokenBuffer, Error)

    var i: 0 .. maxCalls
    var v: int

    i := 0
    loop
	exit when i = callTop
	i += 1
	SetCurrentSymbol (callRule(i))
	SymbolValue (v)

	if v not = nullValue then
	    EmitFixup (callAddress(i), v)
	else
	    CopySymbolTextToTokenBuffer
	    Error (eUnresolvedRule)
	end if
    end loop
end ResolveCalls


procedure InitCallTable
    import (var callTop)
    callTop := 0
end InitCallTable


% The Cycle Stack Mechanism 

% The Cycle Stack is used to handle the exits and loop
% jump of the cycle construct.				


procedure PushCycle
    import (var cycleTop, exitTop, var cycleExitIndex, var cycleAddress, 
	outputPointer, Error)
    % This procedure processes the beginning of a cycle 

    post cycleTop > 0

    if cycleTop < maxCycles then
	cycleTop += 1
	cycleExitIndex(cycleTop) := exitTop
	cycleAddress(cycleTop) := outputPointer
    else
	Error (eCyclesTooDeep)
    end if
end PushCycle


procedure EnterCycleExit
    import (cycleTop, var exitTop, var exitAddress, outputPointer, Error)
    % This procedure processes cycle exits 

    pre cycleTop > 0
    post exitTop > 0

    if exitTop < maxExits then
	exitTop += 1
	exitAddress(exitTop) := outputPointer - 1
    else
	Error (eTooManyExits)
    end if
end EnterCycleExit


procedure ResolveCycleExits
    import (cycleTop, cycleExitIndex, EmitJumpFixup, exitTop, exitAddress)

    pre cycleTop > 0

    var i: 0 .. maxExits

    % Fixup cycle exits 
    i := exitTop
    loop
	exit when i = cycleExitIndex(cycleTop)
	EmitJumpFixup (exitAddress(i))
	i -= 1
    end loop
end ResolveCycleExits


procedure PopCycle
    import (var cycleTop, var exitTop, cycleExitIndex)
    pre cycleTop > 0
    exitTop := cycleExitIndex(cycleTop)
    cycleTop -= 1
end PopCycle


procedure EmitCycleAddress
    import (EmitJumpAddress, cycleAddress, cycleTop)
    EmitJumpAddress (cycleAddress(cycleTop))
end EmitCycleAddress


procedure CycleDepth (var result_: int)
    import (cycleTop)
    result_ := cycleTop
end CycleDepth


procedure CycleExits (var result_: int)
    import (cycleTop, exitTop, cycleExitIndex)
    pre cycleTop > 0
    result_ := exitTop - cycleExitIndex(cycleTop)
end CycleExits


procedure InitCycleStack
    import (var cycleTop, var exitTop)
    exitTop := 0
    cycleTop := 0
end InitCycleStack


% The Choice Stack Mechanism 

% The Choice Stack is used to handle the labels, merge branches,
% and choice table of the choice construct.				


procedure PushChoice (pushClass: SymbolClasses)
    import (var choiceTop, var choiceClass, var choiceAddress,
	var choiceMergeIndex, var choiceLabelIndex, mergeTop,
	labelTop, outputPointer, Error)
    % This procedure processes the beginning of a choice 

    post choiceTop > 0

    if choiceTop < maxChoices then
	choiceTop += 1
	choiceClass(choiceTop) := pushClass
	choiceAddress(choiceTop) := outputPointer - 1
	choiceMergeIndex(choiceTop) := mergeTop
	choiceLabelIndex(choiceTop) := labelTop
    else
	Error (eChoicesTooDeep)
    end if
end PushChoice


procedure EnterChoiceMerge
    import (choiceTop, var mergeTop, var mergeAddress, outputPointer, Error)

    pre choiceTop > 0
    post mergeTop > 0

    if mergeTop < maxMerges then
	mergeTop += 1
	mergeAddress(mergeTop) := outputPointer - 1
    else
	Error (eTooManyMerges)
    end if
end EnterChoiceMerge


procedure ResolveChoiceMerges
    import (choiceTop, mergeTop, choiceMergeIndex, mergeAddress, EmitJumpFixup)
    % Resolve the merge jumps for the current top choice 

    pre (choiceTop > 0) and (mergeTop > 0)

    var i: 0 .. maxMerges

    % Fix choice merges 
    i := mergeTop
    loop
	exit when i = choiceMergeIndex(choiceTop)
	EmitJumpFixup (mergeAddress(i))
	i -= 1
    end loop
end ResolveChoiceMerges


procedure xEnterChoiceLabel (value: int)
    import (choiceTop, var labelTop, var labelValue, var labelAddress,
	outputPointer, Error)

    pre choiceTop > 0

    if labelTop < maxLabels then
	labelTop += 1
	labelValue(labelTop) := value
	labelAddress(labelTop) := outputPointer
    else
	Error (eTooManyLabels)
    end if
end xEnterChoiceLabel


procedure VerifyChoiceLabel (var result_: int, value: int)
    import (choiceTop, choiceLabelIndex, labelTop, labelValue)

    pre choiceTop > 0

    var i: 0 .. maxLabels
    result_ := valid

    i := choiceLabelIndex(choiceTop)
    loop
	exit when i = labelTop
	i += 1

	if labelValue(i) = value then
	    % Duplicate label 
	    result_ := invalid
	end if
    end loop
end VerifyChoiceLabel


procedure PopChoice
    import (var choiceTop, var labelTop, var mergeTop,
	choiceMergeIndex, choiceLabelIndex)
    pre choiceTop > 0
    mergeTop := choiceMergeIndex(choiceTop)
    labelTop := choiceLabelIndex(choiceTop)
    choiceTop -= 1
end PopChoice


procedure xResolveChoiceTableAddress
    import (EmitJumpFixup, choiceTop, choiceAddress)
    pre choiceTop > 0
    EmitJumpFixup (choiceAddress(choiceTop))
end xResolveChoiceTableAddress


procedure EmitChoiceTable
    import (Emit, choiceTop, labelTop, choiceLabelIndex,
	labelValue, EmitJumpAddress, labelAddress)

    pre choiceTop > 0

    var i: 0 .. maxLabels

    % Emit choice table 
    Emit (labelTop - choiceLabelIndex(choiceTop)) % Number of entries 
    i := choiceLabelIndex(choiceTop)
    loop
	exit when i = labelTop
	i += 1
	Emit (labelValue(i))
	EmitJumpAddress (labelAddress(i))
    end loop
end EmitChoiceTable


procedure EmitFirstChoiceAddress
    import (choiceTop, EmitJumpAddress, labelAddress, choiceLabelIndex)
    pre choiceTop > 0
    EmitJumpAddress (labelAddress(choiceLabelIndex(choiceTop) + 1))
end EmitFirstChoiceAddress


procedure xEmitFirstChoiceValue
    import (Emit, choiceTop, labelValue, choiceLabelIndex)
    pre choiceTop > 0
    Emit (labelValue(choiceLabelIndex(choiceTop) + 1))
end xEmitFirstChoiceValue


procedure ClassOfChoice (var result_: SymbolClasses)
    import (choiceTop, choiceClass)
    pre choiceTop > 0
    result_ := choiceClass(choiceTop)
end ClassOfChoice


procedure ChangeChoiceClass (newClass: SymbolClasses)
    import (choiceTop, var choiceClass)
    pre choiceTop > 0
    choiceClass(choiceTop) := newClass
end ChangeChoiceClass


procedure InitChoiceStack
    import (var choiceTop, var mergeTop, var labelTop)
    mergeTop := 0
    labelTop := 0
    choiceTop := 0
end InitChoiceStack


% The Output Definition and S/SL Table Generators 


procedure GenerateClass (class: SymbolClasses)
    import (format, outDefFile, symTop, symValue, symText, symClass)
    % Generates Assembled Constant Definitions for a Class of Symbols 

    var s: SymbolIndex
    var c: SymbolClasses

    s := 0
    loop
	exit when s = symTop
	s += 1
	c := symClass(s)

	if ((c = class) or ((class = cUpdateOp) and
		((c = cParmUpdateOp) or (c = cChoiceOp) or
		(c = cParmChoiceOp)))) and
		(symText(s)(1) not = quote) then
	    % A real external symbol and not
	    % a string synonym, so output it  
	    if format = euclid then
		put :outDefFile, "\tpervasive const " ..
	    else
		put :outDefFile, "\tconst *" ..
	    end if

	    put :outDefFile, symText(s), " := ", symValue(s)
	end if
    end loop
end GenerateClass


procedure GenerateSymbolDefinitions
    import (format, outDefFile, GenerateClass, symNextValue)
    % Generates Assembled Constant Definitions 

    var c: SymbolClasses

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Semantic Operations }"
    GenerateClass (cUpdateOp)	% Does all operations 
    put :outDefFile, ""

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Input Tokens }"
    GenerateClass (cInput)
    put :outDefFile, ""

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Output Tokens }"
    GenerateClass (cOutput)
    put :outDefFile, ""

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Input/Output Tokens }"
    GenerateClass (cInputOutput)
    put :outDefFile, ""

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Error Codes }"
    GenerateClass (cError)
    put :outDefFile, ""

    if format = turing then
	put :outDefFile, "\t% " ..
    else
	put :outDefFile, "\t" ..
    end if

    put :outDefFile, "{ Type Values }"
    c := firstTypeClass
    loop
	exit when c >= symNextValue(cType)
	GenerateClass (c)
	c += 1
    end loop
end GenerateSymbolDefinitions


procedure GenerateOutputTable
    import (format, outDefFile, outSslFile, outputPointer,
	callTop, callAddress, callRule, EmitCallFixup, outputTable)
    % Generates the Assembled Output Table 

    var i: OutputAddress

    % Generate Syntax/Semantic Table 
    put :outSslFile, "\tconst sslTable: array 0..", outputPointer ..

    if format = euclid then
	put :outSslFile, " of SignedInt := "
    else
	put :outSslFile, " of int := init"
    end if

    put :outSslFile, "\t\t(" ..

    i := 0
    loop
	exit when i >= outputPointer
	put :outSslFile, outputTable(i), ", " ..
	i += 1
	if i mod 10 = 0 then
	    put :outSslFile, ""
	    put :outSslFile, "\t\t" ..
	end if
    end loop

    put :outSslFile, "0)"
end GenerateOutputTable


% Syntax Error Handling 

procedure SslGenerateCompoundInputToken (expectedToken: InputTokens)
    import (nextToken, var compoundToken, var compoundValue,
	var compoundText)
    pre (nextToken = tSyntaxError) or (nextToken = tEndOfFile)

    compoundToken := expectedToken
    compoundValue := 0

    case expectedToken of
	label tInteger:
	    compoundText := "0"
	label tString:
	    compoundText := "'?'"
	label tIdent:
	    compoundText := "$NIL"
    end case
end SslGenerateCompoundInputToken


procedure SslSyntaxError
    import (operation, var nextToken, sslTable,
	sslPointer, Error, var processing, var savedToken, var newInputLine,
	var lineNumber, nextLineNumber, SslGenerateCompoundInputToken,
	AcceptInputToken)

    % This procedure handles syntax errors in the input
    % to the Parser pass, for Semantic passes this procedure
    % will simply assert false since a syntax error in
    % input would indicate an error in the previous pass.    

    % Syntax error recovery:
    % When a mismatch occurs between the the next input
    % token and the syntax table, the following recovery
    % is employed.						

    % If the expected token is tNewLine then if there
    % has been no previous syntax error on the line,
    % ignore the error.  (A missing logical new line
    % is not a real error.)					

    % If the expected token is tNewLine or tSemicolon and
    % a syntax error has already been detected on the
    % current logical line (flagged by nextToken =
    % tSyntaxError), then flush the input     exit when a
    % new line or end of file is found.			

    % Otherwise, if this is the first syntax error
    % detected on the line (flagged by nextToken
    % not = tSyntaxError), then if the input token
    % is tEndOfFile then emit the ePrematureEndOfFile
    % error code and terminate execution.  Otherwise,
    % emit the eSyntaxError error code and set
    % the nextToken to tSyntaxError to prevent
    % further input     exit when the expected input is
    % tSemicolon or tNewLine.				

    % If the expected token is not tSemicolon nor
    % tNewLine and a syntax error has already been
    % detected on the current line (flagged by
    % nextToken = tSyntaxError), then do nothing
    % and continue as if the expected token had
    % been matched.					

    pre (operation = oInput) or (operation = oInputAny)

    if nextToken = tSyntaxError then
	% Currently recovering from syntax error 
	if (sslTable(sslPointer) = tNewLine)
		or (sslTable(sslPointer) = tSemicolon) then
	    % Complete recovery by synchronizing
	    % input to a new line			 
	    nextToken := savedToken
	    newInputLine := false
	    loop
		exit when (nextToken = tSemicolon) or
		    (nextToken = tEndOfFile) or
		    newInputLine
		AcceptInputToken
	    end loop
	end if
    else
	% First syntax error on the line 
	if sslTable(sslPointer) = tNewLine then
	    % Ignore missing logical newlines 
	elsif nextToken = tEndOfFile then
	    % Flag error and terminate processing 
	    Error (ePrematureEndOfFile)
	    processing := false
	else
	    % Flag error and begin recovery 
	    Error (eSyntaxError)
	    savedToken := nextToken
	    nextToken := tSyntaxError
	    lineNumber := nextLineNumber
	end if
    end if

    % If the expected input token is a compound
    % token, generate a dummy one.		
    if (sslTable(sslPointer) >= firstCompoundToken) and
	    (sslTable(sslPointer) <= lastCompoundToken) then
	SslGenerateCompoundInputToken (sslTable(sslPointer))
    end if
end SslSyntaxError


procedure SslTrace
    import (sslPointer, operation, sslTable)
    put "Table index ", sslPointer-1, "  Operation ", operation, "  Argument ",
	sslTable(sslPointer)
end  SslTrace


procedure SslFailure (failCode: FailureCodes)
    import (lineNumber, SslTrace)

    put "### S/SL program failure:  " ..

    case failCode of
	label fSemanticChoiceFailed:
	    put "Semantic choice failed"
	label fChoiceRuleFailed:
	    put "Choice rule returned without a value"
    end case

    put "while processing line ", lineNumber

    SslTrace
    assert false
end SslFailure


procedure SslChoice (choiceTag: int)
    import (var sslPointer, sslTable, var choiceTagMatched)
    % This procedure performs both input and semantic
    % choices.  It sequentially tests each alternative
    % value against the tag value, and when a match is
    % found, performs a branch to the corresponding
    % alternative path.  If none of the alternative
    % values matches the tag value, sslTable interpretation
    % proceeds to the operation immediately following
    % the list of alternatives (normally the otherwise
    % path).  The flag choiceTagMatched is set to true
    % if a match is found and false otherwise.		

    var numberOfChoices:
	int
    var choicePointer:
	0..sslTableSize

    choicePointer := sslTable(sslPointer)
    numberOfChoices := sslTable(choicePointer)
    choicePointer += 1
    choiceTagMatched := false

    loop
	if sslTable(choicePointer) = choiceTag then
	    choicePointer := sslTable(choicePointer+1)
	    choiceTagMatched := true
	    numberOfChoices := 0
	else
	    choicePointer += 2
	    numberOfChoices -= 1
	end if
	exit when numberOfChoices = 0
    end loop

    sslPointer := choicePointer
end SslChoice


procedure SslWalker
    var c: SymbolClasses
    var d: SymbolClasses
    var v: int

    % Get Run Options 

    % Default no listing, tracing, summary, Turing tables 
    tracing := false
    listing := false
    summarize := false
    format := turing

    const argString := fetcharg(optionsArg)
    for i : 1 .. length(argString)
	var ch : char := argString(i)

	if ch = 'T' then
	    tracing := true
	elsif ch = 'l' then
	    listing := true
	elsif ch = 'u' then
	    summarize := true
	elsif ch = 'e' then
	    format := euclid
	elsif ch = 't' then
	    format := turing
	end if
    end for

    % Initialize Table Walker State 
    processing := true
    sslPointer := 0
    sslTop := 0
    noErrors := 0
    aborted := false

    % Initialize Output 
    outputPointer := 0

    % Initialize Input 
    InitInputScanner
    nextToken := tNewLine
    nextLineNumber := 0
    newInputLine := false
    AcceptInputToken

    % Initialize Semantic Mechanisms 
    InitSymbolTable
    InitCallTable
    InitCycleStack
    InitChoiceStack

    % Walk the S/SL Table 

    loop
	exit when not processing
	operation := sslTable(sslPointer)
	sslPointer += 1

	% Trace Execution 
	if tracing then
	    SslTrace
	end if

	case operation of
	    label oCall:
		if sslTop < sslStackSize then
		    sslTop := sslTop + 1
		    sslStack(sslTop) := sslPointer + 1
		    sslPointer := sslTable(sslPointer)
		else
		    Error (eSslStackOverflow)
		    processing := false
		end if

	    label oReturn:
		if sslTop = 0 then
		    % Return from main S/SL rule 
		    processing := false
		else
		    sslPointer := sslStack(sslTop)
		    sslTop -= 1
		end if

	    label oRuleEnd:
		SslFailure (fChoiceRuleFailed)

	    label oJump:
		sslPointer := sslTable(sslPointer)

	    label oInput:
		if sslTable(sslPointer) = nextToken then
		    AcceptInputToken
		else
		    % Syntax error in input 
		    SslSyntaxError
		end if

		sslPointer += 1

	    label oInputAny:
		if nextToken not = tEndOfFile then
		    AcceptInputToken
		else
		    % Premature end of file 
		    SslSyntaxError
		end if

	    label oInputChoice:
		SslChoice (nextToken)

		if choiceTagMatched then
		    AcceptInputToken
		end if

	    label oEmit:
		Emit (sslTable(sslPointer))
		sslPointer += 1

	    label oError:
		Error (sslTable(sslPointer))
		sslPointer += 1

	    label oChoice:
		SslChoice (resultValue)

	    label oChoiceEnd:
		SslFailure (fSemanticChoiceFailed)

	    label oSetParameter:
		parameterValue := sslTable(sslPointer)
		sslPointer += 1

	    label oSetResult:
		resultValue := sslTable(sslPointer)
		sslPointer += 1

	    label oSetResultFromInput:
		resultValue := nextToken


	    % Semantic Operations of the S/SL Processor 

	    % Call Table Mechanism Operations 
	    label oEnterCall:
		EnterCall

	    label oEmitNullCallAddress:
		EmitNullCallAddress

	    label oResolveCalls:
		ResolveCalls

	    % Symbol Table Mechanism Operations 
	    label oSetClass:
		xSetCurrentClass (parameterValue)

	    label oSetClassFromSymbolClass:
		xSymbolClass (c)
		xSetCurrentClass (c)

	    label oxSetClassFromSymbolValue:
		SymbolValue (v)
		xSetCurrentClass (v)

	    label oySetClassFromSymbolResultClass:
		SymbolResultClass (c)
		xSetCurrentClass (c)

	    label ozSetClassFromSymbolParameterClass:
		SymbolParameterClass (c)
		xSetCurrentClass (c)

	    label ovSetClassFromChoiceClass:
		ClassOfChoice (c)
		xSetCurrentClass (c)

	    label oChooseClass:
		CurrentClass (c)
		resultValue := c

	    label oSetClassValue:
		SetNextValueOfCurrentClass (compoundValue)

	    label owSetClassValueFromSymbolValue:
		SymbolValue (v)
		SetNextValueOfCurrentClass (v)

	    label oIncrementClassValue:
		IncrementCurrentClassValue

	    label oEnterNewSymbol:
		EnterNewSymbol

	    label oLookupSymbol:
		LookupSymbol

	    label oChangeSymbolClass:
		ChangeSymbolClass

	    label oChooseSymbolClass:
		xSymbolClass (c)
		resultValue := c

	    label oVerifySymbolClass:
		xSymbolClass (c)
		CurrentClass (d)

		if c = d then
		    resultValue := valid
		else
		    resultValue := invalid
		end if

	    label oxEnterNewSymbolValue:
		xEnterNewSymbolValue

	    label oEnterSecondNewSymbolValue:
		EnterSecondNewSymbolValue

	    label oEnterSymbolValueFromAddress:
		EnterSymbolValueFromAddress

	    label oxChooseSymbolValue:
		SymbolValue (resultValue)

	    label oEmitSymbolValue:
		SymbolValue (v)
		Emit (v)

	    label oxVerifySymbolClassValue:
		SymbolValue (v)
		CurrentClass (c)

		if v = c then
		    resultValue := valid
		else
		    resultValue := invalid
		end if

	    label oxEnterSymbolParameterClass:
		xEnterSymbolParameterClass

	    label oyEnterSymbolResultClass:
		yEnterSymbolResultClass

	    label oyChooseSymbolResultClass:
		SymbolResultClass(c)
		resultValue := c

	    label oSaveEnclosingSymbol:
		SaveEnclosingSymbol

	    label oRestoreEnclosingSymbol:
		RestoreEnclosingSymbol

	    label oSaveCurrentSymbol:
		SaveCurrentSymbol

	    label oRestoreCurrentSymbol:
		RestoreCurrentSymbol

	    % Cycle Stack Mechanism Operations 
	    label oPushCycle:
		PushCycle

	    label oPopCycle:
		PopCycle

	    label oChooseCycleDepth:
		CycleDepth (resultValue)

	    label oEmitCycleAddress:
		EmitCycleAddress

	    label oEnterCycleExit:
		EnterCycleExit

	    label oResolveCycleExits:
		ResolveCycleExits

	    label oxChooseCycleExits:
		CycleExits (resultValue)

	    % Choice Stack Mechanism Operations 
	    label oPushChoice:
		CurrentClass (c)
		PushChoice (c)

	    label oPopChoice:
		PopChoice

	    label oChangeChoiceClass:
		CurrentClass (c)
		ChangeChoiceClass (c)

	    label oChooseChoiceClass:
		ClassOfChoice (c)
		resultValue := c

	    label oVerifyChoiceSymbolLabel:
		SymbolValue (v)
		VerifyChoiceLabel (resultValue, v)

	    label oEnterChoiceSymbolLabel:
		SymbolValue (v)
		xEnterChoiceLabel (v)

	    label oxEnterChoiceMerge:
		EnterChoiceMerge

	    label oResolveChoiceMerges:
		ResolveChoiceMerges

	    label oEmitChoiceTable:
		EmitChoiceTable

	    label oxResolveChoiceTableAddress:
		xResolveChoiceTableAddress

	    label oEmitFirstChoiceValue:
		xEmitFirstChoiceValue

	    label oxEmitFirstChoiceAddress:
		EmitFirstChoiceAddress

	    % Rule Table Operations 
	    label oStartRules:
		StartRules

	    label oBeginRule:
		BeginRule

	    label oSaveRule:
		SaveRule

	    label oEndRules:
		EndRules

	    % Generate Output Operations 
	    label oGenerateDefinitions:
		GenerateSymbolDefinitions

	    label oGenerateTable:
		GenerateOutputTable

	    % Miscellaneous Output Operations 
	    label oEmitValue:
		Emit (compoundValue)

	    label oEmitNullAddress:
		EmitNullAddress
	end case
    end loop

    if (nextToken not = tEndOfFile) and not aborted then
	Error (eExtraneousProgramText)
    end if
end SslWalker


% Walk the S/SL Table 
SslWalker

% Summarize Table Usage if Requested 
if summarize then
    put outputPointer+1, "/", maxOutputTableSize, " table entries, ",
	symTop, "/", maxSymbols, " symbols, ", callTop, "/", maxCalls,
	" calls."
end if

sysexit (noErrors)
