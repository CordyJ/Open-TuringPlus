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

parent "tp2c.t"

stub module Expression
     import var Token, var Identifier, var eNode, var strings,
	    Error, maxint, predefNames, tNode, TreeDump, macdepType,
	    macdepEscapeOrd, macdepDeleteOrd, unsignedLiteralTerminator

     export EnterInteger, EnterReal, EnterString, EnterIdentifier,
            EnterChar, EnterMarkedOperator, SwapTopTwoExpressions,
            EnterTree, EnterPredefinedId, ConstructMarkedOperator, 
            IsLeafNode, End, Dump, Free, Init, 
            EnterSimpleLeaf, EndOp, AssertStackIsEmpty,
            NewOperatorNode, DumpTop, OutputStringValue,
            EnterSubstringKind, NewCopy, Copy, Output, String,
	    CreateUniqueIdentifier, GetInteger, Pop, OutputChar, AreEqual,
	    SetMaximumIdentifier, CreateNamedId

    %   Turing Plus to C Translator
    %   Module:Expression Tree Construction & Manipulation Module 
    %   By:    Mark Mendell
    %   Date:  28 Oct 1986

    procedure EnterInteger(i : int4, kind : int)

    procedure EnterReal(r : TokenString, slen : int)

    procedure EnterString(s : TokenString, slen : int)

    procedure EnterPredefinedId(i,j : int)

    procedure EnterIdentifier(i : int)

    procedure EnterSimpleLeaf(l : int)

    procedure EnterSubstringKind(k : int)

    procedure EnterTree(tp : TreePointer)

    procedure EnterChar(s : TokenString, slen : int)

    procedure EndOp(op, n : int)

    procedure EnterMarkedOperator(o : int)

    procedure SwapTopTwoExpressions

    procedure ConstructMarkedOperator

    procedure End(var z : ExpressionPointer)      

    procedure AssertStackIsEmpty

    function IsLeafNode(e:ExpressionPointer) : boolean

    function AreEqual(e1, e2 : ExpressionPointer) : boolean

    procedure Output(e : ExpressionPointer, stream : int)

    function String(e : ExpressionPointer) : string

    procedure Dump(e : ExpressionPointer, indent, stream : int)

    procedure DumpTop (stream : int)

    procedure Free(e : ExpressionPointer)   

    procedure NewOperatorNode(var e : ExpressionPointer, op:int)   

    procedure NewCopy(e1: ExpressionPointer,var e2:ExpressionPointer)   

    procedure Copy(e1: ExpressionPointer,var e2:ExpressionPointer)   

    procedure CreateUniqueIdentifier(var e1: ExpressionPointer)

    procedure CreateNamedId(var e1: ExpressionPointer, refVal, count : int)

    function GetInteger(e: ExpressionPointer) : int4

    procedure Init

    procedure Pop (var x: ExpressionPointer)

    procedure OutputChar (c : char, stream : int)

    procedure OutputStringValue (s : StringPtr, slen : int, stream : int)

    procedure SetMaximumIdentifier (i : int)

end  Expression
