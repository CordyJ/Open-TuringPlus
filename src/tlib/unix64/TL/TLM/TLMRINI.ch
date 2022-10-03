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
% pInitializeMonitor
%

parent "TLM.ch"

stub procedure TLMRINI ( register md : TL_MDpointer,
			  name        : addressint
			)

body procedure TLMRINI

    TL_Monitor(md).monitorPriority	:= 0
    TL_Monitor(md).deviceMonitor	:= false
    TL_Monitor(md).mQLock		:= 0
    TL_Monitor(md).entryParameter	:= TL_MonitorFree
    TL_Monitor(md).entryQ.head		:= nil(TL_Process)
    TL_Monitor(md).entryQ.tail		:= nil(TL_Process)
    TL_Monitor(md).reEntryQ.head	:= nil(TL_Process)
    TL_Monitor(md).reEntryQ.tail	:= nil(TL_Process)
    TL_Monitor(md).name			:= name
    TL_Monitor(md).firstCondition	:= nil(TL_Condition)

    var x : TL_lockStatus_t
    TLK.TLKLKON (TLMMLL, x)

     % doubly link together all monitors
    TL_Monitor(md).nextMonitor	:= TLMMLH
    TL_Monitor(md).prevMonitor	:= nil(TL_Monitor)

    if TLMMLH not= nil(TL_Monitor) then
	TL_Monitor(TLMMLH).prevMonitor := md
    end if

    TLMMLH := md

    TLK.TLKLKOFF (TLMMLL,x)

end TLMRINI
