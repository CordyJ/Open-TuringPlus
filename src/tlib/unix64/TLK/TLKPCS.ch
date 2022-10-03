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

% TLKPCS (process context swap)
%  Process swap. (Between process at head of local runQ and TLKPD)
%  All processes (including forking processes) must release control 
%  through this routine.
%
%  Note: The process startup (TLKPRUN) must know the stack context this
%  procedure sets up rather intimately, since it attempts to imitate it
%  for proper initial dispatch.  So take extreme care when changing the
%  number of parameters and local variables!
%
stub procedure TLKPCS

body procedure TLKPCS
    % pre: TLKRQH is non-nil (e.g runQ is not empty)
    % pre: intrs_off

    TL_Process(TLKPD).stackPointer := TLKSP
    #if UNIX64 then
	% minus size of saved stuff - (rbp + r15-r8 + r[sd]i + r[dcba]x + new rbp)
	- (8 + 8*8 + 2*8 + 4*8 + 8)
    #endif 

    % -- now initialize TLKPD to point to first process on local runQ
    % -- and remove the PD from the runQ
    TLKPD := TLKRQH
    TLKRQH := TL_Process(TLKRQH).runQlink
    TL_Process(TLKPD).runQlink := nil(TL_Process)

    % -- TLKPRUN is dispatched by a retq in TLKCS.s
    % -- with a fake call environment created in TLKPFORK.ch
    % -- on entry, its registers should be as follows:
    % -- %rdi - address of process routine
    % -- %rsi - parameter 1 of process routine call
    % -- %rdx - parameter 2 of process routine call
    % -- %rcx - parameter 3 of process routine call
    % -- %r8  - parameter 4 of process routine call
    % -- %r9  - parameter 5 of process routine call

    TLKCS(TL_Process(TLKPD).stackPointer)

end TLKPCS
