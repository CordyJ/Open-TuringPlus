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
% pFinalizeMonitor
%

parent "TLM.ch"

stub procedure TLMRFIN ( register md : TL_MDpointer)

body procedure TLMRFIN

    %
    % Remove monitor descriptor from linked list of monitors
    % This is used when freeing up dynamic monitors
    %

#if CHECKED then
    %
    % make sure entryQ and reEntryQ are empty
    %
    if TL_Monitor(md).reEntryQ.head ~= nil(TL_Process)
	   or TL_Monitor(md).entryQ.head ~= nil(TL_Process) then

	if TL_Monitor(md).reEntryQ.head ~= nil(TL_Process) then
	    TLQUIT( "TLMRFIN: LIBRARY ABORT - monitor reEntryQ was not nil",
		    excpMonitorBusy)
	else
	    TLQUIT( "TLMRFIN: LIBRARY ABORT - monitor entryQ was not nil",
		    excpMonitorBusy)
	end if
    end if

    %
    % make sure all conditionQ signalQ's are empty
    %
    var cp : TL_CDpointer := TL_Monitor(md).firstCondition
    loop
	exit when cp = nil(TL_Condition)
	if TL_Condition(cp).signalQ.head ~= nil(TL_Process) then
	    TLQUIT ( "TLMRFIN: LIBRARY ABORT - Condition queue was not nil",
		     excpMonitorBusy )
        end if
	cp := TL_Condition(cp).nextCondition
    end loop
#end if

    var x : TL_lockStatus_t
    TLK.TLKLKON(TLMMLL,x)

    %
    % unlink monitor descriptor
    %
    const next := TL_Monitor(md).nextMonitor
    const prev := TL_Monitor(md).prevMonitor
    if next ~= nil(TL_Monitor) then
        TL_Monitor(next).prevMonitor := prev
    end if
    if prev = nil(TL_Monitor) then
        TLMMLH := next
    else
        TL_Monitor(prev).nextMonitor := next
    end if

    TLK.TLKLKOFF(TLMMLL,x)

end TLMRFIN
