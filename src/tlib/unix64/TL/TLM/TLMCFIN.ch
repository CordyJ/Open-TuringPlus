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
% pConditionFinalize
%

parent "TLM.ch"

stub procedure TLMCFIN ( cd     : TL_CDpointer)

body procedure TLMCFIN
    %
    % remove the condition descriptor from the the monitor's linked list.
    %
    % Assume we are still inside the monitor

#if CHECKED then
    if TL_Condition(cd).signalQ.head ~= nil(TL_Process) then
        TLQUIT( "TLMCFIN: LIBRARY ABORT - Condition queue was not nil",
                 excpConditionBusy )
    end if
#end if

    const next := TL_Condition(cd).nextCondition
    const prev := TL_Condition(cd).prevCondition

    if next ~= nil(TL_Condition) then
        TL_Condition(next).prevCondition := prev
    end if

     % check if at beginning of monitor linked list
     %   
    if prev = nil(TL_Condition) then
        TL_Monitor( TL_Condition(cd).md ).firstCondition := next
    else
        TL_Condition(prev).nextCondition := next
    end if

end TLMCFIN
