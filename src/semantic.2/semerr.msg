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

label eIntInt4Equivalence:
    put "'int' may not be equivalent to 'int4' on some machines"

label eNatNat4Equivalence:
    put "'nat' may not be equivalent to 'nat4' on some machines"

label eRealReal8Equivalence:
    put "'real' may not be equivalent to 'real8' on some machines"

label eNegativeConstantUsedInLogicalOperation:
    put "Negative expression used in a logical operation"

label eAssignmentValueOutOfRange:
    put "Assigned value is out of range"

label eCaseLabelBadValue:
    put "Case alternative label must be a compile-time integer or char value"

label eConstantValueOutOfRange:
    put "Constant value is out of range"

label eDivByZero:
    put "'div' or 'mod' by zero"

label eOpaqueOnlyAppliesToTypes:
    put "'opaque' can be applied only to types"

label eUnionLabelValueNotInRange:
    put "Union alternative label is out of range"

label eValueActualOutOfRange:
    put "Parameter value is out of range"

label eAddrOfCompileTimeConstant:
    put "Argument of 'addr' is a compile-time constant"

label eAddrOfRegisterVariable:
    put "Argument of 'addr' is a register variable or 'for' loop index"

label eAsmLabelMustBeString:
    put "Label field of an 'asm' statement must be a string"

label eAsmOpcodeMustBeString:
    put "Opcode field of an 'asm' statement must be a string"

label eAtExpnMustBeInteger:
    put "'@' expression must be an integer or addressint"

label eBadArgToAddr:
    put "Argument to 'addr' must be a variable, runtime constant, procedure, function, or process"

label eBadArgToEmpty:
    put "Argument to 'empty' must be a condition"

label eBadArgToLower:
    put "First argument to 'lower' must be an array variable or subrange type"

label eBadArgToNil:
    put "Argument to 'nil' must be a collection"

label eBadArgToSize:
    put "Argument to 'size' must be a variable"

label eBadArgToStringop:
    put "Invalid argument to 'strdelete'/'strmove'/'strreplace'"

label eBadArgToUpper:
    put "First argument to 'upper' must be an array, a string or char variable, or a subrange type"

label eBadSetElement, eSetElementOutOfRange:
    put "Set element value is not in the range of the specified set type"

label eBindToCompileTimeConstant:
    put "'bind' to compile time constant"

label eBitsAssignmentTargetMustBeNat:
    put "Variable in 'bits' assigment must be 'nat' type"

label eBitsExpnMustBeInteger:
    put "Expression in 'bits' reference must be integer"

label eBitsTypeMustBeSubrange:
    put "Named type in 'bits' reference must be a subrange type"

label eCannotInitializeFlexChars:
    put "Dynamic chars cannot be initialized"

label eCannotInitializeFlexArrayOrChar:
    put "Dynamic arrays and 'char's must not have an 'init' clause"

label eCannotAssignToFlexChar:
    put "Cannot assign to dynamic chars"

label eCannotAssignToFlexArray:
    put "Cannot assign to dynamic arrays"

label eCharBoundMustBeAnIntegerExpn:
    put "Char size must be integer"

label eCharLengthIllegal:
    put "Illegal length of char type"

label eCompileTimeReferenceParameter:
    put "Compile time value passed to reference parameter"

label eDeviceMonitorPriorityMustBeInt:
    put "Device monitor priority must be integer"

label eDimensionRequestedLargerThanArrayNumberOfIndices:
    put "Dimension number in 'upper' or 'lower' is too large"

label eDimensionRequestedLessThanOne:
    put "Dimension number in 'upper' or 'lower' is too small"

label eExpressionPassedByReference:
    put "Parameter is the wrong type (Expression passed to reference parameter)"

label eExternalAddressWrongType:
    put "External address specification must be integer or string"

label eForkAddressVariableMustBeAddressInt:
    put "Fork address variable must be addressint"

label eForkStackSizeExpnMustBeInteger:
    put "Fork stack size expression must be integer"

label eForkStatusVariableMustBeBoolean:
    put "Fork status variable must be boolean"

label eFractionWidthOnlyAppliesToIntegersAndReals:
    put "'put' fraction width applies only to integer or real items"

label eIOFileNumberExpnMustBeInteger, eStreamNumberMustBeInteger:
    put "Input/Output stream number must be an integer"

