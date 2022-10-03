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

stub module Tree
    import var Expression, var Token, var tNode, eNode, strings,
	   var TreeDump, var Types, var CTypes, Error, currentLineNumber,
	   var TreeCopy, currentFileNumber, treeStackSize

    export StartNewSubtree, EndSubtree, Copy, CopyNode, 
	   EnterSimpleLeaf, EnterExpression, EnterCopy, SwapTopTwoTrees, End,
	   Dump, DumpTop, NewNode, IsLeafNode, IsExprNode, Free, Init, 
	   AssertStackIsEmpty

    %   Turing Plus to C translator
    %   Module:Parse Tree Construction & Manipulation Module 
    %   By:    Mark Mendell
    %   Date:  28 Oct 1986

    procedure StartNewSubtree (lab : int)

    procedure EnterExpression (e : ExpressionPointer)

    procedure EnterSimpleLeaf (l : int)

    procedure EnterCopy (t : TreePointer)

    procedure Copy (t1 : TreePointer, var t2 : TreePointer)

    procedure CopyNode (t1 : TreePointer, var t2 : TreePointer)

    procedure SwapTopTwoTrees

    procedure EndSubtree

    procedure End (var t : TreePointer)

    procedure AssertStackIsEmpty (s : int)

    function IsLeafNode (t : TreePointer) : boolean

    function IsExprNode (t:TreePointer) : boolean

    procedure Dump (t : TreePointer, indent, stream : int)

    procedure Free (t : TreePointer)

    procedure NewNode (var t : TreePointer, n : int)

    procedure DumpTop (stream : int)

    procedure Init

end Tree
