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
% Default handler.  If the exception has not been fielded at this point,
% then it is fatal.  Print out an appropriate message and die.
%

parent "TLE.ch"

stub procedure TLEH

body procedure TLEH

    %
    % Flush all output streams.
    %
    TLI.TLIFS

    bind var register ha to TL_Handler(TL_Process(TLKPD).currentHandler)

    var lineNumber	: nat4
    var fileName	: addressint

    TLELF (ha.lineAndFile, ha.fileTable, lineNumber, fileName)

    if fileName ~= 0 then
	put: 0, skip, "Line ", intstr(lineNumber), " of ",
		string@(fileName), ": " ..
    else
	put: 0, ""
    end if

#if not SEQUENTIAL then
    if TLK.TLKFRKED then
	put: 0, "Process \"", string@(TL_Process(TLKPD).name), "\": " ..
    end if
#end if

    if (TL_Process(TLKPD).exception.libraryQuitCode ~= 0) and
	    (ha.quitCode = TL_Process(TLKPD).exception.libraryQuitCode) then
	%
	% Got a library or checking abort.
	%
	put: 0, TL_Process(TLKPD).exception.errorMsg ..
    else
	%
	% User-specified quit.
	%
	put: 0, "Quit #", intstr(ha.quitCode) ..
    end if

    put: 0, "."

    %
    % Flush the output streams again (just in case).
    %
    TLI.TLIFS

    TLK.TLKUEXIT (ha.quitCode)
end TLEH
