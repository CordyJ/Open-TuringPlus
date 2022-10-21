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

% This is the "tpc" command which executes the Turing Plus compiler

grant error, flushstreams, system, sysexit, cleanup

include "%system"
include "%limits"

const *version := "Turing+ v6.2 (27.9.22) (c) 1986 University of Toronto, (c) 2022 Queen's University at Kingston"

const *usage := "tpc [-help] [other options] file.t [ file ... ]"
const *files := "Only '.t', '.t+', '.ch', '.ch+', '.st', '.st+', '.bd', '.bd+', '.s', '.c', '.o', '.a' files allowed"

% The Turing Plus Compiler Library Directory 
const DefaultLibrary := "/usr/local/lib/tplus"
var Library := DefaultLibrary

% The Turing Plus Compiler Include Directory 
const DefaultInclude := "/usr/local/include/tplus"
var Include := DefaultInclude

% The target machine type 
#if UNIX32 then
	const *DefaultMachine : string := "UNIX32"
	const *DefaultArch : string := "-m32"
#else % UNIX64 
	const *DefaultMachine : string := "UNIX64"
	const *DefaultArch : string := "-m64"
#end if

var machine := DefaultMachine
var arch := DefaultArch

% Passes of the Turing Plus Compiler 
var pass	: string
const *ScanparsePass	:= "/scanparse"
const *SemanticPass1	:= "/semantic1"
const *SemanticPass2	:= "/semantic2"
const *AllocPass	:= "/alloc"

const *CoderPass	:= "/coder"
const *PreprocessorPass	:= "/cpp"
const *AssemblerPass	:= "/as"
const *OptimizerPass	:= "/optim"
const *TranslatorPass	:= "/tp2c"
const *CCompilePass	:= "/cc"
const *LinkerPass	:= "/ld"

% Link Library Files 
var Lib   : string

var verbose :=   false	% only print commands 
var Toption :=   false	% save temps 
var qOption :=   99	% number of passes to run 
var kOption :=   false	% true = do not emit checking code 
var rOption :=   false	% true = do not emit line numbering 
var Roption :=   false	% true = manifest area in text space 
var Coption :=   false	% true = run C optimizer 
var Koption :=   false	% true = emit time slicing code 
var lOption :=   0	% number of standard link libraries 
var Foption :=	 false	% true = put float results in float reg 
var Eoption :=	 false	% true = show scanner output (after preproc) 

const * maxLibs := 20
var ldLibs	: array 1..maxLibs of string % link libraries 

var tOption 	:= 0	% trace pass n 
var xArg 	: array 1..6 of string
var xArgValid	: array 1..6 of boolean :=
		    init (false, false, false, false, false, false)

var Soption 	:= false % true = output assembly code only 
var cOption 	:= false % true = output object modules only (do not link) 
var oOption 	:= false % specify output load module name 
var uOption 	:= false % true == check floating underflow name 
var aOption 	:= false % true = use C translator 
var wOption 	:= false % true = suppress warnings 
var Aoption 	:= false % true = leave translated C source around 
var dOption 	:= false % debug 
var dotOption	:= false % true == pass -. to scanparse 

% Standard file suffixes 
var asSuf	:= "s"
var ldSuf	:= "o"
var libSuf	:= "a"
var outSuf	:= "x"

% executable file suffix 
const executable := ".x"

% Error Severity Levels 
const *nonfatal := 0
const *fatal	:= 1

% Arguments to Compiler, Assembler and Linker 
var arg		:= 0

% an error has occurred 
var err := false

const *maxSources  := 100

var nSources	:= 0
var nWorkSources:= 0

var tSource 	: array 1.. maxSources of string
var tmpSource 	: array 1.. maxSources of boolean
var asSource, ldSource, ldOut	: string
var sourceFile	: int

% defines for include directory search path 
const *maxIncludes := 10
var includeDirs : array 1..maxIncludes of string
var numIncludeDirs := 0

% defines for conditional compilation 
const *maxDefines := 30
var defineArgs	: array 1.. maxDefines of string
var numDefineArgs := 0

var tArgs	: array 1.. maxSources+maxIncludes+maxDefines+8 of string
var machParms	: string(64)
var machP2	: string(64)

% macro file name 
var macroFileName : string := ""

