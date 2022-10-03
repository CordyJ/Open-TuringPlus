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

% TLKTQI
%  Insert a process descriptor into the timeout queue in the position
%  specified by its timeout interval.
%
stub procedure TLKTQI ( pd : TL_PDpointer, timeInterval : nat )

body procedure TLKTQI
    TL_Process(pd).timedOut := false

    if timeInterval = 0 then
	TL_Process(pd).timedOut := true
	return
    end if

    % 'timeoutTime' field in each process on timeoutQ contains
    % absolute time when to wake up.
    % The TLKTIME variable keeps track of the absolute time.

    var register dispatchTime : nat   := timeInterval + TLKTIME

    var register next : TL_PDpointer
    var register last : TL_PDpointer := nil(TL_Process)

    % -- check for overflow
    var nextEpoch := false
    if (dispatchTime < TLKTIME) then
	% -- dispatchTime is in next epoch 
	next := TLKTQ2H
	nextEpoch := true
    else 
	% -- dispatchTime is in current epoch
	next := TLKTQH
    end if

    % -- find correct insertion point on queue headed by "next".
    loop
	exit when (next = nil(TL_Process))
		or (dispatchTime < TL_Process(next).timeoutTime)
	last := next
	next := TL_Process(next).timeoutQ.flink
    end loop

    TL_Process(pd).timeoutQ.flink := next
    TL_Process(pd).timeoutQ.blink := last

    if last ~= nil(TL_Process) then
	TL_Process(last).timeoutQ.flink := pd
    elsif nextEpoch then
	TLKTQ2H := pd
    else
	TLKTQH := pd
    end if

    if next ~= nil(TL_Process) then
	TL_Process(next).timeoutQ.blink := pd
    end if

    TL_Process(pd).timeoutTime := dispatchTime
    if nextEpoch then
	TL_Process(pd).timeoutEpoch := TLKEPOCH + 1
    else
	TL_Process(pd).timeoutEpoch := TLKEPOCH
    end if
end TLKTQI
