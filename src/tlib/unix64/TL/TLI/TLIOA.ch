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
% pOpenArg
%

parent "TLI.ch"

stub procedure TLIOA (
	    openMode	: StreamModeSet,
	    openArg	: int,
	var streamNo	: int
	)

body procedure TLIOA

#if CHECKED then
    if openArg <= 0 then
	TLQUIT( "Open attempted of illegal argument number " + intstr(openArg),
	         excpIllegalStreamNumber )
    end if
#end if

    if openArg > TLIARC then
	streamNo := 0
	return
    end if

#if CHECKED then
    if openArg > maxargfiles then
	TLQUIT( "Open argument number " + intstr(openArg) + " is too large",
	         excpIllegalStreamNumber )
    end if
    if (TLIS(openArg).mode * StreamModeSet(IoClosedMode,IoLimboMode))
	    = StreamModeSet() then
	TLQUIT( "Open attempted of already-opened stream number " + intstr(openArg),
	         excpOpenOfOpenedStream )
    end if
#end if

    streamNo := openArg
    TLIOS (streamNo, openMode, false)

end TLIOA
