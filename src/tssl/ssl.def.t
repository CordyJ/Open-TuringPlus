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

	% { Semantic Operations }
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

	% { Input Tokens }
	const *tIdent := 0
	const *tString := 1
	const *tInteger := 2
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

	% { Output Tokens }
	const *aCall := 0
	const *aReturn := 1
	const *aRuleEnd := 2
	const *aJump := 3
	const *aInput := 4
	const *aInputAny := 5
	const *aInputChoice := 6
	const *aEmit := 7
	const *aError := 8
	const *aChoice := 9
	const *aChoiceEnd := 10
	const *aSetParameter := 11
	const *aSetResult := 12
	const *aSetParameterFromInput := 13

	% { Input/Output Tokens }

	% { Error Codes }
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

	% { Type Values }
	const *invalid := 0
	const *valid := 1
	const *zero := 0
	const *undefined := -9999
	const *cNotFound := 0
	const *cInput := 1
	const *cOutput := 2
	const *cInputOutput := 3
	const *cError := 4
	const *cType := 5
	const *cMechanism := 6
	const *cUpdateOp := 7
	const *cParameterizedUpdateOp := 8
	const *cChoiceOp := 9
	const *cParameterizedChoiceOp := 10
	const *cRule := 11
	const *cChoiceRule := 12