label eIOStatusVariableMustBeInteger:
    put "Input/Output status variable must be an integer"

label eIllegalAndEqual:
    put "Target of 'and=' must be boolean or integer"

label eIllegalAssignment:
    put "Target of assignment is not a variable and hence cannot be assigned to"

label eIllegalCaseType:
    put "Case expression must be integer or enumerated element or char type"

label eIllegalDivEqual:
    put "Target of 'div=' must be integer or real"

label eIllegalExponentialEqual:
    put "Target of '**=' must be integer or real"

label eIllegalForIndexType:
    put "'for' range bounds must be both integers or char or both elements of the same enumerated type"

label eIllegalIndexType:
    put "Array index type must be a subrange or enumerated type"

label eIllegalInitType:
    put "'init' is used only to initialize arrays, records and unions"

label eIllegalIntNatSubrange:
    put "Subrange lower bound is negative and upper bound is 'nat'"

label eIllegalMinusEqual:
    put "Target of '-=' must be integer or real"

label eIllegalModEqual:
    put "Target of 'mod=' must be integer or real"

label eIllegalOrEqual:
    put "Target of 'or=' must be boolean or integer"

label eIllegalPlusEqual:
    put "Target of '+=' must be integer, string or real"

label eIllegalPutGetOperandType:
    put "Illegal 'put' or 'get' item"

label eIllegalRangeUpperBoundLessThanLower:
    put "Lower bound must be less than or equal to upper bound"

label eIllegalRealDivEqual:
    put "Target of '/=' must be real"

label eIllegalSubscripts:
    put "Routine has too many arguments"

label eIllegalSetBaseRange:
    put "Set base type has too many elements"

label eIllegalShiftEqual:
    put "Target of 'shr=' or 'shl=' must be integer"

label eIllegalStarEqual:
    put "Target of '*=' must be integer or real"

label eIllegalSubrangeType:
    put "Subrange bounds must be integers or chars or enumerated elements"

label eIllegalSubstringIndexType:
    put "Substring range bounds must be integer"

label eIllegalSubstringValue:
    put "Substring expression must be greater than 0 and less than or equal to string/char size"

label eIllegalSubstringValues:
    put "Substring lower bound must be greater than 0 and lower bound minus 1 must be less than or equal to upper bound"

label eIllegalTypeCheatValue:
    put "Type cheat size expression value is not valid for the expression type"

label eIllegalUnionInitTagValue:
    put "Union init tag value not in union definition"

label eIllegalUseOfAll:
    put "Incorrect use of 'all'"

label eIllegalUseOfPredefined:
    put "Predefined identifier " ..
    Ident.PutIdent(errorIdent)
    put " used incorrectly"

label eIllegalVariableReference:
    put "Illegal Variable Reference"

label eIllegalXorEqual:
    put "Target of 'xor=' must be integer"

label eIncompatibleAssignmentTypes:
    put "Assigned value is the wrong type"

label eIncompatibleCaseLabel:
    put "Case alternative label is the wrong type"

label eIncompatibleComparisonTypes:
    put "Operands of comparison operators must be of the same type"

label eIncompatibleConstantValueType:
    put "Initialization value is the wrong type"

label eIncompatibleForIndexTypes:
    put "'for' range bounds must be both integers or chars or both elements of the same enumerated type"

label eIncompatibleInitValue:
    put "Initial value is the wrong type"

label eIncompatibleResultType:
    put "'result' value is the wrong type"

label eIncompatibleSetElementType, eWrongSetElementType:
    put "Set element is the wrong type"

label eIncompatibleSubrangeTypes:
    put "Lower bound of subrange is not the same type as upper bound"

label eIncompatibleSubscriptTypes:
    put "Subscript of " ..
    Ident.PutIdent(errorIdent)
    put " is the wrong type"

label eIncompatibleTagTypes:
    put "Tag value is the wrong type"

label eIncompatibleValueActualType:
    put "Parameter is the wrong type"

label eInitStringValueTooBigToFit:
    put "String value in 'init' is too long"

label eInitValueNotInRange:
    put "Initial value is out of range"

label eIntegerExponentiatePowerNegative:
    put "Integer exponent must not be negative"

label eInterruptProcedureNumberMustBeNat:
    put "Interrupt procedure device specification must be nat"

label eMissingUnionInitTagValue:
    put "Union init must have a tag value"

