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
% pInitializeDeviceMonitor
%
% Currently identical to regular monitors.
%

parent "TLM.ch"

stub procedure TLMDINI ( register md	 : TL_MDpointer,
			  name		 : addressint,
			  devicePriority : int         % T+ spec says int
		        )

body procedure TLMDINI

      %
      % Call regular monitor init routine
      % so conditions, signal and waits are properly handled
      %
    TLMRINI(md, name)

     %
     % check validity of devicePriority.
     %
    if not TLK.TLKDMINI(devicePriority) then
	TLQUIT(  "Device monitor '" + string@(name)
	        + "' has invalid priority level ("
	        + intstr(devicePriority) + ")",
	         excpDevMonInvalidLevel )
    end if

     % save the priority, but I don't know if we'll use it.
     % - since compiler passes the same value to all other 
     % device monitor/interrupt related actions.
     %
    TL_Monitor(md).monitorPriority := devicePriority
    TL_Monitor(md).deviceMonitor := true

end TLMDINI
