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

stub module Utility2
    import var Expression, var Tree, var Token, var tNode, var eNode,
	   var strings, var Types, debugFile, var Identifier, var CTypes,
	   Error, asNode, ExpnType, VariableId, ManifestExpression, InRange,
	   VariableType, SetIndirection, NewFlexScope, PopFlexScope,
	   ResetVarType, SimpleType, SimplifyType, var TransExpn,
	   TransformArrayType, var TransformAssignment, TransformRecordType,
	   TransformUnionType, varTransformProcedure, varTransformFunction,
	   unChecked, prefixRecordUnion, SimpleExpression, CreateBeginBlock,
	   ExpnTypeTree, var flexTop, var flexStack, predtree

    export ~.TransformType, ~.TransformVar, ~.TransformConst,
	   ~.TransformAsm, ~.TransformGrant, ~.TransformCollection,
	   ~.TransformIo, ~.TransformQuit, ~.TransformTag,
	   ~.TransformFork, ~.TransformInit, ~.TransformExternal,
	   ~.TransformForward, ~.TransformBind, ~.PossibleDynamicVar,
	   ~.TransformConditionVar

    % Utility2 -- helper routines for Transform
 
    procedure TransformBind (t : TreePointer)

    procedure TransformType (t : TreePointer)

    procedure TransformVar (t : TreePointer)  

    procedure TransformConditionVar (t : TreePointer)  

    procedure TransformConst (t : TreePointer)  

    procedure TransformAsm (t : TreePointer)

    procedure TransformGrant (t : TreePointer)

    procedure TransformCollection (t : TreePointer)

    procedure TransformIo (t : TreePointer)

    procedure TransformQuit (t : TreePointer)

    procedure TransformTag (tp : TreePointer)

    procedure TransformFork (t : TreePointer)

    procedure TransformInit (t : TreePointer)

    procedure TransformExternal(t : TreePointer)

    procedure TransformForward(t : TreePointer)

    procedure PossibleDynamicVar (t : TreePointer, id : ExpressionPointer)

end Utility2
