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

%
% Extract human-readable line and file information out of the
% lineAndFile and fileTable parameters.
%

parent "TLE.ch"

stub procedure TLELF (
	    lineAndFile	: nat4,
	    fileTable	: addressint,
	var lineNumber	: nat4,
	var fileName	: addressint
	)

body procedure TLELF

    const MaxLineNumber	:= 100000
    type FileTable :
	record
	    fileCount		: nat4
	    fileNames		: char(1)	% Variable size
	end record

    if (lineAndFile = 0) or (fileTable = 0) then
	%
	% Unknown line and file.
	%
	lineNumber := 0
	fileName := 0
	return
    end if

    const fileNumber	: nat		:= lineAndFile div MaxLineNumber

    if (fileNumber < 1) or (fileNumber > FileTable@(fileTable).fileCount) then
	%
	% This should never happen.
	%
	const errorMsg	: array 0 .. 0 of string(25)	:=
		init ("<Corrupted line and file>")
	lineNumber := 0
	fileName := addr(errorMsg(0))
    end if

    lineNumber := lineAndFile mod MaxLineNumber

    %
    % Search the file table for the proper file name.
    %
    var register name	: addressint	:= addr(FileTable@(fileTable).fileNames)

    for count : 2 .. fileNumber
	loop
	    exit when char@(name) = '\0'
	    name += 1
	end loop
	name += 1
    end for

    fileName := name

end TLELF
