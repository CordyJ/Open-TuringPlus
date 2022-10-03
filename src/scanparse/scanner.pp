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

module PreProcessor
    import (Error, tracing, traceFile)
    export (PushLevel, PopLevel, DoAnd, DoNot, DoOr, PushValue,
	    DoIf, DoElsIf, DoElse, DisableInput, PushFile, PopFile,
	    Finally)

    % The  preprocessor mechanism 

    type PreprocFile :
	record
	    level:		int2
	    xdisableInput:	array 0..NestingDepth of boolean
	    alreadyDefined:	array 1..NestingDepth of boolean
	    foundElse:		array 1..NestingDepth of boolean
	end record

    var preprocData : array 1..maxIncludeDepth of PreprocFile

    var top : 0..maxIncludeDepth := 0
    var disableInput := false

    var expnStack : array 1..PreprocessorExpnDepth of boolean
    var expnTop : 0..PreprocessorExpnDepth := 0


    procedure PushFile
	top += 1

	preprocData(top).level := 0
	preprocData(top).xdisableInput(0) := disableInput
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Push File"
	end if
#end if
    end PushFile


    procedure PopFile (ignoreErrors : boolean)
	assert top > 0

	if preprocData(top).level > 0 and not ignoreErrors then
	    Error (eTooFewEndifs)
	end if

	top -= 1
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Pop File"
	end if
#end if
    end PopFile


    procedure PushLevel
	assert top > 0
	bind var p to preprocData(top)

	if p.level = NestingDepth then
	    Error (eNestedIfs)
	end if

	% remember the status of the last level
	p.xdisableInput(p.level) := disableInput

	p.level += 1
	p.alreadyDefined(p.level) := false
	p.foundElse(p.level) := false
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Push Level"
	end if
#end if
    end PushLevel


    procedure PopLevel
	assert top > 0
	bind var p to preprocData(top)

	if p.level > 0 then

	    p.level -= 1
	    disableInput := p.xdisableInput(p.level)
#if DEBUG then
	    if tracing then
		put : traceFile, "Preprocessor Pop Level = " ..
		if disableInput then
		    put : traceFile, "disabled"
		else
		    put : traceFile, "not disabled"
		end if
	    end if
#end if
	end if
    end PopLevel


    procedure PushValue (val : boolean)
	if expnTop = PreprocessorExpnDepth then
	    Error (eExpnStackOverflow)
	end if
	expnTop += 1
	expnStack(expnTop) := val
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Push Value (" ..
	    if val then
		put : traceFile, "true)"
	    else
		put : traceFile, "false)"
	    end if
	end if
#end if
    end PushValue


    procedure DoAnd
	assert expnTop > 1
	expnStack(expnTop-1) := expnStack(expnTop-1) and expnStack(expnTop)
	expnTop -= 1
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do And = " ..
	    if expnStack(expnTop) then
		put : traceFile, "true"
	    else
		put : traceFile, "false"
	    end if
	end if
#end if
    end DoAnd


    procedure DoOr
	assert expnTop > 1
	expnStack(expnTop-1) := expnStack(expnTop-1) or expnStack(expnTop)
	expnTop -= 1
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do Or = " ..
	    if expnStack(expnTop) then
		put : traceFile, "true"
	    else
		put : traceFile, "false"
	    end if
	end if
#end if
    end DoOr


    procedure DoNot
	assert expnTop > 0
	expnStack(expnTop) := not expnStack(expnTop)
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do Not = " ..
	    if expnStack(expnTop) then
		put : traceFile, "true"
	    else
		put : traceFile, "false"
	    end if
	end if
#end if
    end DoNot


    procedure DoIf
	assert top > 0 and preprocData(top).level > 0

	bind var p to preprocData(top)

	assert expnTop > 0
	if expnStack(expnTop) then
	    % include this code
	    p.alreadyDefined(p.level) := true
	else
	    disableInput := true
	end if
	expnTop -= 1
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do If = " ..
	    if disableInput then
		put : traceFile, "disabled"
	    else
		put : traceFile, "not disabled"
	    end if
	end if
#end if
    end DoIf


    procedure DoElsIf
	assert top > 0 and expnTop > 0

	bind var p to preprocData(top)

	if p.level = 0 then
	    Error (eElsIfWithoutIf)
	end if

	disableInput := true
	if not p.alreadyDefined(p.level) and expnStack(expnTop) then
	    p.alreadyDefined(p.level) := true
	    if not p.xdisableInput(p.level-1) then
		% include this code
		disableInput := false
	    end if
	end if
	expnTop -= 1
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do ElsIf = " ..
	    if disableInput then
		put : traceFile, "disabled"
	    else
		put : traceFile, "not disabled"
	    end if
	end if
#end if
    end DoElsIf


    procedure DoElse
	assert top > 0

	bind var p to preprocData(top)

	if p.level = 0 then
	    Error (eElseWithoutIf)
	end if

	if p.foundElse(p.level) then
	    Error (eTooManyElses)
	end if
	p.foundElse(p.level) := true

	disableInput := true
	if not p.alreadyDefined(p.level) and not p.xdisableInput(p.level-1) then
	    % include this code
	    disableInput := false
	end if
#if DEBUG then
	if tracing then
	    put : traceFile, "Preprocessor Do Else = " ..
	    if disableInput then
		put : traceFile, "disabled"
	    else
		put : traceFile, "not disabled"
	    end if
	end if
#end if
    end DoElse


    procedure Finally
	assert top = 0
	assert expnTop = 0
    end Finally

    function DisableInput : boolean
	result disableInput
    end DisableInput

end PreProcessor
