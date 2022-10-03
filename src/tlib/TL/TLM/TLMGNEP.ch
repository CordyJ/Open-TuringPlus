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
% procedure TLMGNEP
%  - get next process from monitor entryQ or reEntryQ.
%   (called from TLMREXT, TLMCPWT, TLMCRWT, TLMCTWT)
%

parent "TLM.ch"


stub procedure TLMGNEP (     md : TL_MDpointer,
			  var pd : TL_PDpointer )


body procedure TLMGNEP 

      %
      % if both entry queues are empty, then pd = nil
      %
    if TL_Monitor(md).entryQ.head = nil(TL_Process)
       and  TL_Monitor(md).reEntryQ.head = nil(TL_Process) then
	  %
          % there is no-one waiting to get into the monitor
	  %
	pd := nil(TL_Process)
    else
	 %
	 % check reEntryQ first 
	 %  - allow these processes to enter before those on entryQ
	 %
	if TL_Monitor(md).reEntryQ.head not= nil(TL_Process) then
	     % 
	     % remove 1st process from reEntryQ.
	     % This process will have access to the monitor
	     %
	    pd := TL_Monitor(md).reEntryQ.head
	    TL_Monitor(md).reEntryQ.head := TL_Process(pd).monitorQlink
	else
	     % 
	     % remove 1st process from entryQ.
	     % This process will have access to the monitor
	     %
	    pd := TL_Monitor(md).entryQ.head
	    TL_Monitor(md).entryQ.head := TL_Process(pd).monitorQlink
	end if

	TL_Process(pd).monitorQlink := nil(TL_Process)
    end if

end TLMGNEP
