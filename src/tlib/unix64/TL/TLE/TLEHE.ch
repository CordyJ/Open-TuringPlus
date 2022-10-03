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

parent "TLE.ch"

% TLEHE
%  Called when entering a procedure with a handler in it.  This procedure
%  enters the new handler into the handler chain.
%
%  Standard C-translator version calls this routine followed immediately
%  by a "setjmp(TL_Handler(handlerArea).savedState)".
%  
%  Native versions call this routine from TLEHDEF.
%
stub procedure TLEHE (handlerArea: TL_HApointer)

body procedure TLEHE
    bind var register ha to TL_Handler(handlerArea)
    bind var register pd to TL_Process(TLKPD)

    % -- Setup the handler info.
    ha.lineAndFile	:= 0
    ha.fileTable	:= pd.fileTable

    % -- Insert the new active handler into the handler chain.
    ha.nextHandler	:= pd.handlerQhead
    pd.handlerQhead	:= handlerArea
end TLEHE
