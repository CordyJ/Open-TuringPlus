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

stub module Output
    import var Expression, var Tree, var Token, var tNode, var eNode, strings,
	   predefNames, var Types, var CTypes, asNode, ExpnType, InRange,
	   var Identifier, VariableType, Error, var Transform, VariableId,
	   includeFile, macdepType, predtree, ExpnTypeTree,
	   disableUnderflowCheckingString, disableUnderflowChecking,
	   macdepAddressSize, macdepStackSize, var unChecked, timeSlice,
	   SimpleExpression, lineNumbering, var LineInfo, originalUnChecked,
	   overrideInclude

    export Program

    %   Turing Plus to C Translator
    %   Module:Output Parse Tree as C program
    %   By:    Mark Mendell
    %   Date:  29 Oct 1986

    %   This module will take the ParseTree build by the walker module and output
    %   it to the given stream. It has only one call visible externally 'Program'.
    %    
    %   Output.Program(t,s)   Outputs parse tree 't' to open stream 's'.

    procedure Program (t : TreePointer, s : int)

end Output
