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

% TLKPRUN (process run)
%  Perform operations normally done after call to "contextSwap" in TLKRQD,
%  run the user thread, then terminate it.
%
%  This routine is the first thing that is called when a process starts up.
%  A process can only execute if it is started up by "contextSwap".
%
stub procedure TLKPRUN ( func : addressint,
		         p1   : addressint,
		         p2   : addressint,
		         p3   : addressint )

body procedure TLKPRUN

    % -- This routine is dispatched by a retq in TLKCS.s
    % -- with a fake call environment created in TLKPFORK.ch
    % -- on entry, x64 registers should be as follows:
#if CYGWIN then
    % -- %rcx - address of process routine
    % -- %rdx - parameter 1 of process routine call
    % -- %r8  - parameter 2 of process routine call
    % -- %r9  - parameter 3 of process routine call
#else
    % -- %rdi - address of process routine
    % -- %rsi - parameter 1 of process routine call
    % -- %rdx - parameter 2 of process routine call
    % -- %rcx - parameter 3 of process routine call
#endif /* CYGWIN */

    % -- call the new process's code
    TLKPC += 1
     type ThreadProc: procedure thread(p1,p2,p3: nat)
     ThreadProc@(func)(p1,p2,p3)
    TLKPC -= 1

    % -- The next process to run will free our memory.
    TL_Process(TLKPD).runQlink := TLKFQH
    TLKFQH := TLKPD

    % -- Now dispatch another process.
    TL_Process(TLKPD).ready := false
    TLKRQD

    % -- since current process is not put in runQ or any wake-up queue,
    % -- it will never get run again.
    /* NOT REACHED */
end TLKPRUN
