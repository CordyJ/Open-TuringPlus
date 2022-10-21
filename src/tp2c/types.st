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

stub module Types
    import var Expression, var eNode, var tNode, TreeDump, var ArrayString,
	   asNode, TreeCopy, debugFile, CTypeEnterSize, varTypeTree, Error

    export SetType, GetType, HoldIdentifier, MakeType, Dump,
	   Init, PushDelimiter, PopDelimiter, AssertTypeStackEmpty,
	   EnterAttribute, ClearAttribute, HasAttribute, Indirection,
	   IncreaseIndirection, DecreaseIndirection, GetKind, SetKind,
	   SetKindProc, ResetIndirection, SetIndirection, GetTree,
	   EnterTypeInfo, ArrayStringInformation,
	   EnterUnionNumber, UnionNumber, UnionFieldNumber, Component,
	   CollectionInformation, TransferTypeInfo

    %  Turing Plus to C Translator
    %  Module: Types - provide GetType and SetType of an id plus construction.
    %  By:     Mark Mendell
    %  Date:   28 Oct 1986

    procedure SetType(id:ExpressionPointer,tipe:TreePointer)

    function GetType (id:ExpressionPointer) : TreePointer

    function GetTree (id:ExpressionPointer) : TreePointer

    procedure HoldIdentifier(id:ExpressionPointer)

    procedure MakeType(tipe:TreePointer)

    procedure AssertTypeStackEmpty

    procedure PushDelimiter

    procedure PopDelimiter

    procedure Dump(stream:int)

    procedure Init

    procedure EnterAttribute (id : ExpressionPointer, attr : AttributeType)

    procedure ClearAttribute (id : ExpressionPointer, attr : AttributeType)

    function HasAttribute (id : ExpressionPointer,
			 attr : AttributeType) : boolean

    procedure IncreaseIndirection (id: ExpressionPointer,
				   iKind : IndirectionKind)

    procedure DecreaseIndirection (id: ExpressionPointer,
				   iKind : IndirectionKind)

    procedure ResetIndirection (id: ExpressionPointer)

    procedure SetIndirection (id: ExpressionPointer, indir : nat,
			      iKind : IndirectionKind)

    function Indirection (id: ExpressionPointer) : IndirectionType

    procedure SetKind (id: ExpressionPointer, kind : TypeKinds)

    function GetKind (id: ExpressionPointer) : TypeKinds

    procedure SetKindProc (kindproc : function f (t : TreePointer) : TypeKinds)

    procedure EnterTypeInfo (id : ExpressionPointer)

    procedure TransferTypeInfo (fromId, toId : ExpressionPointer)

    function ArrayStringInformation (id : ExpressionPointer) :
	ArrayStringPointer

    function CollectionInformation (id : ExpressionPointer) : TreePointer

    procedure EnterUnionNumber (id : ExpressionPointer, un, ufn : nat2)

    function UnionNumber (id : ExpressionPointer) : nat2

    function UnionFieldNumber (id : ExpressionPointer) : nat2

    function Component (id : ExpressionPointer) : TreePointer

end Types
