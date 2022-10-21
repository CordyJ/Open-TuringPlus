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

stub module CTypes
    import var Token, var tNode, var Expression, var eNode,
	   var Types, debugFile, TreeDump, Error, var CTypeEnterSize,
	   var Identifier, macdepType, macdepAddressSize, macdepConditionSize

    export Output, NonScalar, TypeKind, OutputStructure, EnterTypeSize

    % Turing Plus to C Translator
    % By:    Mark Mendell
    % Date:  31 Oct 1986

    procedure Output (t, ids : TreePointer, stream, indent : int)

    procedure OutputStructure ( t, ids : TreePointer, stream, indent : int)

    % These get around forward subprograms!
    procedure OutputType (t, ids : TreePointer, stream, indent : int,
			  pack, outputIndent, suppressStar : boolean)

    procedure OutputStructureType (t, ids : TreePointer, stream, indent : int,
				   pack : boolean, outputIndent: boolean)

    procedure OutputSimpleType (t, ids : TreePointer, stream, indent : int,
				outputIndent: boolean)

    procedure OutputComplexType (t, ids: TreePointer, stream, indent : int,
				 pack, outputIndent, suppressStar: boolean)

    procedure OutputRecordFields (t : TreePointer, stream, indent : int,
				pack : boolean, outputIndent: boolean)
    
    procedure OutputUnionBody (t : TreePointer, stream, indent : int,
			    pack, outputIndent : boolean)

    function NonScalar (t : TreePointer) : boolean

    function TypeKind (t : TreePointer) : TypeKinds

    procedure EnterTypeSize (var e : ExpressionType, t : TreePointer,
			     pack : boolean)

end CTypes
