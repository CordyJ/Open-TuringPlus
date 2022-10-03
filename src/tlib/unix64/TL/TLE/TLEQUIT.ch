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
% pQuit
%

parent "TLE.ch"

%
% If the number or type of the parameters ever changes, make sure that
% the TLEDH routine is changed accordingly!
%
stub procedure TLEQUIT (
	    quitCode	: int4,
	    callerPlace	: addressint,
	    quitType	: int1
	)

body procedure TLEQUIT

    bind var register pd to TL_Process(TLKPD)

    % -- should default handler be invoked?
    const invokeDefault : boolean := (pd.handlerQhead = nil(TL_Handler))

    if invokeDefault then

	% -- check if default handler is already active
	if pd.currentHandler = type(TL_HApointer,addr(TLEDEFHA)) then
	    % -- The default handler was running, and someone did a quit!
	    % -- The library is in really sad shape!  Might as well exit.
	    TLK.TLKUEXIT (-1)
	else
	    % -- Call default handler

	    % -- If we are going to call default handler,
	    % -- then reset trap processing.
	    TLETR.TLETRR

	    % -- install a 'handler' descriptor to be used by default handler
	    pd.handlerQhead := type(TL_HApointer,addr(TLEDEFHA))
	    TLEDEFHA.nextHandler := nil(TL_Handler)
	end if
    end if

    bind var register ha to TL_Handler(pd.handlerQhead)

    ha.quitCode	:= quitCode

    case quitType of
	label -1:	% quit <
	    if callerPlace ~= 0 then
		ha.lineAndFile		:= Place@(callerPlace).lineAndFile
		ha.fileTable		:= Place@(callerPlace).fileTable
	    else
		% -- translator emits code to restore line&file prior
		% -- to quitting
		ha.lineAndFile		:= pd.lineAndFile
		ha.fileTable		:= pd.fileTable
	    end if
	    pd.exception.libraryQuitCode	:= pd.exception.quitCode
	    pd.exception.quitCode		:= 0

	label 0:	% quit
	    ha.lineAndFile			:= pd.lineAndFile
	    ha.fileTable			:= pd.fileTable
	    pd.exception.libraryQuitCode	:= pd.exception.quitCode
	    pd.exception.quitCode		:= 0

	label 1:	% quit >
	    % -- Must be inside a handler.
	    bind register oldHa to TL_Handler(pd.currentHandler)
	    ha.lineAndFile		:= oldHa.lineAndFile
	    ha.fileTable		:= oldHa.fileTable

#if CHECKED then
	label :   % unknown
	    put "TLEQUIT: INTERNAL LIBRARY ERROR. Unknown quitType!"
	    TLK.TLKUEXIT(-1)
#end if
    end case


    % -- Mark the active handler as the (new) executing handler, and
    % -- unlink it from the handler chain.
    pd.currentHandler  := pd.handlerQhead
    pd.handlerQhead    := ha.nextHandler

    if invokeDefault then
	% -- call default handler
	TLEH	% Does not return
    else
	% -- Dispatch the new executing handler.
	TLEDH	% Does not return
    end if

    /* NOT REACHED */

end TLEQUIT
