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
% pEof
%

parent "TLI.ch"

stub function TLIEOF (
	    streamNo	: int
	)	: boolean

body function TLIEOF

#if CHECKED then
    if not TLIUXS then
	TLIXSN := streamNo
    end if

    if (streamNo < MinStreamNumber) or (streamNo > maxstream) then
	TLQUIT( "Eof attempted on illegal stream number " + intstr(TLIXSN),
	         excpIllegalStreamNumber )
    end if
#end if

    const streamMode	: StreamModeSet	:= TLIS(streamNo).mode

#if CHECKED then
    if streamMode = StreamModeSet() then
	TLQUIT( "Eof attempted on unopened stream number " + intstr(TLIXSN),
	         excpIoOnUnopenedStream )
    end if
    if IoClosedMode in streamMode then
	TLQUIT( "Eof attempted on closed stream number " + intstr(TLIXSN),
	         excpIoOnClosedStream )
    end if
#end if

    if IoLimboMode in streamMode then
	%
	% Implicitly open on an eof?!?  Sure, why not!
	%
	var sn := streamNo
	TLIOS (sn, StreamModeSet(IoGetMode), true)

#if CHECKED then
    elsif (streamMode * StreamModeSet(IoGetMode,IoReadMode)) = StreamModeSet()
	    then
	TLQUIT( "Eof attempted on incompatible stream number " + intstr(TLIXSN),
	         excpIoOnIncompatibleStream )
#end if

    end if

    bind var register stream to TLIS(streamNo)

    if not stream.atEof then
	var ch : Cint

        if (stream.lastOp = IoPutMode) or (stream.lastOp = IoWriteMode) then
            TLIFSK (stream.info, 0, 1)
        end if

	ch := TLIFGC(stream.info)
	if ch = EndOfFileChar then
	    stream.atEof := true
	else
	    TLIFUG (ch, stream.info)
	end if
	stream.lastOp := IoGetMode
    end if

    result stream.atEof

end TLIEOF
