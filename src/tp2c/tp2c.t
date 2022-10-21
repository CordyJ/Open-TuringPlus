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

% This is the C code generator pass of the Turing Plus compiler

grant var Token, var Expression, var Tree, var Types, var asNode,
    var Walker, debugLevel, debugFile, var Identifier, var eNode,
    var tNode, var strings, sysexit, maxint, maxstr, var Transform,
    var TreeDump, var Predefined, var CTypes, var currentLineNumber, 
    var currentFileNumber, var LineInfo, var ArrayString, var TreeCopy,
    Error, ExpnType, VariableId, var CTypeEnterSize, InRange,
    ManifestExpression, VariableType, varTypeTree, treeStackSize,
    var macdepType, var macdepAddressSize, var predefNames, var includeFile,
    ExpnTypeTree, var predtree, var prefixIdentifiers, var maxIdentSeen,
    var fixupExpressionAssignment, disableUnderflowChecking,
    var disableUnderflowCheckingString, var macdepStackSize,
    timeSlice, var unChecked, var macdepConditionSize, SimpleExpression,
    lineNumbering, var prefixRecordUnion, originalUnChecked, overrideInclude,
    var macdepEscapeOrd, var macdepDeleteOrd, var unsignedLiteralTerminator

var debugLevel := 0	% if > 0, then generate debug output
var debugFile := 0	% debugging file (initialize to std error)
var disableUnderflowChecking := false
var timeSlice := false	% Produce timeslice calls?
var unChecked := false	% Checking currently disabled?
var originalUnChecked := false	% Checking (-O) disabled?
var lineNumbering := true% Do line numbering code?
var prefixRecordUnion := false	% don't prefix record/union fields
var maxIdentSeen := 0

const *idMapFile := 3	% file mapping symbol indicies to id names
const *idHashFile := 4	% file mapping of id names
const *macdepFile := 5	% file giving machine dependant information
const firstOption := 6
var overrideInclude := "" % another include file after the standard one

#if BIG then
    const *maxScannerIdents := 4099
#else
    const *maxScannerIdents := 1021
#end if
var treeStackSize := 1000000

var currentLineNumber : nat2 := 0
var currentFileNumber : nat2 := 0

include "walker.def.t"

include "%system"
include "%limits"
include "%exceptions"

include "tp2c.glb"	% global type definitions
include "predefined.def"% definitions for the predefined library routines
include "macdep.def"	% definitions for machine dependant const/vars


var TreeDump : procedure dummy (t : TreePointer, indent, stream : int)
var TreeCopy : procedure dummy (t : TreePointer, var resultT : TreePointer)
var CTypeEnterSize :
    procedure dummy (var e : ExpressionType, t : TreePointer, pack : boolean)
var varTypeTree : procedure dummy (expn : ExpressionPointer,
				var res : TreePointer)
var fixupExpressionAssignment : procedure dummy (ep : ExpressionPointer,
						 t  : TreePointer)

child "lineinfo.st"	% manage the line and file number information
child "error.st"	% error message printing routine
child "token.st"	% input tokens to compound kind and back again.
child "predefined.st"	% mapper to predefined routine names
child "identifier.st"	% hold the names of identifiers
child "expn.st"		% expression tree constructor and manip. routines
child "arraystring.st"	% access to array indicies/strings sizes
child "types.st"	% id types entry and lookup routines
child "macdep.st"	% Machine Dependancies module
child "ctype.st"	% Type output module

% Check the options

const debugFileName := "ttoc.debug"

for i : firstOption .. nargs
    const argstring := fetcharg (i)
    const arglen := length (argstring)

    if arglen >= 2 and argstring(1) = "-" then
	case type (char(3), argstring)(2) of
	    label 'd':
		if arglen = 2 then
		    debugLevel := 1
		else
		    debugLevel := strint (argstring (3 .. *))
		end if
		open : debugFile, debugFileName, put

	    label 'w':
		treeStackSize := strint (argstring (3 .. *))

	    label 'u':
		disableUnderflowChecking := true

	    label 's':
		timeSlice := true

	    label 'n':
		lineNumbering := false

	    label 'c':
		unChecked := true
		originalUnChecked := true

	    label 'M':
		overrideInclude := argstring(3..*)
	    
	    label :
		put :0, "Unknown option \"", argstring, "\" ignored."
	end case
    else
	put :0, "Unknown option \"", argstring, "\" ignored."
    end if
end for

child "tree.st"		% parse tree constructor and manipulator routines
child "util.st"		% Give ids, types of variables, expression
child "transform.st"	% transformation of tree
child "walker.st"	% Parse the input stream into a tree.
child "output.st"	% output the tree as a C program.

const *inFile := 1	% input stream from semantic pass 2
const *outFile := 2	% output text file

var parseTree : TreePointer

% main program : init, take options, open files, input parse tree, transform the tree
% into a form C will like, output the tree as a C program

varTypeTree := VariableType
Types.SetKindProc(CTypes.TypeKind)
Walker.Walk (parseTree, inFile)
Identifier.ReadMapNames
Expression.SetMaximumIdentifier(maxIdentSeen)
Transform.TransformProgram(parseTree)
if debugLevel > 0 then
    put : debugFile, "======= PARSE TREE AFTER TRANSFORM ========"
    Tree.Dump (parseTree, 0, debugFile)
    Types.Dump(debugFile)
end if
Output.Program (parseTree, outFile)
