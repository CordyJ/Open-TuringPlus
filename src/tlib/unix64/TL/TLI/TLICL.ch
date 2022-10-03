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
% pClose
%

parent "TLI.ch"

stub procedure TLICL (
	    streamNo	: int
	)

body procedure TLICL

#if CHECKED then
    if (streamNo < MinStreamNumber) or (streamNo > maxstream) then
	TLQUIT( "Close attempted on illegal stream number " + intstr(streamNo),
	         excpIllegalStreamNumber )
    end if
    if streamNo <= StdErrStream then
	TLQUIT( "Close of standard stream " + intstr(streamNo) + " is not allowed",
	         excpCloseOfStandardStream )
    end if
#end if

    bind var register stream to TLIS(streamNo)

#if CHECKED then
    if stream.mode = StreamModeSet() then
	TLQUIT( "Close attempted on unopened stream number " + intstr(streamNo),
	         excpCloseOfUnopenedStream )
    end if
    if IoClosedMode in stream.mode then
	TLQUIT( "Close attempted on closed stream number " + intstr(streamNo),
	         excpCloseOfClosedStream )
    end if
#end if

    if IoLimboMode not in stream.mode then
	TLIFCL (stream.info)
	if streamNo > TLIARC then
	    TLB.TLBMFR (stream.fileName)
	end if
    end if

    stream.mode := StreamModeSet(IoClosedMode)

end TLICL
