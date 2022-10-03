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
% Abort generation routine.  This routine takes an abort number
% and converts it into an appropriate system exception.
%

parent "TLE.ch"

stub procedure TLEABT ( abortNo	: Cint )

body procedure TLEABT
    bind var register E to TL_Process(TLKPD).exception

    case abortNo of

	label 1:
	    E.errorMsg := "Array subscript is out of range"
	    E.quitCode := excpArraySubscriptOutOfRange

	label 2:
	    E.errorMsg := "Dynamic array upper bound is less than lower bound"
	    E.quitCode := excpDynamicArrayUpperBoundLessThanLower

	label 3:
	    E.errorMsg := "Union field is not in alternative selected by current tag value"
	    E.quitCode := excpUnionFieldNotInCurrentTag

	label 4:
	    E.errorMsg := "Tag value is out of range"
	    E.quitCode := excpTagValueOutOfRange

	label 5:
	    E.errorMsg := "Assignment value is out of range"
	    E.quitCode := excpAssignmentValueOutOfRange

	label 6:
	    E.errorMsg := "Pre condition is false"
	    E.quitCode := excpPreConditionFalse

	label 7:
	    E.errorMsg := "Post condition is false"
	    E.quitCode := excpPostConditionFalse

	label 8:
	    E.errorMsg := "Loop invariant is false"
	    E.quitCode := excpLoopInvariantFalse

	label 9:
	    E.errorMsg := "For loop invariant is false"
	    E.quitCode := excpForLoopInvariantFalse

	label 10:
	    E.errorMsg := "Module invariant is false"
	    E.quitCode := excpModuleInvariantFalse

	label 11:
	    E.errorMsg := "Assert condition is false"
	    E.quitCode := excpAssertConditionFalse

	label 12:
	    E.errorMsg := "Value parameter is out of range"
	    E.quitCode := excpValueParameterOutOfRange

	label 13:
	    E.errorMsg := "Length of string parameter exceeds max length of string formal"
	    E.quitCode := excpStringParameterTooLarge

	label 14:
	    E.errorMsg := "Result value is out of range"
	    E.quitCode := excpResultValueOutOfRange

	label 15:
	    E.errorMsg := "Case selector is out of range"
	    E.quitCode := excpCaseSelectorOutOfRange

	label 16:
	    E.errorMsg := "Function failed to give a result"
	    E.quitCode := excpFunctionFailedToGiveResult

	label 17:
	    E.errorMsg := "Collection element has been freed"
	    E.quitCode := excpCollectionElementFreed

	label 18:
	    E.errorMsg := "Collection subscript is nil"
	    E.quitCode := excpCollectionSubscriptNil

	label 19:
	    E.errorMsg := "Set element is out of range"
	    E.quitCode := excpSetElementOutOfRange

	label 20:
	    E.errorMsg := "Subprogram calls nested too deeply. (Probable cause: infinite recursion)"
	    E.quitCode := excpOutOfStackSpace

	label 21:
	    E.errorMsg := "Bound variables overlap"
	    E.quitCode := excpBoundVariablesOverlap

	label 22:
	    E.errorMsg := "Reference parameters overlap"
	    E.quitCode := excpReferenceParametersOverlap

	label 23:
	    E.errorMsg := "Division (or modulus) by zero"
	    E.quitCode := excpDivOrModByZero

	label 24:
	    %
	    % This will never be generated.  Isn't compatibility
	    % with Turing wonderful!
	    %
	    E.errorMsg := "Union tag has not been set"
	    E.quitCode := excpUnionTagUninitialized

	label 25:
	    E.errorMsg := "Length of string value exceeds max length of variable"
	    E.quitCode := excpStringValueTooLarge

	label 26:
	    %
	    % This will never be generated.  Isn't compatibility
	    % with Turing wonderful!
	    %
	    E.errorMsg := "Illegal parameter to \"chr\""
	    E.quitCode := excpIllegalParameterChr

	label 27:
	    E.errorMsg := "Parameter to \"ord\" is not of length one"
	    E.quitCode := excpIllegalParameterOrd

	label 28:
	    E.errorMsg := "Pred applied to the first value of the enumeration"
	    E.quitCode := excpPredOfFirstElement

	label 29:
	    E.errorMsg := "Succ applied to the last value of the enumeration"
	    E.quitCode := excpSuccOfLastElement

	label 30:
	    E.errorMsg := "Invalid subscript in charstring([*-]expn)"
	    E.quitCode := excpInvalidSubscriptCharString

	label 31:
	    E.errorMsg := "string or char(n) assigned to char is not length 1"
	    E.quitCode := excpDynamicCharAssignedToChar

	label 32:
	    E.errorMsg := "right side of assignment to char(n) is not length 'n'"
	    E.quitCode := excpCharAssignedToDynamicChar

	label 33:
	    E.errorMsg := "char converted to string contains EOS or uninitchar"
	    E.quitCode := excpIllegalValueInStringConversion

	label 34:
	    E.errorMsg := "string or char(n) coerced to char is not length 1"
	    E.quitCode := excpDynamicCharCoercedToChar

	label 35:
	    E.errorMsg := "Variable has no value"
	    E.quitCode := excpUninitializedVariable

	label 36:
	    E.errorMsg := "Overflow in Integer expression"
	    E.quitCode := excpIntegerOverflow

	label 37:
	    E.errorMsg := "Division (or modulus) by zero in Integer expression"
	    E.quitCode := excpDivOrModByZero

	label 38:
	    E.errorMsg := "Overflow in Real expression"
	    E.quitCode := excpRealOverflow

	label 39:
	    E.errorMsg := "Division (or modulus) by zero in Real expression"
	    E.quitCode := excpDivOrModByZero

	label 40:
	    E.errorMsg := "Underflow in Real expression"
	    E.quitCode := excpRealUnderflow

	label :
	    E.errorMsg := "Internal Turing+ System Error - Unexpected abort"
	    E.quitCode := excpSystemError

    end case

    quit : E.quitCode

end TLEABT
