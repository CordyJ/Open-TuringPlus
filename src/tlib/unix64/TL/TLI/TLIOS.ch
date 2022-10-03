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
% Open stream
%

parent "TLI.ch"

stub procedure TLIOS (
	var streamNo	: int,
	    openMode	: StreamModeSet,
	    dieOnError	: boolean
	)

body procedure TLIOS

    bind var register stream to TLIS(streamNo)

#if LIMIT then
    /*
    ** Make sure the file is not an absolute path name, and
    ** does not have "../" within the path.
    */
    if char@(stream.fileName) = '/' then
	if dieOnError then
	    TLQUIT( "Open of absolute path file names not allowed",
	             excpOpenOfIllegalFileName )
	else
	    streamNo := 0
	    return
	end if
    elsif ((char@(stream.fileName) = '.') and (char@(stream.fileName + 1) = '.')
		and (char@(stream.fileName + 2) = '/')
	    or (index(string@(stream.fileName),"/../") ~= 0)) then
	if dieOnError then
	    TLQUIT( "Open of \"../\" path file names not allowed",
	             excpOpenOfIllegalFileName )
	else
	    streamNo := 0
	    return
	end if
    end if

    /*
    ** Make sure the file is not executable.
    */
    external function access (fileName : string, mode : Cint) : Cint
    if access(string@(stream.fileName), 1) = 0 then
        if dieOnError then
	    TLQUIT( "Open of executable files not allowed",
	             excpOpenOfIllegalFileName )
        else
            streamNo := 0
            return
        end if
    end if
#end if % LIMIT

    const inputModes	:= openMode * StreamModeSet(IoGetMode,IoReadMode)
    const outputModes	:= openMode * StreamModeSet(IoPutMode,IoWriteMode)

    if outputModes ~= StreamModeSet() then
	if IoModMode in openMode then
	    stream.info := TLIFOP(string@(stream.fileName), "r+")
	    if stream.info = 0 then
		stream.info := TLIFOP(string@(stream.fileName), "w+")
	    end if
	elsif inputModes = StreamModeSet() then
	    stream.info := TLIFOP(string@(stream.fileName), "w")
	else
	    stream.info := TLIFOP(string@(stream.fileName), "w+")
	end if
    elsif inputModes ~= StreamModeSet() then
	stream.info := TLIFOP(string@(stream.fileName), "r")
    else
	TLQUIT( "Must have at least one of \"get\", \"put\", \"read\", or \"write\" in open mode",
	         excpIllegalOpenMode )
    end if

    if stream.info = 0 then
	if dieOnError then
	    TLQUIT(  "Cannot open file \"" + string@(stream.fileName) + "\"",
	             excpImplicitOpenFailed )
	else
	    streamNo := 0
	    return
	end if
    end if

    stream.mode		:= openMode
    stream.lastOp	:= IoSeekMode
    stream.atEof	:= false

end TLIOS
