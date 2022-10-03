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

stub module OutputExpn
    import outFile, var Token, var eNode, var tNode, TokenToName,
	   var Expression, var Types, asNode, ImplicitReference, ExpnType,
	   InRange, var CTypes, var Tree, VariableType, VariableId,
	   predefNames, intCast, natCast, realCast, macdepType, predtree,
	   ExpnTypeTree, macdepStackSize, var currentRangecheck,
	   currentMonitorVariable, needSaveLineFile, OutputLineNumber,
	   strings

    export ~.OutputExpression, ~.OutputExpressionList, ~.OutputFunctionId,
	   ~.OutputReference, ~.OutputCastedExpression, OutputParameters,
	   ~.OutputCastedExpressionList, ~.OutputAddressExpression,
	   ~.OutputPossibleAddressintExpression

    % OutputExpression Module -- output expressions, and some helper function

    procedure OutputExpression (e : ExpressionPointer, outputParen : boolean)

    procedure OutputReference (e : ExpressionPointer)

    procedure OutputParameters (func, parameters : ExpressionPointer)

    procedure OutputFunctionId (id : ExpressionPointer)

    procedure OutputCastedExpression (e : ExpressionPointer)

    procedure OutputExpressionList (n : ExpressionPointer)

    procedure OutputCastedExpressionList (n : ExpressionPointer)

    procedure OutputAddressExpression (param : ExpressionPointer)

    procedure OutputPossibleAddressintExpression (expn : ExpressionPointer,
						  withParen : boolean)

end OutputExpn
