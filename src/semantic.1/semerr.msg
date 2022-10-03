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

label eIOIllegalInFunction :
    put "Functions cannot have side-effects, hence I/O must not be used in a function"

label eMissingValue :
    put "Expression or value expected here"

label eIllegalUseOfSubstring :
    put "Substringing only applies to string values"

label eUnresolvedForwardInCollection :
    put "'forward' element type of collection must be declared before the collection is used"

label eModuleInvariantNotLegal :
    put "Module invariant must appear before declaration of exported procedures/functions"

label eAutoImportPassesItself :
    put "Procedure/function that passes itself as a parameter " ..
    put "must have an explicit import list"

label eRecursivePassesGlobalVarByRef :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " passed as a reference parameter in direct recursion to cause an alias"

label eParametricImportOverlapsImports :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " used by parametric procedure/function is also used by called procedure/function to cause an alias"

label eInvisibleImportByParametric :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " used by parametric procedure/function is invisible in this scope"

label eCollectionsNotAllowedInSubprograms :
    put "Collections may not be declared in subprograms"

label eVarParametricImportReadOnlyHere :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " is used as a 'var' by parametric procedure is read-only in this scope"

label ePotentialAliasDueToParaImportActualOverlap :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " used by parametric procedure/function overlaps a reference parameter to cause an alias"

label eVarImportReadOnlyInCurrentContext :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " is used 'var' by called procedure but is read-only in this scope"

label eCannotImportVar :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " cannot be used 'var' in a recursive procedure"

label eUnresolvedForwardType :
    put "Forward type " ..
    Ident.PutIdent(errorIdent)
    put " has not been declared"

label eFunctionTransitivelyImportsSpecialVar :
    put "Function calls a procedure that uses input/output or " ..
    put "random number generation to cause a side-effect"

label eFunctionCannotImportAForwardProcedure :
    put "Function must not import 'forward' procedures"

label eMonitorEntryInvokedWithinMonitor:
    put "Entry procedure/function " ..
    Ident.PutIdent(errorIdent)
    put " invoked within monitor"

label ePredefinedMisused, eIllegalUseOfPredefined :
    put "Predefined identifier " ..
    Ident.PutIdent(errorIdent)
    put " used incorrectly"

label eUnimportedSymbol :
    Ident.PutIdent(errorIdent)
    put " has not been imported"

label eBodyNotProcedure :
    put "Body of procedure " ..
    Ident.PutIdent(errorIdent)
    put " declared as a function"

label eBodyNotFunction :
    put "Body of function " ..
    Ident.PutIdent(errorIdent)
    put " declared as a procedure"

label eBodyIdentDoesNotMatch :
    put "Body identifier " ..
    Ident.PutIdent(errorIdent)
    put " does not match stub name"

label eProcedureEndIdentDoesNotMatch :
    put "End identifier " ..
    Ident.PutIdent(errorIdent)
    put " does not match procedure/function/process name"

label eEndNameNotModuleName :
    put "End identifier " ..
    Ident.PutIdent(errorIdent)
    put " does not match module name"

label eEndNameNotMonitorName :
    put "End identifier " ..
    Ident.PutIdent(errorIdent)
    put " does not match monitor name"

label eBoundVariablesOverlap :
    put "Bound variables overlap to cause an alias"

label eFormalImported :
    Ident.PutIdent(errorIdent)
    put " is a parameter and cannot be explicitly imported"

label eSymbolPreviouslyImported :
    Ident.PutIdent(errorIdent)
    put " is imported more than once"

label eForwardTypeInCollectionPreviouslyDefined :
    Ident.PutIdent(errorIdent)
    put " has been previously declared"

label eForwardTypeNameReused :
    Ident.PutIdent(errorIdent)
    put " has been previously declared as a forward type"

label eNonCollectionPointer :
    put "Object of pointer is not a collection"

label eIllegalUseOfForwardType :
    put "Forward type " ..
    Ident.PutIdent(errorIdent)
    put " must be declared before use"

label eNamedTypeNotAType :
    Ident.PutIdent(errorIdent)
    put " is not a type"

label eUndeclaredSymbol :
    Ident.PutIdent(errorIdent)
    put " has not been declared"

label eInvisibleSymbol :
    Ident.PutIdent(errorIdent)
    put " has been bound to and hence is invisible in this scope"

