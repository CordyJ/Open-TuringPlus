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

parent "output.bd"

stub module Misc
    import outFile, var Token, var eNode, var tNode, var Expression,
	   var Types, asNode, ExpnType, InRange, var CTypes, predefNames,
	   inRoutine, VariableId, macdepAddressSize, var needSetFileTable,
	   lineNumbering, var needLoopTimeSlice, var needStackCheck,
	   var needSaveLineFile

    export ~.TokenToName, ~.OutputIndent, ~.OutputType, 
	   ~.OutputLineNumber, ~.ForceLineNumberAssignment, ~.ImplicitReference,
	   ~.ParameterSize

    % Misc -- some output routines put here to cut down the size of Output

    procedure OutputIndent (indent : nat)

    procedure OutputType (t : TreePointer, indent : int)

    procedure OutputLineNumber (tp : TreePointer, indent : int)

    procedure ForceLineNumberAssignment

    function TokenToName (lab : int) : string

    function ImplicitReference (expn : ExpressionPointer) : boolean

    function ParameterSize (eFunc, eParams : ExpressionPointer) : int

end Misc
