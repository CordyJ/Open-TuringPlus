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

module Includer
    import (var nextChar, var includeFileName, tracing, traceFile,
	     var lineNumber, var nextTokenText, var nextTokenTextLen, fetcharg,
	     var nextToken, var nextTokenValue, Error, var newSourceFile,
	     var scannerFileName, InputTokens, TokenValue, maxstr, dotOption,
	     var savedToken, var  savedNextToken, var savedNextTokenText,
	     var savedNextTokenTextLen, var savedNextTokenValue,
	     var Macro, var PreProcessor, var inputChar)
    export (EnterDirectory, GetNextChar, PushIncludeFile, PopIncludeFile,
	     IncludeDepth, EnterAlternate, IsAlternate, SwitchToAlternate,
	     EnterParent, EnterChild, ExitParent, ExitChild, ChildMatchesParent,
	     SetOriginalFile, IsOriginalFile, ChildThatCalledMe,
	     IsParent, ChildName, IsCompilationUnit, EnterMacro,
	     MarkModuleStub, IsMarkedStub, MarkedStubIdent)

    % The source file includer mechanism 

    const *lineBufferSize := 4096
    var nextLine: char(lineBufferSize)
    var nextLineLength: int := 0
    var nextCharIndex: 1 .. lineBufferSize+1 := 1
    var insideMacro := false

    const mainSourceFile := 1
    var currentSourceFile: int

    type IncludeStackEntry :
	record
	    fileNumber:		int
	    fileIdent:		string
	    fileLineNumber:	nat
	    fileNextChar:	char
	    fileNextLine: 	char(lineBufferSize)
	    fileNextLineLength:	0 .. lineBufferSize
	    fileNextCharIndex:	1 .. lineBufferSize+1
	    fileInsideMacro:	boolean

	    /* for separate compilation */
	    iNextToken:		InputTokens
	    iNextTokenText:	char(maxstr+1)
	    iNextTokenTextLen:	0..maxstr+1
	    iNextTokenValue:	TokenValue
	    isParent:		boolean
	    alternate:		boolean
	end record

    var includeStack: 	array 0..maxIncludeDepth of IncludeStackEntry
    var includeTop: 	0 .. maxIncludeDepth := 0

    var includeDir:	array 1..maxIncludeDirectories of string
    var includeDirTop:	0..maxIncludeDirectories := 0

    /* sunpro interface */
    var sunproDependenciesFile : int := 0

    /*
     * compilationStack contains pointers into the includeStack, to mark where
     * the top of each compilation unit is
     */
    var compilationStack:	array 1..maxIncludeDepth of 0 .. maxIncludeDepth
    var compilationTop:		0..maxIncludeDepth := 0

    var isParent := false


    var markedModuleStubs : array 1..maxModuleStubs of
	record
	    name:	string
	    ident:	int
	end record

    var markedModuleStubTop : 0..maxModuleStubs := 0


    procedure EnterDirectory (dir : string)
	if includeDirTop = maxIncludeDirectories then
	    Error (eTooManyIncludeDirs)
	end if

	includeDirTop += 1

	includeDir(includeDirTop) := dir + "/"
#if DEBUG then
	if tracing then
	    put : traceFile, "Include Enter Directory = ", dir
	end if
