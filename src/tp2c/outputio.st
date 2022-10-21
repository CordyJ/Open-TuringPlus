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

stub module OutputIo
    import outFile, var Token, var eNode, tNode, TokenToName, 
	   var Expression, predefNames, OutputIndent, var Tree, var Types,
	   var CTypes, ImplicitReference, VariableType, asNode, VariableId,
	   intCast, natCast, realCast, ExpnType, macdepType,

	   /* from OutputExpression */
	   OutputExpression, OutputExpressionList, OutputReference,
	   OutputCastedExpression, OutputParameters, OutputCastedExpressionList,
	   OutputAddressExpression

    export OutputIo

    % Output an I/O statement

    procedure OutputIo (t:TreePointer, indent : int)

end OutputIo
