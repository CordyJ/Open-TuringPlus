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
% Reset eof
%

parent "TLI.ch"

stub procedure TLIEFR (
	    streamNo	: int
	)

body procedure TLIEFR

#if CHECKED then
    if (streamNo < MinStreamNumber) or (streamNo > maxstream) then
	TLQUIT( "Reset of eof attempted on illegal stream number "
		+ intstr(streamNo), excpIllegalStreamNumber )
    end if
#end if

    const streamMode	: StreamModeSet	:= TLIS(streamNo).mode

#if CHECKED then
    if streamMode = StreamModeSet() then
	TLQUIT( "Reset of eof attempted on unopened stream number "
		+ intstr(streamNo), excpIoOnUnopenedStream )
    end if
    if IoClosedMode in streamMode then
	TLQUIT( "Reset of EOF attempted on closed stream number "
		+ intstr(streamNo), excpIoOnClosedStream )
    end if
#end if

    if IoLimboMode in streamMode then
	return

#if CHECKED then
    elsif (streamMode * StreamModeSet(IoGetMode,IoReadMode)) = StreamModeSet()
	    then
	TLQUIT( "Reset of eof attempted on incompatible stream number "
		+ intstr(streamNo), excpIoOnIncompatibleStream )
#end if

    end if

    TLIFZ (TLIS(streamNo).info)
    TLIS(streamNo).atEof := false

end TLIEFR
