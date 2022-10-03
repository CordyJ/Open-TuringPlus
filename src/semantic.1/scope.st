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

stub module Scope
    import ScopeIndex, IdentifierIndex, SymbolIndex, SymbolKinds,
	   Error, statistics

    export PushScope, PushCopyScope, PushNewScope, PopScope, ScoEnterSymbol,
	   ReplaceCountSymbol, CloseScope, SaveScope, StripScope,
	   MergeScopes, ScopeContainsSymbol, LookupSymbol, LookupLocalSymbol,
	   LookupCountClosedSymbol, LookupEnclosingLocalSymbol,
	   LookupEnclosingEnclosingLocalSymbol,
	   LookupCountSymbol, ScopeSymbolIndex, ScopeSymbolKind,
	   ScopeSymbolIdent, SavedScopeIndex, ScopeContainsSymbolIdent,
	   ScopeNumberOfEntries, ClosedScopeNumberOfEntries,
	   EnclosingClosedScope, ReturnScopeLevel, GlobalScope,
	   EnterAutoImportSymbol, ScoStackEmpty, ScopeStats, DumpScopes,
	   ClosedScope

    const *GlobalScope := 1

    procedure PushNewScope

    procedure PushCopyScope

    procedure PushScope (scope: ScopeIndex)

    procedure CloseScope

    procedure SaveScope

    procedure ScoEnterSymbol (ident: IdentifierIndex,
			       kind: SymbolKinds,
			     symbol: SymbolIndex)

    procedure EnterAutoImportSymbol (ident: IdentifierIndex,
				      kind: SymbolKinds,
				    symbol: SymbolIndex)

    procedure ReplaceCountSymbol (entry: int,
				  ident: IdentifierIndex,
				   kind: SymbolKinds,
				 symbol: SymbolIndex)

    procedure PopScope

    procedure LookupSymbol (ident: IdentifierIndex, sc: int)

    procedure LookupLocalSymbol (ident: IdentifierIndex)

    procedure LookupEnclosingLocalSymbol (ident: IdentifierIndex)

    procedure LookupEnclosingEnclosingLocalSymbol (ident: IdentifierIndex)

    procedure LookupCountClosedSymbol (entry: int)

    procedure LookupCountSymbol (entry: int)

    procedure MergeScopes

    procedure StripScope

    procedure ScopeStats

    procedure DumpScopes

    function ReturnScopeLevel : 0..maxScopeLevel

    function EnclosingClosedScope : int          

    function ScopeContainsSymbol (symbol: SymbolIndex) : boolean

    function ScopeContainsSymbolIdent (id: IdentifierIndex) : boolean

    function ScopeNumberOfEntries : int

    function ClosedScopeNumberOfEntries : int

    function ScopeSymbolIdent : IdentifierIndex

    function ScopeSymbolKind : SymbolKinds

    function ScopeSymbolIndex : SymbolIndex

    function SavedScopeIndex : int

    function ScoStackEmpty : boolean

    function ClosedScope : int
end Scope
