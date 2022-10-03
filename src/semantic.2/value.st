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

stub module Value
    import Error, statistics, maxstr, maxint, maxnat
    export PushValue, ReplaceValue, PushValueDescriptor, PushValueIndex,
	AddValues, SubtractValues, MultiplyValues, DivValues, ModValues, 
	NegateValue, ChrValue, OrdValue, GreaterValues, LessValues,
	EqualValues, NotValue, PopValue,
	LeftValueIndex, ValStackEmpty, LeftValueLower, InRange, 
	InFlexRange, LegalSetRange, NonNegative, StringConcatenate,
	ConvertIntToReal, ConvertIntToNat, ValStats, ValueIndexx,
	LeftValueKind, SameValues, SwapValues, ValueValue, CompileTimeValue,
	SetAll, BuildSet, LegalSubstringValues, TopValue, TopValueLength,
	PushString, ValGetString, NumberOfElements, DumpValues,
	ValueIndexKind, ValueDescriptor, ValueKind, LegalSubstringValue,
	LogicalAndValues, LogicalOrValues, LogicalXorValues,
	LogicalShiftRightValues, LogicalShiftLeftValues, IllegalIntNatRange,
	SetIntersection, SetDifference, SetUnion, SetXor, ConvertCharToString

    %  Module:	Semantic Pass 2 Value Mechanism V1.00
    % 	Author:	M. Mendell & Stephen Perelgut
    % 	Date:	13 Feb 1984

#if DEBUG then
    var strings : collection of char(maxstr+1)
#else
    var strings : unchecked collection of char(maxstr+1)
#end if

    type *StringPtr : pointer to strings

    type *SetType : set of 0..maxSetElement

    type *ValueDescriptor :
	union kind : ValueKinds of
	    label vInteger:
		negative:	boolean
		intval:		nat4
	    label vReal, vString, vChar:
		stringlen:	int
		stringval:	StringPtr
	    label vSet:
		smallset:	boolean
		setval:		SetType
	    label vNil:
		collSym:	SymbolIndex
	    label :
	end union

    procedure PushValue (kind: ValueKinds, neg: boolean, val: nat4)

    procedure PushSet (small: boolean, val: SetType)

    procedure PushString (kind: ValueKinds, slen : int, stringVal: char(*))

    procedure ReplaceValue (kind: ValueKinds, neg: boolean, val: nat4)

    procedure PushValueDescriptor (value: ValueDescriptor)

    procedure PushValueIndex (vindex: ValueIndex)

    procedure PopValue

    procedure SwapValues

    procedure NegateValue

    procedure AddValues

    procedure SubtractValues

    procedure MultiplyValues

    procedure DivValues

    procedure ModValues

    procedure ChrValue

    procedure OrdValue

    procedure StringConcatenate

    procedure ConvertIntToReal

    procedure ConvertIntToNat

    procedure ConvertCharToString

    procedure SetAll (value1, value2 : ValueIndex)

    procedure BuildSet (value1, value2 : ValueIndex, count : int)

    procedure GreaterValues

    procedure LessValues

    procedure EqualValues

    procedure NotValue

    procedure LogicalAndValues

    procedure LogicalOrValues

    procedure LogicalXorValues

    procedure LogicalShiftRightValues

    procedure LogicalShiftLeftValues

    procedure SetIntersection

    procedure SetDifference

    procedure SetUnion

    procedure SetXor

    function ValStackEmpty : boolean

    function TopValue : int4

    function TopValueLength : int

    function LeftValueLower : boolean

    function NonNegative : boolean

    function InRange (lowerIndex, upperIndex: ValueIndex) : boolean

    function InFlexRange (lowerIndex: ValueIndex) : boolean

    function ValueIndexKind (v : ValueIndex) : ValueKinds

    function ValueKind : ValueKinds

    function LegalSetRange : boolean

    function IllegalIntNatRange : boolean

    function LegalSubstringValues : boolean

    function LegalSubstringValue : boolean

    function LeftValueKind : ValueKinds

    function SameValues : boolean

    procedure ValueValue (var v : ValueDescriptor)

    procedure ValueIndexx (var vindex: ValueIndex)

    procedure LeftValueIndex (var vindex: ValueIndex)

    function NumberOfElements (lowerIndex, upperIndex: ValueIndex) : int

    function CompileTimeValue (v : ValueIndex) : boolean

    procedure ValStats

    function ValGetString (s : StringPtr) : char(maxstr+1)

    procedure DumpValues
end Value