label eSymbolPreviouslyDeclared :
    Ident.PutIdent(errorIdent)
    put " has been previously declared"

label eModuleFieldNotFound :
    Ident.PutIdent(errorIdent)
    put " is not in the export list of the specified module"

label eReadOnlyModuleProcedureCall :
    put "Exported procedure " ..
    Ident.PutIdent(errorIdent)
    put " cannot be called because the module is read-only in this scope"

label eInvisibleImportedSymbol :
    put "Called procedure uses global variable " ..
    Ident.PutIdent(errorIdent)
    put " that has been bound to and hence is invisible in this scope"

label eMissingActuals :
    put "Missing parameters in call to procedure/function/process "

label eUndeclaredRecordField :
    Ident.PutIdent(errorIdent)
    put " is not a field of the specified record"

label eUndeclaredUnionField :
    Ident.PutIdent(errorIdent)
    put " is not a field of the specified union"

label eNonRecordField :
    Ident.PutIdent(errorIdent)
    put " is not a record/module/enumerated type and hence has no fields"

label eNonExpressionSubprogram :
    put "Expression is not a procedure or function"

label eNonExpressionVariable :
    put "Expression is not a variable"

label eIllegalSubscripts :
    put "Subscripted name " ..
    Ident.PutIdent(errorIdent)
    put " is not an array/string/procedure/function/process/collection"

label eTooManySubscripts :
    Ident.PutIdent(errorIdent)
    put " has too many subscripts"

label eTooFewSubscripts :
    Ident.PutIdent(errorIdent)
    put " has too few subscripts"

label eIllegalUseOfAll :
    put "Incorrect use of 'all'"

label eIllegalTypeCheat :
    put "Invalid first argument to type cheat statement"

label eSymbolNotInEnumeratedRange :
    Ident.PutIdent(errorIdent)
    put " is not an element of the specified enumerated type"

label eCallToNonProcedure :
    Ident.PutIdent(errorIdent)
    put " is not a procedure and hence cannot be called"

label eAssignmentToReadOnly :
    Ident.PutIdent(errorIdent)
    put " is read-only in this scope and cannot be assigned to"

label eAssignmentToTag :
    Ident.PutIdent(errorIdent)
    put " is a union tag and cannot be assigned to ",
	"(must use 'tag' statement to change it)"

label eIllegalAssignment :
    put "Left side of assignment is not a variable and hence cannot be assigned to"

label eReadOnlyCollectionNewOrFree :
    put "Collection " ..
    Ident.PutIdent(errorIdent)
    put " is read-only in this scope and cannot be changed using 'new' or 'free'"

label eNonCollectionNewOrFree :
    put "First operand of 'new' or 'free' must be a collection"

label eReadOnlyOrConstantNewOrFree :
    put "Pointer is constant or read-only in this scope and cannot be changed using 'new' or 'free'"

label eNonPointerNewOrFree, eNonVariableNewOrFree :
    put "Second operand of 'new' or 'free' must be a pointer variable"

label eNonTagInTagStmt :
    put "First operand of 'tag' statement must be a union"

label eReadOnlyTag :
    put "Union is readonly in this scope and cannot be modified by the 'tag' statement"

label eValuelessFunctionReturn :
    put "Function must use 'result', not 'return'"

label eReturnValueInNonFunction :
    put "'result' can be used only in a function"

label eReturnInModule :
    put "'return' can be used only in a subprogram"

label eExitNotInLoop :
    put "'exit' can be used only in a 'loop' or 'for' statement"

label eIllegalPutGetOperandType :
    put "Illegal 'put' or 'get' item"

label eConditionsMustBeDeferredInDeviceMonitor :
    put "Conditions must be 'deferred' in a device monitor"

label eInterruptProcedureCannotBeExported :
    put "Interrupt procedures must not be exported"

label eInterruptProcedureOnlyInDeviceMonitor :
    put "Interrupt procedures may only be declared in device monitors"

label eReadOnlyOpenVariable :
    put "First argument to 'open' statement is readonly in this scope"

label eOpenNotVariable :
    put "First argument to 'open' statement is not a variable"

label eReadWriteSizeResultNotVariable :
    put "Result size for 'read'/'write' item is not a variable"

label eReadOnlyReadWriteSizeResult :
    put "Result size for 'read'/'write' item is readonly in this scope"

