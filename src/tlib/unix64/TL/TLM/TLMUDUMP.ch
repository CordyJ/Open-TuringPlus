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

parent "TLM.ch"

/*
 * routine to search the monitor and condition queues
 * and dump any processes blocked within
 */

stub procedure TLMUDUMP

body procedure TLMUDUMP

    % -- dump the state of the program
    %

     % variable used in lock() and unlock()
    var y : TL_lockStatus_t

     %
     % lock linked list of monitor descriptors
     %
    TLK.TLKLKON(TLMMLL,y)

     % now scan monitors 
     % print out queues waiting to enter monitor
     %           and all condition queues
     %
    var register md	: TL_MDpointer	:= TLMMLH

    loop
	exit when md = nil(TL_Monitor)

	 % variable used in lock() and unlock()
	var x : TL_lockStatus_t

	 % lock monitor
	TLK.TLKLKON(TL_Monitor(md).mQLock, x)

	if TL_Monitor(md).entryQ.head not= nil(TL_Process) then

	    put : 0, "\n****** Entering Monitor `",
			string@(TL_Monitor(md).name), "'\n" ..

	    var register pd : TL_PDpointer := TL_Monitor(md).entryQ.head

	     %
	     % print out each process waiting to enter monitor
	     %
	    loop
		TLK.TLKUDMPP(pd)
		pd := TL_Process(pd).monitorQlink
		exit when pd = nil(TL_Process)
	    end loop
	end if

	if TL_Monitor(md).reEntryQ.head not= nil(TL_Process) then

	    put : 0, "\n****** Re-Entering Monitor `",
			string@(TL_Monitor(md).name), "'\n" ..

	    var register pd : TL_PDpointer := TL_Monitor(md).reEntryQ.head

	     %
	     % print out each process waiting to enter monitor
	     %
	    loop
		TLK.TLKUDMPP(pd)
		pd := TL_Process(pd).monitorQlink
		exit when pd = nil(TL_Process)
	    end loop
	end if

	var register cd	: TL_CDpointer	:= TL_Monitor(md).firstCondition
	loop
	    exit when cd = nil(TL_Condition)

	    var pd : TL_PDpointer := TL_Condition(cd).signalQ.head
	    if pd not= nil(TL_Process) then
		put: 0 , "\n****** Waiting for `", 
				       string@(TL_Condition(cd).name) ..
		 %
		 % an index of 0 indicates a single element condition
		 % else its a member of an array of conditions
		 %
		if TL_Condition(cd).index not= 0 then
		    put : 0, "(", TL_Condition(cd).index, ")'\n" ..
		else
		    put : 0, "'\n" ..
		end if

		 %
		 % print out each process in the conditionQ
		 %
		loop
		    TLK.TLKUDMPP(pd)
		    pd := TL_Process(pd).monitorQlink
		    exit when pd = nil(TL_Process)
		end loop

	    end if

	    cd := TL_Condition(cd).nextCondition

	end loop

	 % unlock monitor
	TLK.TLKLKOFF(TL_Monitor(md).mQLock, x)

	md := TL_Monitor(md).nextMonitor

    end loop

    % unlock linked list
    TLK.TLKLKOFF (TLMMLL,y)
end TLMUDUMP