% Work File Names 
var t1File :=	""	% scanparse token output
var idFile :=	""	% id table output
var t2File :=	""	% semantic1 token output
var d2File :=	""	% dbx support output
var t3File :=	""	% semantic2 token output
var tcFile :=	""	% translator output C source
var t4File :=	""	% alloc token output
var rtFile :=	""	% routine table output
var ruFile :=	""	% combined routine table
var alFile :=	""	% local variable declarations output
var agFile :=	""	% global variable declarations output
var d4File :=	""	% dbx support output
var cmFile :=	""	% main program assembly code output
var crFile :=	""	% routine assembly code output
var asFile :=	""	% temporary file for c2
var as2File :=	""	% temporary file for preprocessor

% File Work Buffer 
const BUFSIZE := 8192
var catbuf	: char(BUFSIZE)


procedure error (msg, data : string, severity : int)
    put : 0, "tpc: ", msg, data
    if severity = fatal then
	sysexit (10)
    end if
end error


procedure useerror
    put : 0, "Usage: ", usage
    sysexit (10)
end useerror


procedure remove (var name : string, preserve : boolean)
    if name ~= "" then
	if verbose then
	    put "rm -f ", name
	else
	    var rc := 0
	    system ("/bin/rm -f " + name, rc)
	end if
	if not preserve then
	    name := ""
	end if
    end if
end remove


procedure cleanup
    if Toption then
	return
    end if

    remove (t1File, false)
    remove (t2File, false)
    remove (d2File, false)
    remove (idFile, false)
    remove (t3File, false)
    if not Aoption then
	remove (tcFile, false)
    end if
    remove (t4File, false)
    remove (rtFile, false)
    remove (ruFile, false)
    remove (alFile, false)
    remove (agFile, false)
    remove (d4File, false)
    remove (cmFile, false)
    remove (crFile, false)
    remove (asFile, false)
    remove (as2File, false)
end cleanup


function checkedStrint (str : string) : int
    handler (i)
	result 0
    end handler
    result strint(str)
end checkedStrint


function stripath (s : string) : string
    var i := index(s, "/")
    if i = 0 then
	result s
    else
	loop
	    const temp := s(i+1..*)
	    exit when index(temp, "/") = 0
	    i += index(temp, "/")
	end loop
	result s(i+1..*)
    end if
end stripath


function stripsuf (s : string) : string
    var i := index(s, ".")
    if i = 0 then
	result s
    else
	loop
	    const temp := s(i+1..*)
	    exit when index(temp, ".") = 0
	    i += index(temp, ".")
	end loop
	result s(1..i-1)
    end if
end stripsuf


function getsuf (s : string) : string
    const t := stripath(s)

    var i := index(t, ".")

    if i = 0 then
	result ""
    else
	% find the last . 
	loop
	    const temp := t(i+1..*)
	    exit when index(temp, ".") = 0
	    i += index(temp, ".")
	end loop
	result t(i+1..*)
    end if
end getsuf


procedure maketemp (var filenm : string, proto : string)
    if Toption then
	filenm := ""
    else
	filenm := "/tmp/"
    end if
    filenm += proto + intstr(getpid, 0)
end maketemp


procedure catfiles (var outfile : string, inf1, inf2, inf3, inf4 : string)
    var infiles : array 1..4 of string

    infiles(1) := inf1
    infiles(2) := inf2
    infiles(3) := inf3
    infiles(4) := inf4

    var ofile, ifile : int

    if verbose then
	put "cat " ..
	for i : 1 .. 4
	    exit when infiles(i) = ""
	    put infiles(i), " " ..
	end for
	put "> ", outfile
	return
    end if

    % now open it for output
    open :ofile, outfile, write
    if ofile = 0 then
	error ("Unable to create ", outfile, fatal)
    end if

    for i : 1..4
	exit when infiles(i) = ""

	open :ifile, infiles(i), read
	if ifile = 0 then
	    error ("Unable to open ", infiles(i), fatal)
	end if

	loop
	    var bytesRead, bytesWritten : int
	    var status : int

	    read :ifile : status, catbuf : BUFSIZE : bytesRead
	    if status not= 0 then
		error ("Error " + intstr(status) + " reading file ",
			infiles(i), fatal)
	    end if
	    exit when bytesRead = 0

	    write :ofile : status, catbuf: bytesRead : bytesWritten
	    if status not= 0 or bytesWritten not= bytesRead then
		error ("Error " + intstr(status) + " writing file ",
			outfile, fatal)
	    end if
	    exit when eof(ifile)
	end loop
	close :ifile
    end for

    close :ofile
