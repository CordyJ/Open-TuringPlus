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
% pSetStream
%

parent "TLI.ch"

%
% Check that stream number streamNo is reasonable.
% If the stream is in limbo, open it with the specified mode.  Otherwise,
% check that the mode specified is compatible with the stream's true mode.
%
stub procedure TLISS (
	    streamNo	: int,
	    ioMode	: Cint
	)

body procedure TLISS

#if CHECKED then
    const operation : array IoSeekMode .. IoWriteMode of string(15) :=
	    init ("Seek or Tell", "Get", "Put", "Read", "Write")

    var errorMsg : string(60)
    if (streamNo < MinStreamNumber) or (streamNo > maxstream) then
	if (streamNo > 0) and (streamNo <= TLIARC) then
	    errorMsg := "Argument number " + intstr(streamNo) + " is too large"
	else
	    errorMsg := operation(ioMode) 
			+ " attempted on illegal stream number " 
			+ intstr(streamNo)
	end if
	     
	TLQUIT( errorMsg, excpIllegalStreamNumber )
    end if
#end if

    const register streamMode := TLIS(streamNo).mode

#if CHECKED then
    if not TLIUXS then
	TLIXSN := streamNo
    end if

    if streamMode = StreamModeSet() then
	if streamNo <= TLIARC then
	    TLQUIT( "Argument number " + intstr(TLIXSN) + " is too large",
	             excpIllegalStreamNumber )
	else
	    TLQUIT( operation(ioMode)
		    + " attempted on unopened stream number " + intstr(TLIXSN),
	            excpIoOnUnopenedStream )
	end if
    end if
    if IoClosedMode in streamMode then
	TLQUIT( operation(ioMode)
		+ " attempted on closed stream number " + intstr(TLIXSN),
	        excpIoOnClosedStream )
    end if
#end if

    if IoLimboMode in streamMode then
	var sn := streamNo
	TLIOS (sn, StreamModeSet(ioMode), true)

#if CHECKED then
    elsif ioMode not in streamMode then
	TLQUIT( operation(ioMode)
		+ " attempted on incompatible stream number " + intstr(TLIXSN),
	        excpIoOnIncompatibleStream )
#end if

    elsif streamNo = StdInStream then
	% Flush any pending output.
	TLIFFL (TLIS(StdOutStream).info)
	TLIFFL (TLIS(StdErrStream).info)

    end if

    bind var register stream to TLIS(streamNo)

    if stream.lastOp not= ioMode then
	if (stream.lastOp = IoGetMode) or (stream.lastOp = IoReadMode) then
	    if (ioMode = IoPutMode) or (ioMode = IoWriteMode) then
		if stream.atEof then
		    %
		    % Stdio gets very careless about "current position"
		    % when at end-of-file.  Explicitly seek to EOF.
		    %
		    TLIFSK (stream.info, 0, 2)
		else
		    TLIFSK (stream.info, 0, 1)
		end if
	    end if
	elsif (stream.lastOp = IoPutMode) or (stream.lastOp = IoWriteMode) then
	    if (ioMode = IoGetMode) or (ioMode = IoReadMode) then
		TLIFSK (stream.info, 0, 1)
	    end if
	end if

	stream.lastOp := ioMode
    end if
end TLISS
