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
% pTimeOutSignal
%
% Timeout conditions are like deferred conditions.
% Thus, signals on these conditions are not immediate!
%

parent "TLM.ch"

stub procedure TLMCTSIG ( register cd : TL_CDpointer )

body procedure TLMCTSIG

    const register md	: TL_MDpointer	:= TL_Condition(cd).md

    if TL_Monitor(md).deviceMonitor then

	const register pd : TL_PDpointer  := TL_Condition(cd).signalQ.head

	if pd not= nil(TL_Process) then
	     %
	     % Timeout condition is like a deferred condition;
	     %

	     %
	     % Signal the first process from the condition queue 
	     %

	    TL_Condition(cd).signalQ.head := TL_Process(pd).monitorQlink
	    TL_Process(pd).monitorQlink := nil(TL_Process)

	     % indicate we are no longer on timeoutQ
	    TL_Process(pd).waitParameter := 0

	      % set flag in pd to indicate that it was awoken by a signal,
	      % not a timeout!
	    bits(TL_Process(pd).timeOutStatus, Signalled) := 1

	    TLK.TLKSWAKE(pd)
	end if

	return
    end if

    %
    % -- Get here if NOT a device monitor 
    %

     %
     % lock monitor descriptor.
     % NOTE: this lock guards both monitor entryQ AND timeout conditionQ
     %        AND timeoutCondSignalled field in process descriptor
     %       Thus lock() must be called before accessing timeout conditionQ
     %
    var x : TL_lockStatus_t
    TLK.TLKLKON(TL_Monitor(md).mQLock, x)

    const register pd	: TL_PDpointer	:= TL_Condition(cd).signalQ.head

    if pd not= nil(TL_Process) then
	 %
	 % Timeout condition is like a deferred condition;
	 % processes are not woken up immediately, 
	 % but rather are put on monitor queue, to enter later
	 %

	 %
	 % Move the first process from the condition queue 
	 % to the monitor queue.
	 %

	TL_Condition(cd).signalQ.head := TL_Process(pd).monitorQlink
	TL_Process(pd).monitorQlink := nil(TL_Process)

	 % indicate we are no longer on timeoutQ
	TL_Process(pd).waitParameter := 0

	  % set flag in pd to indicate that it was awoken by a signal,
	  % not a timeout!
	bits(TL_Process(pd).timeOutStatus, Signalled) := 1

	 %
	 % insert process on monitor 'reEntryQ'
	 % (note: 'reEntryQ' has precedence over 'entryQ')
	 %
	if TL_Monitor(md).reEntryQ.head not= nil(TL_Process) then
	    TL_Process(TL_Monitor(md).reEntryQ.tail).monitorQlink := pd
	else
	    TL_Monitor(md).reEntryQ.head := pd
	end if
	TL_Monitor(md).reEntryQ.tail := pd

    end if

     % unlock monitor descriptor
    TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)

end TLMCTSIG