end catfiles


procedure help
    put "'tpc' is the compiler for Turing Plus language programs."
    put "Turing Plus source program files should be named using '.t',"
    put "'.bd' or .'ch'.  For example,\n"
    put "	example.t\n"
    put "'tpc' can then be used to compile the program so that"
    put "it can be run.  For example, the Turing Plus source program "
    put "in the file 'example.t' can be compiled using the command\n"
    put "	tpc example.t\n"
    put "which will list errors detected by the compiler on your"
    put "terminal.  If no errors are detected, the compiler will"
    put "save the executable version of the program in a file "
    put "named with '.x', for example,\n"
    put "	example.x\n"
    put "The program can then be run by typing its name as a command.\n"
    put "More details? " ..
    var ans : string

    get ans : *
    if ans not= "" and ans(1) not= 'y' then
	return
    end if

    put "\nThe tpc command syntax is:\n"
    put "	", usage
    put "\nThe program name (file) must end in '.t', '.t+', '.bd', '.bd+',"
    put "'.ch' or '.ch+' as in 'prog.t'.  The compiled, executable program"
    put "will be put in 'prog.x'."

    put "\nA Turing Plus main program can be linked to subprograms written in"
    put "other languages.  The subprogram to be linked to must be declared"
    put "as 'external', using a syntax analogous to 'forward' subprograms."
    put "The subprograms to be linked to must appear on the command"
    put "line following the 'prog.t', and must end in '.o', '.s', '.c',"
    put "or '.a'.   Up to 19 of these input files are accepted.  Each of"
    put "the other files may be an assembly source file ('.s'), an object"
    put "file ('.o'), a C file ('.c') or an object library ('.a').  "
    put "The output load module is put in 'prog.x'."

    put "\nError messages are sent to the standard output.  Disasters (such"
    put "as not finding a pass of the compiler) are logged on the diagnostic"
    put "output."
    put "\nMore details? " ..

    get ans : *
    if ans not= "" and ans(1) not= 'y' then
	return
    end if

    put "\nThe following are recognized options:\n"
    put "       -a:     Use alternate C translator to compile."
    put "       -c :    Produce object modules only (do not link)."
    put "       -h :    Help! (You are reading it)"
    put "       -k :    Do not emit run time subscript and case checking code."
    put "               Also use an unchecked library."
    put "       -lLIB : Link with the specified standard library."

    put "       -mMMM : Specify the target machine.  The default is -m", DefaultMachine, "."

    put "       -o file :  Put the output load module in the specified file."
    put "       -r :    Do not emit run time line numbering code."
    put "       -s :    Produce timing statistics about the compiler passes."
    put "       -u :    Check for floating point underflow."
    put "       -w :    Suppress warning messages."

    put "       -A :    Do not delete output ('.c' files) from alternate C translator."
    put "       -B :    Perform a static link (SunOS 4.0 only)"
    put "       -C :    Run the 'C' assembly language optimizer."
    put "       -Dsymbol :  Define the symbol for conditional compilation."
    put "       -E :    Print scanner output only (do not compile)."
    put "       -F :    Float routines return results in float register."
    put "       -Idir : Add the directory to the search path for include files."
    put "       -K :    Emit \"time-slicing\" calls for simulation kernel."
    put "       -M file: Use alternate macro file for concurrency support."
    put "       -O :    Do not emit run time line numbering and checking code."
    put "               Also use an unchecked library."
    put "       -R :    Assemble manifest constants into text area."
    put "       -S :    Produce assembly sources only (do not assemble and link)."

    put "\nCompiler maintenance option details? " ..

    get ans : *
    if ans not= "" and ans(1) not= 'y' then
	return
    end if

    put "       -. :    Pretend the file is in the current directory (for TTV)"
    put "       -# :    Print the commands used to compile without executing them."
    put "       -i dir  :  Set the standard include library to the specified directory"
    put "                  (The default is ", DefaultInclude , ")"
    put "       -qn :   Run only the first n passes of the compiler."
    put "       -tn :   Trace S/SL execution of pass n."
    put "       -xn arg :  Pass 'arg' as an extra argument to pass n."
    put "       -L dir  :  Run the compiler passes from the specified directory."
    put "                  (The default is ", DefaultLibrary , ")"
    put "       -T :    Save temporary files in the user's directory."

end help


