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

parent "transform.bd"

stub module Utility
    import var Expression, var Tree, var Token, var tNode, var eNode,
	   var strings, var Types, debugFile, var Identifier, var CTypes,
	   Error, asNode, ExpnType, VariableId, ManifestExpression, InRange,
	   VariableType, SetIndirection, unChecked, var flexTop,
	   var flexStack, predtree, timeSlice, currentMonitorVariable,
	   SimpleExpression, prefixRecordUnion, varTransformFunction,
	   varTransformProcedure

    export ~.CreateNewType, ~.ReplaceForExpressionIfNecessary,
	   ~.MoveAllDeclarationsToTop, ~.PrefixAllDeclarations,
	   ~.ResetType, ~.OneToZeroOrigin, ~.SimpleType,
	   ~.SimplifyType, ~.TransformArrayType, ~.TransformUnionType,
	   ~.TransformRecordType, ~.ResetVarType,
	   ~.IsFunctionResultVariableNecessary,
	   ~.DeclareMonitorVariable, ~.MonitorEntryTimeSlice

    % Utility -- helper routines for Transform

    procedure CreateNewType (var t: TreePointer, e: ExpressionPointer)

    procedure ReplaceForExpressionIfNecessary (forNode, t : TreePointer, 
					       decrease : boolean)

    procedure IsFunctionResultVariableNecessary (fcnId : ExpressionPointer,
						 tp : TreePointer)

    procedure MoveAllDeclarationsToTop (tp : TreePointer)

    procedure PrefixAllDeclarations (tp : TreePointer)

    procedure MonitorEntryTimeSlice (tp : TreePointer,
				     fcnName : ExpressionPointer)

    procedure DeclareMonitorVariable (tp, deviceMonitor : TreePointer,
				      var monVar : ExpressionPointer,
				      monName : ExpressionPointer)

    procedure ResetType (t : TreePointer)

    procedure OneToZeroOrigin (ep : ExpressionPointer)

    function SimpleType (t : TreePointer) : boolean

    procedure SimplifyType (t : TreePointer, var tipe : TreePointer)

    procedure TransformArrayType (st : TreePointer, var t : TreePointer)

    procedure TransformUnionType (st, t : TreePointer)

    procedure TransformRecordType (st, t : TreePointer,
				   unionNumber, unionFieldNumber : nat2)

    procedure ResetVarType (varNode, tipe : TreePointer)

end Utility