label eNonArithmeticType:
    put "Operands of arithmetic operators must be integer or real"

label eNonBooleanCondition:
    put "'if' or 'assert' condition must be boolean"

label eNonBooleanType:
    put "Operands of boolean operators must be boolean"

label eNonCompileTimeExpression:
    put "Compile-time value required"

label eNonComparisonType:
    put "Operands of comparison operators must be scalars or strings"

label eNonLogicalType:
    put "Operands of logical operators must be integer"

label eNonPointerNewOrFree:
    put "Second operand of 'new' or 'free' must be a pointer variable"

label eNonPriorityOrTimeOutConditionMustNotHaveWaitExpn:
    put "Only 'priority' and 'timeout' conditions may have a wait expression"

label eNonSetType:
    put "Operands of set operators must be sets"

label eNonStringType:
    put "Operands of the string '+' operator must be strings or chars"

label eNonTagInTagStmt:
    put "First operand of 'tag' statement must be a union"

label eOpenFileNameMustBeString:
    put "Second argument to 'open' statement must be string"

label eOpenFileNameMustBeStringOrInt:
    put "Second argument to 'open' statement must be integer or string"

label eOpenFileNumberVarMustBeInteger:
    put "FirstArgument to 'open' statement must be integer"

label eOpenModeMustBeString:
    put "Third argument to open must be string"

label ePackedBind:
    put "Bind to element of packed array/record/union"

label ePackedReferenceActual:
    put "Element of packed array/record/union passed by reference"

label ePriorityOrTimeOutConditionMustHaveWaitExpn:
    put "'Priority' and 'timeout' conditions must have a wait expression"

label eProcessStackSizeMustBeInt:
    put "Process stack size expression must be integer"

label eQuitReasonExpnMustBeInteger:
    put "'quit' reason expression must be integer"

label eReadOrWriteRegisterVariable:
    put "'read' or 'write' of a register variable or 'for' loop index"

label eReadWriteItemNotVariable:
    put "'read' or 'write' item is not a variable"

label eReadWriteSizeMustBeInteger:
    put "'read' or 'write' size expression must be integer"

label eReadWriteSizeResultVariableMustBeInteger:
    put "'read' or 'write' size result variable must be integer"

label eRealStorageSizeMustBeInt:
    put "'real' storage size expression must be integer"

label eRedeclarationOfStubSubprogramHasDifferentFormals:
    put "Redeclaration of stub subprogram has different formal parameters"

label eRegisterBind:
    put "Bind to register variable"

label eRegisterReferenceActual:
    put "Register variable passed by reference"

label eRegisterTypeCheatAssignment:
    put "Type cheat assignment must not be register variable"

label eSeekExpnMustBeInteger:
    put "'seek' expression must be integer"

label eSetBaseTypeMismatch:
    put "Operands of set operators must be sets of the same base type"

label eSizeOfCompileTimeConstant:
    put "Argument to 'size' is a compile-time constant"

label eSizeOfOpaqueObject:
    put "Argument to 'size' is an opaque type or variable"

label eStorageSizeMustBeInt:
    put "Precision expression must be integer"

label eStringBoundMustBeAnIntegerExpn:
    put "String bound must be integer"

label eStringLengthIllegal:
    put "String maximum length must be in the range 1..", maxStringSize

label eStubConstantMustBeCompileTime:
    put "Constants declared in a stub must be compile time expressions"

label eSubscriptOutOfRange:
    put "Subscript value is out of range"

label eTellResultVariableMustBeInteger:
    put "Second argument to 'tell' statement must be an integer"

label eTooFewActuals:
    put "Too few parameters in call to procedure/function/process"

label eTooFewInitElements:
    put "Too few initial values"

label eTooFewSubscripts:
    Ident.PutIdent(errorIdent)
    put " has too few subscripts"

label eTooManyActuals:
    put "Too many parameters in call to procedure/function/process"

label eTooManyInitElements:
    put "Too many initial values"

label eTooManySubscripts:
    Ident.PutIdent(errorIdent)
    put " has too many subscripts"

label eTypeCheatSizeNotInteger:
    put "Type cheat size expression must be integer"

label eTypeCheatSizeOnlyAppliesToIntReal:
    put "Type cheat expression with type cheat size must be integer or real"