procedure checkFetcharg (i : int, var s : string)
    if i <= nargs then
	s := fetcharg(i)
    else
	useerror
    end if
end checkFetcharg


procedure option
    const argString := fetcharg(arg)
    const argLength := length(argString)
    var stringStart := 2
    var value : boolean

    if argLength = 1 then
	return
    end if

    if argString(2) = '-' then
	value := false
	stringStart := 3
    else
	value := true
    end if

    for j : stringStart .. argLength
	const ch : char := argString(j)
	case ch of
	    label 'a' :
		aOption := value

	    label 'c' :
		cOption := true

	    label 'd':
		dOption := value

	    label 'h' :
		help
		sysexit (1)

	    label 'i' :
		arg += 1
		checkFetcharg(arg, Include)
		return

	    label 'k' :
		kOption := value

	    label 'l' :
		if lOption < maxLibs then
		    if argString(j+1..*) not= "" then
			lOption += 1
			ldLibs(lOption) := argString(j-1..*)
		    end if
		else
		    error("Too many libraries, max= "+intstr(maxLibs),
			    ".  Compiler aborted", fatal)
		end if
		return

	    label 'm':
		const name : string := argString(j+1 .. *)
	        machine := name
		if machine = "UNIX32" then
		    arch := "-m32"
		else % machine = *64 
		    arch := "-m64"
		end if
		return

	    label 'o' :
		oOption := true
		arg += 1
		checkFetcharg(arg, ldOut)
		return

	    label 'q':
		qOption := checkedStrint(argString(j+1))
		return

	    label 'r' :
		rOption := value

	    label 't':
		tOption := checkedStrint(argString(j+1))
		return

	    label 'u' :
		uOption := value

	    label 'w':
		if argString(j+1) >= '0' and argString(j+1) <= '9' then
		    % old-style coder size option - we ignore it
		    const t := checkedStrint(argString(j+1))
		    return
		else
		    wOption := value
		end if

	    label 'x':
		if length(argString) > j then
		    if argString(j+1) >= '0' and argString(j+1) <= '6' then
			const t := checkedStrint(argString(j+1))
			arg += 1
			if t = 0 then
			    xArgValid(1) := true
			    checkFetcharg(arg, xArg(1))
			elsif t > 0 and t <= 6 then
			    xArgValid(t) := true
			    checkFetcharg(arg, xArg(t))
			end if
		    else
			useerror
		    end if
		else
		    xArgValid(1) := true
		    checkFetcharg(arg, xArg(1))
		end if
		return

	    label 'A' :
		aOption := value
		Aoption := value

	    label 'C':
		Coption := value

	    label 'D' :
		if numDefineArgs < maxDefines then
		    numDefineArgs += 1
		    defineArgs(numDefineArgs) := "-D" + argString(j+1..*)
		else
		    error ("Too many preprocessor symbols;  max is ",
			    intstr(maxDefines), nonfatal)
		end if
		return

	    label 'E':
		Eoption := value

	    label 'F':
		Foption := value

	    label 'I' :
		if numIncludeDirs < maxIncludes then
		    numIncludeDirs += 1
		    includeDirs(numIncludeDirs) := "-I" + argString(j+1..*)
		else
		    error ("Too many include directories;  max is ",
			    intstr(maxIncludes), nonfatal)
		end if
		return

	    label 'K' :
		Koption := value

	    label 'L' :
		arg += 1
		checkFetcharg(arg, Library)
		return

	    label 'M' :
		arg += 1
		checkFetcharg(arg, macroFileName)

	    label 'O' :
		rOption := value
		kOption := value

	    label 'S' :
		Soption := true

	    label 'T' :
		Toption := value

	    label 'R':
		Roption := value

	    label '.' :
		dotOption := value

	    label '#':
		verbose := true

	    label :
		useerror
	end case
    end for
end option


procedure PrintCall (prog : string, args : array 1 .. * of string)
    put prog ..
    for i : 1 .. upper(args)
	exit when args(i) = ""
	if index(args(i), " ") = 0 then
	    put " ", args(i) ..
	else
	    put " '", args(i), "'" ..
	end if
    end for
    put ""
end PrintCall


child "callsys.st"


