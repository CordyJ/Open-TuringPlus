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
% pConditionInitialize
%

parent "TLM.ch"

stub procedure TLMCRINI ( name		: addressint,
			  cdArray	: TL_CApointer,
			  cdArraySize	: nat,
			  md		: TL_MDpointer
			)

body procedure TLMCRINI

     %
     % install each condition descriptor separately into 
     % the monitor's linked list.
     %
     % If there is an array of condition descriptors, we install
     % them in reverse index order, so that they are in increasing index
     % order when they are in the linked list.
     %
    for decreasing i : cdArraySize .. 1
	bind var register cd to TL_ConditionArray(cdArray)(i)
	cd.signalQ.head	:= nil(TL_Process)
	cd.signalQ.tail	:= nil(TL_Process)
	cd.md		:= md
	 %
	 % if single element (non-array) condition variable,
	 % then set index to 0
	 %
	if cdArraySize = 1 then
	    cd.index 	:= 0
	else
	    cd.index 	:= i
	end if
	cd.name		:= name
	cd.nextCondition	:= TL_Monitor(md).firstCondition
	cd.prevCondition	:= nil(TL_Condition)

	TL_Monitor(md).firstCondition := type ( TL_CDpointer, addr(cd) )

	if cd.nextCondition not= nil(TL_Condition) then
	    TL_Condition(cd.nextCondition).prevCondition
					:= type (TL_CDpointer, addr(cd))
	end if
    end for

end TLMCRINI
