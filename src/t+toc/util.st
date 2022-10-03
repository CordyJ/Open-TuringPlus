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

parent "t+toc.t"

stub module Utility
    import var eNode, var Types, asNode, var Expression, var tNode,
	   var Predefined, var CTypes, var predtree, var Tree,
	   unChecked

    export ~.VariableId, ~.VariableType, ~.ExpnType, ~.ManifestExpression,
	   ~.InRange, ~.ExpnTypeTree, ~.SimpleExpression

    % Utility routines - get ids & types, is manifest, etc
 
    function VariableId (expn : ExpressionPointer) : ExpressionPointer

    procedure VariableType (expn : ExpressionPointer, var res : TreePointer)

    function ExpnType (expn : ExpressionPointer) : TypeKinds

    procedure ExpnTypeTree (expn : ExpressionPointer, var res : TreePointer)

    function ManifestExpression (e : ExpressionPointer) : boolean

    procedure InRange(expn, high : ExpressionPointer,
		       low : int4, var res : ExpressionPointer,
		       subtractLower: boolean, abort : int)

    function SimpleExpression (e : ExpressionPointer) : boolean

end Utility
