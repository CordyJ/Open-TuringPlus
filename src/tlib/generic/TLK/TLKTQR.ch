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

% TLKTQR
%  Remove a process from the timeout queue and set pd.timedOut false.
%
stub procedure TLKTQR ( pd : TL_PDpointer )

body procedure TLKTQR
    var register next: TL_PDpointer := TL_Process(pd).timeoutQ.flink
    var register last: TL_PDpointer := TL_Process(pd).timeoutQ.blink

    if next ~= nil(TL_Process) then
	TL_Process(next).timeoutQ.blink := last
    end if
    if last ~= nil(TL_Process) then
	TL_Process(last).timeoutQ.flink := next
    elsif TLKTQ2H = pd then
	TLKTQ2H := next
    else
	TLKTQH := next
    end if

    TL_Process(pd).timeoutQ.flink := nil(TL_Process)
    TL_Process(pd).timeoutQ.blink := nil(TL_Process)
    TL_Process(pd).timeoutTime    := 0
    TL_Process(pd).timedOut       := false
end TLKTQR