label eUnionLabelIncompatibleType:
    put "Union alternative label is the wrong type"

label eUnionLabelMustBeCompileTime:
    put "Union alternative label must be a compile-time value"

label eUnresolvedForwardInCollection:
    put "'forward' element type of collection must be declared before the collection is used"

label eUpperOfStringMustNotHaveSecondParm:
    put "'upper' of a string must not have a second parameter"

label eVariableTypeCheatExpected:
    put "Expression that is 'type' converted must be a variable"

label eWaitExpnMustBeInteger:
    put "'wait' priority or timeout express must be integer"

label eWidthExprMustBeIntExpr:
    put "Width expressions in put items must be integer"

label eWidthExpressionMustBeANonNegativeInteger:
    put "'put' or 'get' width must be a non-negative integer"

label eWidthFieldOnlyAppliesToStringGets:
    put "'get' width applies only to strings"

label eWriteItemCompiletimeConstant:
    put "Argument to 'write' statement is a compiletime constant"

label eWrongCollectionNewOrFree:
    put "Second operand of 'new' or 'free' is not a pointer to the collection"

label eWrongCollectionSubscriptType:
    put "Collection subscript is not a pointer to the specified collection"

label eWrongParametricActualType:
    put "Parametric procedure/function has wrong parameter/result type"

label eWrongReferenceActualType:
    put "Parameter is the wrong type"

label eCompileTimeAdditionOverflow:
    put "Compile-time addition overflow"

label eCompileTimeMultiplyOverflow:
    put "Compile-time multiply overflow"

label eCompileTimeDivByZero:
    put "Compile-time 'div' by zero"

label eCompileTimeModByZero:
    put "Compile-time 'mod' by zero"

label eCompileTimeShiftByNegativeValue:
    put "Compile-time 'shr' or 'shl' by negative value"

label eStorageSizeOnCharSubrange:
    put "Storage size not permitted on char subranges"

label eStringConcatenateOverflow:
    put "Result of string concatenation is longer than ", maxStringSize,
        " characters"

label eSymbolStackOverflow:
    put "Expression nesting too deep (Sem2SSO)"

label eUnionBodyCountOverflow:
    put "Union nesting too deep (Sem2UBCO)"

label eUnionBodyCountValueOverflow:
    put "Too many union alternatives"

label eEmitBufferOverflow:
    put "Expression too long or complex (Sem2EBO)"

label eEmitBufferStackOverflow:
    put "Expression nesting too deep (Sem2EBSO)"

label eValueOverflow:
    put "Expression nesting too deep (Sem2VO)"

label eValueTableOverflow:
    put "Too many compile-time constants in the program (Sem2VTO)"

label eNoMoreStringSpace:
    put "Too many strings in program (Sem2NMSS)"

label eOrdOnlyAppliesToSingleCharacterStrings :
    put "Actual parameter of 'ord' must be a string of length 1"

label eSymbolTableOverflow :
    put "Too many declarations in the program (Sem2STO)"

label eNoFreeDummySymbols :
    put "Expression too complex (Sem2NFDS)"

label eNoFreeDummyTypes :
    put "Expression too complex (Sem2NFDT)"

label eTypeStackOverflow :
    put "Expression nesting too deep (Sem2TSO)"

label eTypeTableOverflow :
    put "Too many types in the program (Sem2TTO)"

label eTypeRangeTableOverflow:
    put "Too many types ranges in the program (Sem2TRTO)"

label eTypeArrayIndexOverflow:
    put "Too many array indicies in the program (Sem2TAIO)"

label eUnionMapTableOverflow:
    put "Too many union labels in the program (Sem2UMTO)"

label eSubstringOverflow:
    put "Too many nested substrings in the program (Sem2SubO)"

label eScopeDisplayOverflow :
    put "Scope nesting too deep (Sem2ScDO)"

label eScopeStackOverflow :
    put "Scope Nesting too deep (Sem2ScStO)"

label eScopeSymbolOverflow :
    put "Too many declarations in the program (Sem2ScSO)"

label eScopeTableOverflow :
    put "Too many parameter lists in the program (Sem2ScTO)"

label eCountValueOverflow :
    put "List too long (Sem2CVO)"

label eCountOverflow :
    put "Nesting too deep (Sem2CO)"

label eSslStackOverflow :
    put "Nesting too deep (Sem2SslSO)"
