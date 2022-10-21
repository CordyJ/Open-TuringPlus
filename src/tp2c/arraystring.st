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

stub module ArrayString
    import var tNode, eNode, var Expression, var asNode, TreeDump, debugFile,
	   predtree
    export CreateStringNode, CreateArrayNode

    % Module:  Array Index and String Length
    % Date:    9 Dec. 1986
    % Author:  M. Mendell

    type SetTypeProc : procedure dummy (id : ExpressionPointer,
				       tree: TreePointer)

    type GetTypeFunc : function dummy (id : ExpressionPointer) : TreePointer

    type EnterTypeInfoProc : procedure dummy (id : ExpressionPointer)

    type EnterAttributeTypeProc : procedure dummy (id : ExpressionPointer,
					         attr : AttributeType)


    procedure CreateStringNode(var res : ArrayStringPointer,
				   str : TreePointer, kind : TypeKinds,
				   settype : SetTypeProc, needSize : boolean)

    procedure CreateArrayNode(    refVal : int,
			      var res : ArrayStringPointer,
				  arr : TreePointer,
				  settype : SetTypeProc,
				  gettype : GetTypeFunc,
				  entertypeinfo: EnterTypeInfoProc,
				  enterAttribute: EnterAttributeTypeProc)

end ArrayString