procedure Scanparse (s : string, var status : int)
    var i : int

    maketemp (t1File, "tt1a")
    maketemp (idFile, "tida")

    tArgs(1) := s
    tArgs(2) := t1File
    tArgs(3) := idFile
    i := 4

    if wOption then
    	tArgs(i) := "-w"
	i += 1
    end if

    if tOption = 1 then
	tArgs(i) := "-t"
	i += 1
    end if

    if dotOption then
	tArgs(i) := "-."
	i += 1
    end if

    if Eoption then
	tArgs(i) := "-E"
	i += 1
    end if

    if xArgValid(1) then
	tArgs(i) := xArg(1)
	i += 1
    end if

    for k : 1 .. numIncludeDirs
	tArgs(i) := includeDirs(k)
	i += 1
    end for

    tArgs(i) := "-I" + Include + "/" + machine
    i += 1
    tArgs(i) := "-I" + Include + "/common"
    i += 1

    tArgs(i) := "-D_" + machine + "_"
    i += 1

    tArgs(i) := "-D_MACHINE_=\"" + machine + "\""
    i += 1

    if kOption then
	tArgs(i) := "-D_UNCHECKED_"
	i += 1
    end if

    %-- indicators for user programmer to determine how compiler
    %-- thinks it is going to generate code;
    %-- via Ctranslator or via native coder
    %
    if aOption then
	tArgs(i) := "-D_CTRANSLATOR_"
	i += 1
    else
	tArgs(i) := "-D_CODER_"
	i += 1
    end if

    for k : 1 .. numDefineArgs
	tArgs(i) := defineArgs(k)
	i += 1
    end for

    tArgs(i) := ""

    pass :=  Library + ScanparsePass + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "scanparse", pass, tArgs)
    end if
end Scanparse


procedure Semantic1 (var status : int)
    var i : int

    maketemp (t2File, "tt2a")
    maketemp (d2File, "td2a")

    tArgs(1) := t1File
    tArgs(2) := t2File
    tArgs(3) := idFile
    i := 4

    if dOption or aOption then
	tArgs(i) := d2File
	tArgs(i+1) := "-d"
	i += 2
    end if

    if wOption then
    	tArgs(i) := "-w"
	i += 1
    end if

    if tOption = 2 then
	tArgs(i) := "-t"
	i += 1
    end if

    if xArgValid(2) then
	tArgs(i) := xArg(2)
	i += 1
    end if

    tArgs(i) := ""

    pass := Library + SemanticPass1 + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "semantic1", pass, tArgs)
    end if
end Semantic1


procedure Semantic2 (var status : int)
    var i : int

    maketemp (t3File, "tt3a")

    tArgs(1) := t2File
    tArgs(2) := t3File
    tArgs(3) := idFile
    i := 4

    if wOption then
    	tArgs(i) := "-w"
	i += 1
    end if

    if tOption = 3 then
	tArgs(i) := "-t"
	i += 1
    end if

    if xArgValid(3) then
	tArgs(i) := xArg(3)
	i += 1
    end if

    tArgs(i) := ""

    pass := Library + SemanticPass2 + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "semantic2", pass, tArgs)
    end if
end Semantic2


procedure Allocator (var status : int)
    var i : int

    maketemp(t4File, "tt4a")
    maketemp(rtFile, "tr4a")
    maketemp(alFile, "ta4a")
    maketemp(agFile, "ta4b")
    maketemp(d4File, "td4a")

    tArgs(1) := t3File
    tArgs(2) := t4File
    tArgs(3) := Library + AllocPass + machine + ".mdp"
    tArgs(4) := rtFile
    tArgs(5) := alFile
    tArgs(6) := agFile
    i := 7

    if dOption then
	tArgs(i) := d4File
	tArgs(i+1) := "-d"
	i += 2
    end if

    if rOption then
	tArgs(i) := "-n"
	i += 1
    end if

    if kOption then
	tArgs(i) := "-c"
	i += 1
    end if

    if tOption = 4 then
	tArgs(i) := "-t"
	i += 1
    end if

    if Roption then
	tArgs(i) := "-R"
	i += 1
    end if

    if xArgValid(4) then
	tArgs(i) := xArg(4)
	i += 1
    end if

/*
    if machine = "PC" then
	tArgs(i) := "-r"
	i += 1
    end if
*/

    tArgs(i) := ""

    pass := Library + AllocPass + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "allocator", pass, tArgs)
    end if
end Allocator