label eIOStatusNotVariable :
    put "Input/Output status variable is not a variable"

label eReadOnlyIOStatusVariable :
    put "Input/Output status variable is readonly in this scope"

label eReadOnlyTellResultVariable :
    put "'tell' result variable is readonly in this scope"

label eTellResultNotVariable :
    put "Second argument to 'tell' statement is not a variable"

label eReadWriteItemNotVariable :
    put "Argument to 'read' or 'write' statement is not a variable or runtime constant"

label eReadOnlyReadItem :
    put "Argument to 'read' statement is readonly in this scope"

label eForkOfNonProcess :
    put "'fork' argument must be a process"

label eReadOnlyForkStatusOrAddress :
    put "'fork' status or address variable is readonly in this scope"

label eForkStatusOrAddressNotVariable :
    put "'fork' status or address argument is not a variable"

label eSignalWaitReadOnlyCondition :
    put "'signal' or 'wait' of readonly condition"

label eBitsTypeMustNotHaveDotDot :
    put "'bits' subrange type must not have '..'"

label eDeviceMonitorCallsStubModule :
    put "Device monitors must not call (directly or indirectly) separately compiled modules"

label eDeviceMonitorCallsMonitor :
    put "Device monitors must not call (directly or indirectly) monitor entries"

label eDeviceMonitorCallsDangerousRoutine :
    put "Device monitors must not call monitor entries, stub modules, or stub subprograms"

label eSignalWaitNotCondition :
    put "'signal' or 'wait' argument is not a condition"

label eTooManyActuals :
    put "Too many parameters in call to procedure/function/process"

label eTooFewActuals :
    put "Too few parameters in call to procedure/function/process"

label eReadOnlyPassedToVarFormal :
    put "Variable passed to a 'var' parameter is read-only in this scope"

label eConstantPassedToVarFormal :
    put "Constant passed to a 'var' parameter"

label eNonVariablePassedToVarFormal :
    put "'var' parameter is not a variable"

label eNonVariablePassedToReferenceParameter :
    put "Non-variable passed to reference parameter"

label eReferenceActualsOverlap :
    put "Reference parameters overlap to cause an alias"

label eReferenceActualOverlapsImports :
    put "Global variable " ..
    Ident.PutIdent(errorIdent)
    put " used by called procedure overlaps a reference parameter to cause an alias"

label eExpressionPassedByReference :
    put "Parameter is the wrong type"

label eReadOnlyVarImport :
    Ident.PutIdent(errorIdent)
    put " is read-only in this scope and cannot be imported 'var'"

label eIllegalVarImport :
    put "'var' import must be a variable or module"

label eFunctionImportsVar :
    put "Functions cannot have side-effects, and hence must not import anything 'var'"

label eForwardInImportImproperlyUsed :
    put "'forward' imports can be used only in 'forward' procedure/function declarations"

label eFunctionTransitivelyImportsVar :
    put "Functions cannot have side-effects, and hence must not import a procedure which imports anything 'var'"

label eUnresolvedExportedSymbol :
    put "Identifier " ..
    Ident.PutIdent(errorIdent)
    put " exported from module has not been declared"

label eUnresolvedExternalSubprogram :
    put "Body of exported routine " ..
    Ident.PutIdent(errorIdent)
    put " has not been declared"

label eCannotExportVariable :
    /* Should give the identifier! */
    put "Variables must not be exported"

label eExportedModule :
    put "Modules must not be exported"

label eExportedMonitor :
    put "Monitors must not be exported"

label eResultOnlyUsedInPost :
    put "Function result name can be used only in the 'post' assertion"

label eInitOnlyInPostAssertOrInvariant :
    put "'init' constants can be used only in 'post', 'assert' and 'invariant' assertions"

label eIllegalSubprogramBodyname :
    put "'body' procedure/function " ..
    Ident.PutIdent(errorIdent)
    put " must be previously declared in the same scope"

label eForwardMustBeResolvedAtSameScope :
    put "Forward type " ..
    Ident.PutIdent(errorIdent)
    put " must be declared in its original scope"

label eVarBindToReadOnly :
    put "'var' bind variable " ..
    Ident.PutIdent(errorIdent)
    put " is bound to a variable which is read-only in this scope"