#end if
    end EnterDirectory


    procedure EnterMacro
	insideMacro := true
	Macro.GetNextChar
    end EnterMacro


    procedure GetNextChar
	if nextChar not= endOfFile then
	    if nextChar = '\n' then
		lineNumber += 1
	    end if

	    if insideMacro then
		Macro.GetNextChar
		if nextChar = endOfFile then
		    insideMacro := false
		else
		    return
		end if
	    end if

	    loop
		if nextCharIndex > nextLineLength then
		    read : currentSourceFile,
			    nextLine : lineBufferSize : nextLineLength
		    if nextLineLength = 0 then
			nextChar := endOfFile
			return
		    end if
		    nextCharIndex := 1
		end if
		loop
		    nextChar := nextLine(nextCharIndex)
		    nextCharIndex += 1
		    if nextChar not= endOfFile then
			return
		    end if
		    exit when nextCharIndex > nextLineLength
		end loop
	    end loop
	end if
    end GetNextChar


    function FindLastSlash (s : string) : int
	if index(s, "/") = 0 then
	    result 0
	else
	    var i := index(s, "/")
	    loop
		const temp := s(i+1..*)

		exit when index(temp, "/") = 0
		i += index(temp, "/")
	    end loop

	    result i
	end if
    end FindLastSlash


    /* return a full path name */
    function FullPath (source, path : string) : string
#if PC then
	if (path not= "" and path(1) = "/") or
	    (length(path) >= 3 and path(2) = ":" and path(3) = "/") then
#else
	if path not= "" and path(1) = "/" then