procedure Coder (var status : int)
    var i : int

    maketemp(cmFile, "tc5a")
    maketemp(crFile, "tc5b")

    tArgs(1) := t4File
    tArgs(2) := cmFile
    tArgs(3) := crFile
    tArgs(4) := ruFile
    tArgs(5) := Library + CoderPass + machine + ".pid"
    tArgs(6) := "X"		% placer for object coders 
    i := 7

    if dOption then
	tArgs(i) := idFile
	tArgs(i+1) := d2File
	tArgs(i+2) := d4File
	tArgs(i+3) := "-d"
	i += 4
    end if

    if macroFileName not= "" then
	tArgs(i) := "-M#include \"" + macroFileName + "\""
    else
	tArgs(i) := "-M#include \"" + Library + CoderPass + machine + ".mac\""
    end if
    i += 1

    if rOption then
	tArgs(i) := "-n"
	i += 1
    end if

    if uOption then
	tArgs(i) := "-u"
	i += 1
    end if

    if Koption then
	tArgs(i) := "-s"
	i += 1
    end if

    if kOption then
	tArgs(i) := "-c"
	i += 1
    end if

    if Coption then
	tArgs(i) := "-C"
	i += 1
    end if

    if Foption then
	tArgs(i) := "-F"
	i += 1
    end if

    if tOption = 5 then
	tArgs(i) := "-t"
	i += 1
    end if

    if xArgValid(5) then
	tArgs(i) := xArg(5)
	i += 1
    end if

    tArgs(i) := ""

    pass := Library + CoderPass + machine + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "coder", pass, tArgs)
    end if
end Coder


procedure Preprocess (var status : int, inFile, outFile : string)
    tArgs(1) := inFile
    tArgs(2) := outFile
    tArgs(3) := ""

    pass := Library + PreprocessorPass

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "macro", pass, tArgs)
    end if
end Preprocess