label eNonVariableBind :
    put "Bind variable " ..
    Ident.PutIdent(errorIdent)
    put " is bound to a non-variable"

label eVarFormalIllegalInFunction :
    put "Functions cannot have side-effects, and hence must not have 'var' parameters"

label eUnresolvedForwardSubprogram :
    put "Body of 'forward' procedure/function " ..
    Ident.PutIdent(errorIdent)
    put " has not been declared"

label eForwardInImportsNotRefined :
    put "Body of 'forward' import " ..
    Ident.PutIdent(errorIdent)
    put " has not been declared"

label eImportConflictsWithLocalDeclaration:
    put "Imported symbol " ..
    Ident.PutIdent(errorIdent)
    put " conflicts with symbol defined in local scope below"

label eUnqualifiedNameConflicts :
    put "Unqualified symbol " ..
    Ident.PutIdent(errorIdent)
    put " conflicts with symbol in enclosing scope"

label eUnqualifiedBodyNotFound:
    put "Body subprogram of unqualified symbol " ..
    Ident.PutIdent(errorIdent)
    put " was not declared in this scope"

label eRedeclarationOfStubSubprogramHasDifferentFormals:
    put "Redeclaration of stub subprogram has different formal parameters"

label eBodyMonitorMustBeStubMonitor :
    put "A 'body' 'monitor' must be preceeded by a 'stub' 'monitor'"

label eBodyModuleMustBeStubModule :
    put "A 'body' 'module' must be preceeded by a 'stub' 'module'"

label eCantGrant :
    put "Symbol " ..
    Ident.PutIdent(errorIdent)
    put " cannot be granted"

label eCantGrantVar :
    put "Symbol " ..
    Ident.PutIdent(errorIdent)
    put " cannot be granted as 'var'"

label eSymbolNotGrantedVar :
    put "Symbol " ..
    Ident.PutIdent(errorIdent)
    put " was not granted as 'var'"

label eSymbolNotGrantedOrPervasive :
    put "Symbol " ..
    Ident.PutIdent(errorIdent)
    put " is not pervasive or granted"

label eStubConstantMustBeCompileTime :
    put "Constants declared in a stub must be compile time expressions"

label eMoreThanOneModuleBody :
    put "'body' 'module' has already been defined"

label eMoreThanOneMonitorBody :
    put "'body' 'monitor' has already been defined"

label eReadOnlyVarGrant :
    put "Readonly symbol " ..
    Ident.PutIdent(errorIdent)
    put " cannot be granted as 'var'"

label eUnresolvedGrantSymbol :
    put "Granted symbol " ..
    Ident.PutIdent(errorIdent)
    put " has not been defined"

label eReferenceToInterruptProcedure :
    put "Interrupt procedure may not be called or referenced"

label eOrdOnlyAppliesToSingleCharacterStrings :
    put "Actual parameter of 'ord' must be a string of length 1"

label eSymbolTableOverflow :
    put "Too many declarations in the program (SemSTO)"

label eNoFreeDummySymbols :
    put "Expression too complex (SemNFDS)"

label eTypeStackOverflow :
    put "Expression nesting too deep (SemTSO)"

label eTypeTableOverflow :
    put "Too many types in the program (SemTTO)"

label eScopeDisplayOverflow :
    put "Scope nesting too deep (SemScDO)"

label eScopeSymbolOverflow :
    put "Too many declarations in the program (SemScSO)"

label eScopeTableSymbolOverflow :
    put "Too many declarations in the program (SemScTSO)"

label eScopeTableOverflow :
    put "Too many import/export/parameter lists in the program (SemScTO)"

label eCountValueOverflow :
    put "List too long (SemCVO)"

label eCountOverflow :
    put "Nesting too deep (SemCO)"

label eActualsDisplayOverflow :
    put "Procedure/function call nesting too deep (SemADO)"

label eActualsOverflow :
    put "Too many reference parameters (SemAO)"

label eActualsSymbolOverflow :
    put "Too many reference parameters (SemASO)"

label eSslStackOverflow :
    put "Nesting too deep (SemSslSO)"

label eLoopOverflow :
    put "Loop nesting too deep (SemLO)"

label eSymbolStackOverflow :
    put "Expression nesting too deep (SemSSO)"

label eEmitBufferOverflow :
    put "Expression too long or complex (Sem1EBO)"