#end if
	    /* an absolute path */
	    result path
	else
	    /* it is a relative path */
	    const lastSlash := FindLastSlash(source)

	    if lastSlash not= 0 then
		/* there was a path component in the last include */
		result source(1..lastSlash) + path
	    else
		/* a file in the current directory */
		result path
	    end if
	end if
    end FullPath

    procedure AssignNextToken (s : string)
	nextTokenTextLen := length(s)
	for i : 1..nextTokenTextLen
	    nextTokenText(i) := s(i)
	end for
    end AssignNextToken

    procedure PushIncludeFile (useName : boolean, name : string)
	if includeTop < maxIncludeDepth then
	    if includeTop = 0 then
		/* Start with main source file */
		AssignNextToken (fetcharg(mainSourceFile))
	    else
		/* Save state of old file */
		includeStack(includeTop).fileLineNumber := lineNumber
		includeStack(includeTop).fileNextChar := nextChar
		includeStack(includeTop).fileNextLine := nextLine
		includeStack(includeTop).fileNextLineLength := nextLineLength
		includeStack(includeTop).fileNextCharIndex := nextCharIndex
		includeStack(includeTop).fileInsideMacro := insideMacro
		includeStack(includeTop).iNextToken := nextToken
		includeStack(includeTop).iNextTokenValue := nextTokenValue
		includeStack(includeTop).iNextTokenText := nextTokenText
		includeStack(includeTop).iNextTokenTextLen := nextTokenTextLen
		includeStack(includeTop).isParent := isParent
		isParent := false
	    end if

	    if useName then
		AssignNextToken (name)
		newSourceFile := true
	    end if

	    /*
	     * figure out the name of the source file:
	     * if it is not an absolute path, start at the current
	     * include file directory, and add the path to the current
	     * relative path.
	     * Exception:
	     *	   if dotOption is on, and this is the SECOND include file,
	     *	   then oldpath = ""
	     */

	    if nextTokenTextLen > 0 and nextTokenText(1) = '%' then
		/* Library include file */
		for i : 1 .. includeDirTop
		    includeFileName := includeDir(i) +
			    nextTokenText(2..nextTokenTextLen)
		    open : currentSourceFile, includeFileName, read
		    exit when currentSourceFile not= 0
		end for
		if currentSourceFile = 0 then
		    Error (eCannotFindIncludeFile)
		end if
	    else
		if dotOption and includeTop = 1 then
		    includeFileName := nextTokenText(1..nextTokenTextLen)
		else
		    includeFileName := FullPath(
			    includeStack(includeTop).fileIdent,
			    nextTokenText(1..nextTokenTextLen))
		end if
		open : currentSourceFile, includeFileName, read
		if currentSourceFile = 0 then
		    Error (eCannotOpenFileForInput)
		end if
	    end if

	    if compilationTop = 1 and includeTop not= 0 and
		    sunproDependenciesFile not= 0 then
		put :sunproDependenciesFile, " ", includeFileName ..
	    end if

	    includeTop += 1
	    includeStack(includeTop).fileNumber := currentSourceFile
	    includeStack(includeTop).fileIdent := includeFileName
	    includeStack(includeTop).alternate := false

	    scannerFileName := includeFileName
	    lineNumber := 0
	    inputChar := '\n'
	    nextChar := '\n'
	    nextLineLength := 0
	    nextCharIndex := 1
	    insideMacro := false
	    GetNextChar
	else
	    Error (eIncludesTooDeep)
	end if
	Macro.PushFile
	PreProcessor.PushFile
    end PushIncludeFile


    procedure PopIncludeFile (restoreToken, ignorePreprocErrors : boolean)
	assert (includeTop > 0)
	close (currentSourceFile)
	includeTop -= 1

	if includeTop > 0 then
	    currentSourceFile := includeStack(includeTop).fileNumber
	    scannerFileName := includeStack(includeTop).fileIdent
	    lineNumber := includeStack(includeTop).fileLineNumber
	    nextChar := includeStack(includeTop).fileNextChar
	    nextLine := includeStack(includeTop).fileNextLine
	    nextLineLength := includeStack(includeTop).fileNextLineLength
	    nextCharIndex := includeStack(includeTop).fileNextCharIndex
	    insideMacro := includeStack(includeTop).fileInsideMacro
	    isParent := includeStack(includeTop).isParent

	    if restoreToken then
		savedNextToken := includeStack(includeTop).iNextToken
		savedNextTokenValue := includeStack(includeTop).iNextTokenValue
		savedNextTokenText := includeStack(includeTop).iNextTokenText
		savedNextTokenTextLen :=
			includeStack(includeTop).iNextTokenTextLen
		newSourceFile := true
		savedToken := true
	    end if
	else
	    assert includeTop = 0
	    if sunproDependenciesFile not= 0 then
		put :sunproDependenciesFile, ""
		close :sunproDependenciesFile
	    end if
	end if
	Macro.PopFile
	PreProcessor.PopFile (ignorePreprocErrors)
    end PopIncludeFile


    function IncludeDepth : int
	result includeTop
    end IncludeDepth


    procedure EnterAlternate (name:string)
	PushIncludeFile(true, name)
	includeStack(includeTop).alternate := true
	compilationTop += 1
	compilationStack(compilationTop) := includeTop
	isParent := false
    end EnterAlternate


    function IsAlternate : boolean
	result includeStack(compilationStack(compilationTop)).alternate
    end IsAlternate


    procedure SwitchToAlternate
	assert compilationTop > 1
	loop
	    exit when includeTop = compilationStack(compilationTop)
	    PopIncludeFile(false, true)
	end loop

	assert includeStack(compilationStack(compilationTop)).alternate
	PopIncludeFile(true, true)
	compilationTop -= 1
    end SwitchToAlternate


    procedure EnterParent (name: string)
	PushIncludeFile(true, name)
	compilationTop += 1
	compilationStack(compilationTop) := includeTop
	includeStack(includeTop).isParent := true
	isParent := true
    end EnterParent


    procedure ExitParent
	assert compilationTop > 1
	loop
	    exit when includeTop = compilationStack(compilationTop)
	    PopIncludeFile(false, true)
	end loop

	PopIncludeFile(true, true)
	compilationTop -= 1
    end ExitParent


    procedure EnterChild (name:string)
	PushIncludeFile(true, name)
	compilationTop += 1
	compilationStack(compilationTop) := includeTop
	isParent := false
    end EnterChild


    procedure ExitChild
	assert compilationTop > 1
	loop
	    exit when includeTop = compilationStack(compilationTop)
	    PopIncludeFile(false, true)
	end loop

	PopIncludeFile(true, true)
	compilationTop -= 1
    end ExitChild


    child "files.st"

    function ChildMatchesParent (name:string) : boolean
	/* parent is one down, child on top */
	assert compilationTop >= 2

	const fullname :=
	    FullPath(includeStack(compilationStack(compilationTop)).fileIdent,
		name)

	bind register n2 to
	    includeStack(compilationStack(compilationTop-1)).fileIdent

	if SameFile(fullname, n2) then
	    result true
	end if

	const l : int2 := length(fullname)

	if l > 3 and fullname(l-2..*) = ".bd" then
	    const l2 : int2 := length(n2)
	    if l2 > 3 and n2(l2-2..*) = ".st" then
		result SameFile(fullname(1..l-2) + "st", n2)
	    end if
	elsif l > 4 and fullname(l-3..*) = ".bd+" then
	    const l2 : int2 := length(n2)
	    if l2 > 4 and n2(l2-3..*) = ".st+" then
		result SameFile(fullname(1..l-3) + "st+", n2)
	    end if
	end if

	result false
    end ChildMatchesParent


    procedure SetOriginalFile
	compilationTop := 1
	compilationStack(compilationTop) := includeTop
    end SetOriginalFile


    function IsCompilationUnit : boolean
	assert compilationTop > 0
	result compilationStack(compilationTop) = includeTop
    end IsCompilationUnit


    function IsOriginalFile : boolean
	result (compilationTop = 1 or
		(compilationTop = 2 and
		 (includeStack(compilationStack(2)).alternate)))
    end IsOriginalFile


    function IsParent : boolean
	result isParent
    end IsParent


    function ChildThatCalledMe (name : string) : boolean
	/* parent is on top */
	assert compilationTop >= 1

	if compilationTop = 1 or
	    (compilationTop = 2 and
	     (includeStack(compilationStack(2)).alternate)) then
	    result false
	end if

	/* parent is on top, a child on one down */
	result SameFile(
	    FullPath(includeStack(compilationStack(compilationTop)).fileIdent,
		     name),
	    includeStack(compilationStack(compilationTop-1)).fileIdent)
    end ChildThatCalledMe

    function ChildName : string
	result includeStack(compilationStack(compilationTop-1)).fileIdent
    end ChildName


    procedure MarkModuleStub (value : int)
	if markedModuleStubTop < maxModuleStubs then
	    markedModuleStubTop += 1
	    markedModuleStubs(markedModuleStubTop).name :=
		includeStack(compilationStack(compilationTop)).fileIdent
	    markedModuleStubs(markedModuleStubTop).ident := value
	else
	    Error(eTooManyModuleStubs)
	end if
    end MarkModuleStub


    function IsMarkedStub : boolean
	assert compilationTop > 0

	for i : 1..markedModuleStubTop
	    if SameFile(markedModuleStubs(i).name,
		includeStack(compilationStack(compilationTop)).fileIdent) then
		    result true
	    end if
	end for
	result false
    end IsMarkedStub


    function MarkedStubIdent : int
	assert compilationTop > 0

	for i : 1..markedModuleStubTop
	    if SameFile(markedModuleStubs(i).name,
		includeStack(compilationStack(compilationTop)).fileIdent) then
		    result markedModuleStubs(i).ident
	    end if
	end for
    end MarkedStubIdent


    #if not CMS then
	procedure InitializeSunPro
	    external function getenv (name : string) : addressint
	    const sdfile : addressint := getenv ("SUNPRO_DEPENDENCIES")

	    if sdfile not= 0 then
		const name := string@(sdfile)
		const blank := index (name, " ")

		open :sunproDependenciesFile, name(1..blank-1), put, seek, mod

		if sunproDependenciesFile not= 0 then
		    seek :sunproDependenciesFile, *
		    put :sunproDependenciesFile, name(blank+1..*), ":" ..
		end if
	    end if
	end InitializeSunPro
    #end if


    /* initially */
    includeStack(0).fileIdent := ""

    /* handle the sunpro dependencies, if around */
    #if not CMS then
	InitializeSunPro
    #end if
end Includer