procedure Compile (var s : string, var status : int)
    % Scanparse 
    Scanparse (s, status)

    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 1 then
	cleanup
	return
    end if

    % Semantic 1 
    Semantic1 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 2 then
	cleanup
	return
    end if

    if not Toption then
	remove (t1File, false)
    end if

    % Semantic 2 
    Semantic2 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 3 then
	cleanup
	return
    end if

    if not Toption then
	remove (t2File, false)
    end if

    % Allocator 
    Allocator (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 4 then
	cleanup
	return
    end if

    if not Toption then
	remove (t3File, false)
    end if

    % Concatenate Routine Table with Predefined Routine
    maketemp (ruFile, "tu4a")

    catfiles (ruFile, Library + CoderPass + machine + ".prt", rtFile, "", "")

    if not Toption then
	remove (rtFile, false)
    end if

    % Coder 
    Coder (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 5 then
	cleanup
	return
    end if

    if not Toption then
	remove (idFile, false)
	remove (d2File, false)
	remove (t4File, false)
	remove (d4File, false)
	remove (ruFile, false)
    end if

    % Concatenate Assembly Source 
    maketemp (asFile, "tc6a")

    catfiles (asFile, alFile, agFile, cmFile, crFile)

    if not Toption then
	remove (alFile, false)
	remove (agFile, false)
	remove (cmFile, false)
	remove (crFile, false)
    end if

    s := stripsuf(stripath(s)) + "." + asSuf
    tmpSource(sourceFile) := true

    % Run the concurrency macro processor 
    if Coption then
	maketemp (as2File, "tc6b")
	Preprocess (status, asFile, as2File)
    else
	Preprocess (status, asFile, s)
    end if

    if status not= 0 then
	err := true
	cleanup
	return
    end if

    if not Toption then
	remove (asFile, false)
    end if

    if Coption then
	% run C optimizer on output 
	tArgs(1) := as2File
	tArgs(2) := s
	tArgs(3) := ""

	pass := Library + OptimizerPass

	if verbose then
	    PrintCall (pass, tArgs)
	    status := 0
	else
	    callsys (status, "optimizer", pass, tArgs)
	end if

	if not Toption then
	    remove (as2File, false)
	end if
    end if
end Compile


procedure CheckStub (s : string, var status : int)
    % Scanparse 
    Scanparse (s, status)

    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 1 then
	cleanup
	return
    end if

    % Semantic 1 
    Semantic1 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 2 then
	cleanup
	return
    end if

    if not Toption then
	remove (t1File, false)
    end if

    % Semantic 2 
    Semantic2 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 3 then
	cleanup
	return
    end if

    if not Toption then
	remove (t2File, false)
    end if

    % Allocator 
    Allocator (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 4 then
	cleanup
	return
    end if

    if not Toption then
	remove (t2File, false)
	remove (t3File, false)
	remove (ruFile, false)
	remove (d2File, false)
	remove (idFile, false)
    end if
end CheckStub


procedure Assemble (var s : string, var status : int)
    % Run the Appropriate Assembler 
    var asArgs : array 1..10 of string
    var i : int := 1

    % set target architecture 
    tArgs(i) := arch
    i += 1

    if Roption then
	asArgs(i) := "-R"
	i += 1
    end if

    if xArgValid(6) then
	asArgs(i) := xArg(6)
	i += 1
    end if

    asArgs(i)   := "-o"
    asArgs(i+1) := stripsuf(stripath (s)) + "." + ldSuf
    asArgs(i+2) := s
    asArgs(i+3) := ""

    pass := Library + AssemblerPass

    if verbose then
	PrintCall (pass, asArgs)
	status := 0
    else
	callsys (status, "assemble", pass, asArgs)
    end if

    if status not= 0 then
	return
    end if

    if tmpSource(sourceFile) then
	remove (s, true)
    end if

    s := stripsuf(stripath(s)) + "." + ldSuf
    tmpSource(sourceFile) := true
end Assemble


procedure Translate (cFileName : string, var status : int)
    var i : int

    tArgs(1) := t3File
    tArgs(2) := cFileName
    tArgs(3) := d2File
    tArgs(4) := idFile
    tArgs(5) := Library + TranslatorPass + machine + ".mdp"
    i := 6

    if tOption = 4 then
	tArgs(i) := "-d"
	i += 1
    end if

    if uOption then
	tArgs(i) := "-u"
	i += 1
    end if

    if rOption then
	tArgs(i) := "-n"
	i += 1
    end if

    if Koption then
	tArgs(i) := "-s"
	i += 1
    end if

    if macroFileName not= "" then
	tArgs(i) := "-M" + macroFileName
	i += 1
    end if

    if kOption then
	tArgs(i) := "-c"
	i += 1
    end if

    if xArgValid(4) then
	tArgs(i) := xArg(4)
	i += 1
    end if

    tArgs(i) := ""

    pass := Library + TranslatorPass + executable

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "tp2c", pass, tArgs)
    end if
end Translate


procedure CompileC (cFileName : string, var s : string, var status : int)
    var register i : int

    tArgs(1) := cFileName

    if Soption then
	tArgs(2) := "-S"
	s := stripsuf(stripath(s)) + "." + asSuf
    else
	tArgs(2) := "-c"
	s := stripsuf(stripath(s)) + "." + ldSuf
	if not cOption then
	    tmpSource(sourceFile) := true
	end if
    end if

    tArgs(3) := "-o"
    tArgs(4) := s
    tArgs(5) := "-I" + Include
    i := 6

    for k : 1 .. numDefineArgs
	tArgs(i) := defineArgs(k)
	i += 1
    end for

    if not kOption then
	tArgs(i) := "-DCHECKING"
	i += 1
    end if

    if Coption then
	tArgs(i) := "-O"
	i += 1
    end if

    if Roption then
	tArgs(i) := "-R"
	i += 1
    end if

    % ignore warnings from C compiler 
    tArgs(i) := "-w"
    i += 1

    % set target architecture 
    tArgs(i) := arch
    i += 1

    % don't let gcc screw up recursive routines 
    tArgs(i) := "-fno-inline"
    i += 1

    if xArgValid(5) then
	tArgs(i) := xArg(5)
	i += 1
    end if

    tArgs(i) := ""

    pass := Library + CCompilePass

    if verbose then
	PrintCall (pass, tArgs)
	status := 0
    else
	callsys (status, "cc", pass, tArgs)
    end if

    tmpSource(sourceFile) := true
end CompileC


procedure TranslateAndCompile (var s : string, var status : int)
    var cFile : string

    % Scanparse 
    Scanparse (s, status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 1 then
	cleanup
	return
    end if

    % Semantic 1 
    Semantic1 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 2 then
	cleanup
	return
    end if

    if not Toption then
	remove (t1File, false)
    end if

    % Semantic 2 
    Semantic2 (status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 3 then
	cleanup
	return
    end if

    if not Toption then
	remove (t2File, false)
    end if

    % C translator 
    if Aoption then
	cFile := stripsuf(stripath(s)) + ".c"
    else
	maketemp (tcFile, "ttca")
	tcFile += ".c"
	cFile := tcFile
    end if
    Translate (cFile, status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif qOption = 4 then
	cleanup
	return
    end if

    % C compiler 
    CompileC (cFile, s, status)
    if status not= 0 then
	err := true
	cleanup
	return
    elsif cOption or Soption then
	cleanup
	return
    end if

    if not Toption then
	remove (tcFile, false)
    end if
end TranslateAndCompile


% main program

child "signal.st"

SetupSignals

put version

if nargs = 0 then
    help
    sysexit (10)
end if

% Process Options 

arg := 1
loop
    const argString := fetcharg(arg)

    if argString(1) = "-" then
	option
    else
	nSources += 1
	if nSources > maxSources then
	    error ("Too many source files", "", fatal)
	else
	    tSource(nSources) := argString
	    const suf := getsuf(argString)

	    if length(suf) = 1 then
		const ch : char := suf(1)
		case ch of
		    label 't', 's', 'c':
			nWorkSources += 1
		    label 'o', 'a':
		    label :
		    error (files, "", fatal)
		end case
	    elsif suf not= "st" and suf not= "bd" and suf not= "ch" and
		    suf not= "t+" and suf not= "bd+" and suf not= "ch+" and
		    suf not= "st+" then
		error (files, "", fatal)
	    else
		nWorkSources += 1
	    end if
	end if
    end if
    exit when arg = nargs
    arg += 1
end loop

if nSources = 0 then
    help
    sysexit (10)
end if

% keep the source files around after 
for i : 1.. nSources
    tmpSource(i) := false
end for

% Set machine parameters 

begin
    const coderPass : string := Library + CoderPass + machine + executable
    var fd : int
    open : fd, coderPass, read
    if fd = 0 then
	aOption := true
    else
	close : fd
    end if
end

% Set float options 

if Eoption then
    qOption := 1
end if


if not oOption then
    ldOut := stripsuf(stripath(tSource(1))) + "." + outSuf
end if


% Compile Turing Plus source files 
var nStubs := 0

for j : 1 .. nSources
    const suf := getsuf(tSource(j))
    sourceFile := j
    var status : int := 0

    if nWorkSources > 1 then
	put tSource(j), ":"
	flushstreams
    end if
    if suf = "t" or suf = "ch" or suf = "bd" or suf = "t+" or suf = "ch+" or
	    suf = "bd+" then
	% Run the Compiler 
	if aOption then
	    TranslateAndCompile (tSource(j), status)
	else
	    Compile (tSource(j), status)
	    if status = 0 and qOption > 6 and not Soption then
		Assemble (tSource(j), status)
	    end if
	end if

	% just to be sure 
	cleanup
    elsif suf = "st" or suf = "st+" then
	nStubs += 1
	CheckStub (tSource(j), status)
    elsif suf = "c" then
	const cFile := tSource(j)
	CompileC (cFile, tSource(j), status)
    elsif suf = asSuf and not Soption then
	Assemble (tSource(j), status)
    end if
    if status not= 0 then
	err := true
    end if
end for

if err then
    sysexit (1)
elsif qOption <= 7 or cOption or Soption then
    sysexit (0)
end if

if nStubs > 0 then
    if nStubs not= nSources then
	put "tpc: stubs (.st) compiled along with non-stubs\n",
	    "     other files compiled to object files (.o); no link done"
	sysexit (1)
    else
	sysexit (0)
    end if
end if


% Link the Results 
Lib := Library + "/tlib" + machine

if kOption then
    % Use unchecked library
    Lib += "u.a"
else
    % Use checked library
    Lib += ".a"
end if

    pass := Library + LinkerPass

tArgs(1) := "-o"
tArgs(2) := ldOut

var i := 3

% set target architecture 
tArgs(i) := arch
i += 1

for k : 1 .. nSources
    tArgs(i) := tSource(k)
    i += 1
end for

for k : 1 .. lOption
    tArgs(i) := ldLibs(k)
    i += 1
end for

if dOption then
    tArgs(i) := "-lg"
    i += 1
end if

tArgs(i) := Lib
i += 1

tArgs(i) := ""

var status : int

if verbose then
    PrintCall (pass, tArgs)
    status := 0
else
    callsys (status, "ld", pass, tArgs)
end if

if status not= 0 then
    sysexit (1)
end if

for k : 1 .. nSources
    if tmpSource(k) then
	remove (tSource(k), true)
    end if
end for

sysexit (0)

