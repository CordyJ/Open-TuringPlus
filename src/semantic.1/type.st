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
    import  Error, statistics
    export  PushType, PushNewType, PushBuiltInType,
	    PushComponentType, PushResultType, 
	    ReplaceBuiltInType, ReplaceComponentType,
	    ReplaceResultType, PopType, TypEnterSymbol,
	    EnterFields, EnterFormals, EnterImports, EnterLeftComponentType,
	    EnterLeftResultType,
	    EnterLeftRootType, TypEnterAttribute,
	    TypEnterKind, TypClearAttribute, TypeIndexx,
	    EnterGrant, TypeGrant,
	    TypeKind, TypeHasAttribute, TypeSymbol, LeftTypeKind,
	    TypeExports, CopyLeftType, SwapTypes,
	    TypeFormals, TypeImports,
	    TypeFields, TypStackEmpty, TypStats, DumpTypes

    procedure PushType (typex: TypeIndex)

    procedure PushBuiltInType (kind: TypeKinds)

    procedure PushNewType (kind: TypeKinds)

    procedure PushComponentType

    procedure PushResultType

    procedure PopType

    procedure ReplaceBuiltInType (kind: TypeKinds)

    procedure ReplaceComponentType

    procedure ReplaceResultType

    procedure TypEnterSymbol (symbol: SymbolIndex)

    procedure EnterGrant (scope: ScopeIndex)

    procedure EnterFields (scope: ScopeIndex)

    procedure EnterFormals (scope: ScopeIndex)

    procedure EnterImports (scope: ScopeIndex)

    procedure EnterLeftComponentType           

    procedure EnterLeftResultType

    procedure EnterLeftRootType

    procedure TypEnterAttribute (attribute: TypeAttributes)

    procedure TypEnterKind (kind: TypeKinds)

    procedure TypClearAttribute (attribute: TypeAttributes)

    procedure CopyLeftType

    procedure SwapTypes

    procedure InitializeBuiltInType (kind: TypeKinds)

    procedure TypStats

    procedure DumpTypes

    function TypeIndexx : TypeIndex

    function TypeKind : TypeKinds   

    function LeftTypeKind : TypeKinds

    function TypeHasAttribute (attribute: TypeAttributes) : boolean

    function TypeSymbol : SymbolIndex

    function TypeFormals : ScopeIndex

    function TypeGrant : ScopeIndex

    function TypeFields : ScopeIndex

    function TypeExports : ScopeIndex

    function TypeImports : ScopeIndex

    function TypStackEmpty : boolean
end Types
