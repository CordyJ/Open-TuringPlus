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

parent "transexpn.bd"

stub module TransExpnUtility
    import predtree, var Expression, var Tree, var tNode, var eNode, BitMask,
	   ExpnType, var Types, OneToZeroOrigin, asNode, VariableId, InRange,
	   CreateBeginBlock, ManifestExpression, var BBAndFCCallNode,
	   var CTypes, ExpnTypeTree

    export ~.BeginBlockAndFunctionCall, ~.TransformToString,
	   ~.TransformToChar, ~.TransformToCharString,
	   ~.LargeSetIn, ~.StringComparison, ~.CharStringComparison,
	   ~.TransFormSingleCharCharSubstring,
	   ~.CreatePredefinedSubstringCall, ~.CreateLargeSetTemp,
	   ~.CreateCommaList, ~.FindOperand, ~.SetCmpOp, ~.IsVariable,
	   ~.SetAll, ~.CastableExpression, ~.TreeFromKindSize

    % TransExpnUtility -- helper routines for TransformExpression
 
    procedure CreateCommaList (subExpn : ExpressionPointer,
			       var newExpn : ExpressionPointer)

    function FindOperand (ep : ExpressionPointer) : ExpressionPointer

    function SetCmpOp (operation : int, subExpn : ExpressionPointer) : int

    function SetAll (lowBound, upperBound : int) : nat4

    function CastableExpression (register e : ExpressionPointer) : boolean

    function TreeFromKindSize (eKind : TypeKinds, sz : int) : TreePointer

    function IsVariable (e : ExpressionPointer) : boolean

    procedure BeginBlockAndFunctionCall (t, tempType : TreePointer,
				 predFcn : int,
				 var newId, subsExpn : ExpressionPointer,
				 subExpn : ExpressionPointer)

    procedure TransformToString (t : TreePointer, ep : ExpressionPointer,
				 eKind : TypeKinds, subExpn : ExpressionPointer)

    procedure TransformToChar (t : TreePointer, ep : ExpressionPointer,
				 eKind : TypeKinds, subExpn : ExpressionPointer)

    procedure TransformToCharString (t : TreePointer, ep : ExpressionPointer,
				 eKind : TypeKinds, subExpn : ExpressionPointer)

    procedure StringComparison (t : TreePointer, ep : ExpressionPointer)

    procedure CharStringComparison (t : TreePointer, ep : ExpressionPointer)

    procedure TransFormSingleCharCharSubstring(ep, kind : ExpressionPointer)

    procedure CreatePredefinedSubstringCall(t : TreePointer,
					substringexpn : ExpressionPointer,
					substringType : TypeKinds,
					substringKind : int,
					var newId : ExpressionPointer,
					subExpn : ExpressionPointer)

    procedure LargeSetIn (t : TreePointer, ep : ExpressionPointer,
			  lowBound : int4, upperBound : ExpressionPointer,
			  wasIn : boolean, subExpn : ExpressionPointer)

    procedure CreateLargeSetTemp(newStmt : TreePointer,
			     var newId : ExpressionPointer,
				 setType : ExpressionPointer)
end TransExpnUtility
