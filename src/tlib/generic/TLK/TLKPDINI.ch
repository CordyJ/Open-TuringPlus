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

parent "TLK.bd"

% TLKPDINI (process descriptor initialize)
%  Initialize fields of "pd" to neutral or default values.
%
stub procedure TLKPDINI( pd : TL_PDpointer )

body procedure TLKPDINI
    TL_Process(pd).lineAndFile		:= 0
    TL_Process(pd).fileTable		:= 0
    TL_Process(pd).stackLimit		:= 0
    TL_Process(pd).stackPointer		:= 0
    TL_Process(pd).handlerQhead		:= nil(TL_Handler)
    TL_Process(pd).currentHandler	:= nil(TL_Handler)

    TL_Process(pd).name				:= 0
    TL_Process(pd).exception.quitCode		:= 0
    TL_Process(pd).exception.libraryQuitCode	:= 0
    TL_Process(pd).exception.errorMsg		:= ""

    TL_Process(pd).waitParameter	:= 0
    TL_Process(pd).monitorQlink		:= nil(TL_Process)
    TL_Process(pd).timeOutStatus	:= 0
    TL_Process(pd).pid			:= 0
    TL_Process(pd).memoryBase	 	:= 0
    TL_Process(pd).timeoutTime		:= 0
    TL_Process(pd).timeoutEpoch		:= 0
    TL_Process(pd).timeoutQ.flink	:= nil(TL_Process)
    TL_Process(pd).timeoutQ.blink	:= nil(TL_Process)
    TL_Process(pd).timedOut		:= false
    TL_Process(pd).pausing		:= false
    TL_Process(pd).dispatchPriority	:= defaultPriority
    TL_Process(pd).runQlink		:= nil(TL_Process)
    TL_Process(pd).ready		:= false
    TL_Process(pd).tsyncWaiter		:= nil(TL_Process)
    TL_Process(pd).quantum		:= DefaultQuantum
    TL_Process(pd).quantumCntr	 	:= DefaultQuantum
    TL_Process(pd).devmonLevel		:= 0
    TL_Process(pd).otherInfo		:= 0
end TLKPDINI
