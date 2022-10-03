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

parent "semantic.t"

stub module Types
    import  Error, statistics, var Value
    export  PushType, PushNewType, PushBuiltInType,
	    PushComponentType, PushLeftComponentType, PushResultType, 
	    ReplaceBuiltInType, ReplaceComponentType, ReplaceRootType,
	    PushCharStringDummyType, ReplaceResultType, PopType, TypEnterSymbol,
	    EnterFields, EnterFormals, EnterLeftComponentType,
	    EnterLeftResultType, EnterLeftRootType, TypEnterAttribute,
	    EnterLeftTypeSizeFromRight, TypEnterKind, TypClearAttribute,
	    TypeIndexx, TypeKind, TypeHasAttribute, TypeSymbol, LeftTypeKind,
	    CopyLeftType, SwapTypes, CopyLeftBounds, PushLeftResultType,
	    TypeFormals, TypeFields, TypStackEmpty, TypStats, DumpTypes,
	    TypeFirstArrayIndex, TypeLastArrayIndex, EnterFirstArrayIndex,
	    EnterLastArrayIndex, EnterArrayBound, SameArrayRanges, FlexRange,
	    TypeStringBound, EnterStringBound, SameTypes,
	    ReplaceTypeWithSameKindAndStorageSize, LeftTypeHasAttribute,
	    ReplaceTypeWithSameKindAndValue,
	    TypeSetSubrangeLowerBound, SameStringBounds,
	    TypeSetSubrangeUpperBound, EnterUnionTagSymbol,
	    PushCountIndexType, EnterLeftSetBase, EnterOpaqueTypeNumber,
	    EnterRangeBounds, EnterEnumeratedElementRoot,
	    TypeSymbolsSame, TypeLowerBoundsSame, TypeBoundsSame,
	    TypeEnumeratedSame, TypeOpaqueTypeNumbersSame, UnionTag,
	    UnionMapPush, UnionMapPop, UnionMapEnter, UnionTagValueLegal,
	    TypeSize, UnionBodyValue, EnterUnionMap,
	    TypeLowerBound, TypeUpperBound, TypeCheatSizeLegal,
	    SwapSecondAndThirdTypes, SameKindsAndSizes,
	    EnterExports, TypeExports, UnMakeOpaque, ReMakeOpaque

    procedure PushType (typex: TypeIndex)

    procedure PushBuiltInType (kind: TypeKinds)

    procedure PushNewType (kind: TypeKinds)

    procedure PushComponentType

    procedure PushLeftComponentType

    procedure PushResultType

    procedure PushLeftResultType

    procedure PushCharStringDummyType (v : ValueIndex)

    procedure PopType

    procedure ReplaceBuiltInType (kind: TypeKinds)

    procedure ReplaceComponentType

    procedure ReplaceRootType

    procedure ReplaceResultType

    procedure TypEnterSymbol (symbol: SymbolIndex)

    procedure EnterFields (scope: ScopeIndex)

    procedure EnterFormals (scope: ScopeIndex)

    procedure EnterExports (scope: ScopeIndex)

    procedure ReplaceTypeWithSameKindAndStorageSize (val: ValueIndex)

    procedure ReplaceTypeWithSameKindAndValue (val: ValueIndex)

    procedure EnterLeftComponentType           

    procedure EnterLeftResultType

    procedure EnterLeftRootType

    procedure EnterLeftTypeSizeFromRight

    procedure TypEnterAttribute (attribute: TypeAttributes)

    procedure TypEnterKind (kind: TypeKinds)

    procedure TypClearAttribute (attribute: TypeAttributes)

    procedure CopyLeftType

    procedure CopyLeftBounds

    procedure SwapTypes

    procedure SwapSecondAndThirdTypes

    procedure TypStats

    procedure DumpTypes

    function TypeIndexx : TypeIndex

    function TypeCheatSizeLegal ( s : int) : boolean

    function TypeKind : TypeKinds   

    function LeftTypeKind : TypeKinds

    function SameKindsAndSizes : boolean

    function TypeHasAttribute (attribute: TypeAttributes) : boolean
    
    function LeftTypeHasAttribute (attribute: TypeAttributes) : boolean

    function TypeSymbol : SymbolIndex

    function TypeFormals : ScopeIndex

    function TypeExports : ScopeIndex

    function TypeFields : ScopeIndex

    function TypStackEmpty : boolean

    function TypeFirstArrayIndex : int

    function TypeLastArrayIndex : int

    procedure EnterFirstArrayIndex

    procedure EnterLastArrayIndex

    procedure EnterArrayBound

    function SameArrayRanges : boolean

    function FlexRange : boolean

    function TypeStringBound : ValueIndex

    function TypeSize : ValueIndex

    procedure EnterStringBound (vIndx : ValueIndex)

    function TypeSetSubrangeLowerBound : ValueIndex

    procedure SameStringBounds(var v : ValueIndex, var b : boolean)

    function SameTypes : boolean

    function TypeSetSubrangeUpperBound : ValueIndex

    procedure EnterUnionTagSymbol(sIndex : SymbolIndex)

    procedure PushCountIndexType(offset : int)

    procedure EnterLeftSetBase

    procedure EnterOpaqueTypeNumber

    procedure UnMakeOpaque

    procedure ReMakeOpaque

    procedure EnterRangeBounds (low, up: ValueIndex, flex : boolean)

    procedure EnterEnumeratedElementRoot

    function TypeSymbolsSame : boolean

    function TypeLowerBoundsSame : boolean

    function TypeBoundsSame : boolean

    function TypeEnumeratedSame : boolean

    function TypeOpaqueTypeNumbersSame : boolean

    function UnionTag : SymbolIndex

    procedure UnionMapPush

    procedure UnionMapPop

    procedure UnionMapEnter(v : ValueIndex, bodyNo : int)

    procedure UnionTagValueLegal (v : ValueIndex, var r : boolean)

    function UnionBodyValue (v : ValueIndex) : int

    procedure EnterUnionMap

    function TypeLowerBound : ValueIndex

    function TypeUpperBound : ValueIndex

end Types
