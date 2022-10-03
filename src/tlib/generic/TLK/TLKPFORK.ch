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

% TLKPFORK (process fork)
%  routine to fork a new process
%
% NOTE:
%  This routine uses a variable number of arguments.
%  (this is a poor mans varargs)
%
% Typical call:
%     TL_TLK_TLKPFORK((TLint4) 0, "hi", hi, (TLaddressint *) 0, (TLint4) 10000, (TLboolean *) 0);
%

stub procedure TLKPFORK (
			paramSize	: nat,
			name		: addressint,
			procAddress	: addressint,
			forkAddress	: addressint,
			stackSize	: nat,
			forkStatus	: addressint,
			p1		: addressint,
			p2		: addressint,
			p3		: addressint )

body procedure TLKPFORK
    var memoryBase : addressint
    var stackBytes : nat

    % -- check that num parameters is 3 or less
#if UNIX32 then 
    if paramSize > 3*4 then
#else /* UNIX64 */ 
    if paramSize > 3*8 then		
#endif 
	if forkStatus ~= 0 then
	    boolean@(forkStatus) := false
	    return
	else
	    TL_Process(TLKPD).exception.errorMsg := 
	      "Process " + string@(name) + " too many parameters"
	    TL_Process(TLKPD).exception.quitCode := excpProcessForkFailed
	    quit : excpProcessForkFailed
	end if
    end if

    % -- Round stack size up to 16-byte boundary.
    stackBytes := (stackSize + 15) and 16#fffffff0

    % -- Allocate memory for the stack.
    TLB.TLBMAL (ExtraStack+stackBytes+size(TL_ProcessDescriptor), memoryBase)

    if memoryBase = 0 then
	if forkStatus ~= 0 then
	    boolean@(forkStatus) := false
	    return
	else
	    TLQUIT ("Cannot fork "+string@(name), excpProcessForkFailed)
	end if
    end if

    var register sp: addressint	:= memoryBase + ExtraStack + stackBytes

    % T.D. At the point of a function call, the stack must be 16 byte
    % aligned. They use the MMU to enforce this, causing 
    % a EXC_BAD_ACCESS (code=EXC_I386_GPFLT)  Based on what we have
    % for our context switch, we have to adjust the stack pointer so
    % that the fake return address (offset 9*4) is on a 16 byte boundary. 
    % so we start by making sure that we are on a 16 byte boundary and
    % subtract 4.

    #if UNIX32 then
        sp := (sp and 16#fffffff0) - 4 
    #else /* UNIX64 */
        var mask: addressint
        mask := 16#ffffffff 
        mask := mask * 65536	% (sic) unsigned shl 16
        mask := mask * 65536	% (sic) unsigned shl 32
        mask := mask + 16#fffffff0
        sp := sp and mask 
        sp := sp - 16
    #endif

    % -- The process descriptor starts at the bottom of the stack.
    const pd : TL_PDpointer := type(TL_PDpointer, sp)

    %
    % Make a dummy stack frame for context switch.  The TLKXCS routine (in
    % TLKASP.s) depends on this format. 
    % Data is a follows:

#if UNIX32 then
    %	offset	contents
    %   ======  ========
    %   0*4	%ebp for TLKCS   -----|     Stack
    %   1*4	%esi for TLKCS (0)    |	    frame
    %   2*4	%edi for TLKCS (0)    |	    for
    %   3*4	%edx for TLKCS (0)    |	    TLKCS
    %   4*4	%ecx for TLKCS (0)    |
    %   5*4	%ebx for TLKCS (0)    |
    %   6*4	%eax for TLKCS (0)    |
    % |-7*4	%ebp saved context <---
    const savedContextBP := 7*4
    % | 8*4     addr(runThread)	       address invoked by TLKCS.ret
    const threadAddress := 8*4
    % | 9*4	fake return address    as if entering runThread from elsewhere
    % | 10*4	func 		(runThread ins & runThread caller outs)
    const parm0 := 10*4
    % | 11*4	parm1
    const parm1 := 11*4
    % | 12*4	parm2
    const parm2 := 12*4
    % | 13*4	parm3
    const parm3 := 13*4
    % | 14*4	parm4
    const parm4 := 14*4
    % | 15*4	parm5
    const parm5 := 15*4
    % |	16*4	CALL1	part of call linkage for runThread call
    % |	17*4	CALL2	part of call linkage for runThread call
    % |	18*4	CALL3	part of call linkage for runThread call
    % ->19*4	fake saved ebp for caller of runThread
    const fakeSavedBP := 19*4
    %   20*4    fake return address for caller of runThread

    const framesize := 21
    const entrysize := 4

#else /* UNIX64 */

    %	offset	contents
    %   ======  ========
    %   0*8	%rbp for TLKCS   -----| 
    %   1*8	%r15 for TLKCS (0)    |     Stack
    %   2*8	%r14 for TLKCS (0)    |     frame
    %   3*8	%r13 for TLKCS (0)    |     for
    %   4*8	%r12 for TLKCS (0)    |     TLKCS
    %   5*8	%r11 for TLKCS (0)    |     
    %   6*8	%r10 for TLKCS (0)    |    
    %   7*8	%r9  for TLKCS (0)    |   
    const r9 := 7*8
    %   8*8	%r8  for TLKCS (0)    |  
    const r8 := 8*8
    %   9*8	%rsi for TLKCS (0)    |
    const rsi := 9*8
    %   10*8	%rdi for TLKCS (0)    |	    
    const rdi := 10*8
    %   11*8	%rdx for TLKCS (0)    |	   
    const rdx := 11*8
    %   12*8	%rcx for TLKCS (0)    |
    const rcx := 12*8
    %   13*8	%rbx for TLKCS (0)    |
    %   14*8	%rax for TLKCS (0)    |
    % |-15*8	%rbp saved context <---
    const savedContextBP := 15*8
    % | 16*8    addr(runThread)	    	address invoked by TLKCS.ret
    const threadAddress := 16*8
    % | 17*8	fake return address   	as if entering runThread from elsewhere
    % ->18*8	fake saved ebp for caller of runThread
    const fakeSavedBP := 18*8
    %   19*8    fake return address for caller of runThread

#if CYGWIN then
    % MS Windows calling convention
    const parm0 := rcx
    const parm1 := rdx
    const parm2 := r8
    const parm3 := r9
    % const parm4 := r8
    % const parm5 := r9
#else
    % Linux / MacOSX calling convention
    const parm3 := rcx
    const parm2 := rdx
    const parm5 := r9
    const parm4 := r8
    const parm1 := rsi
    const parm0 := rdi
#endif /* CYGWIN */

    const framesize := 20
    const entrysize := 8

#endif 

    % Reserve stack frame
    sp -= framesize * entrysize

    % Zero all entries
    for w: 0 .. framesize - 1
	var spw : addressint := sp
	spw += w * entrysize
	addressint@(spw) := 0
    end for

    % Store process routine address as 0'th parameter to "runThread".
    addressint@(sp + parm0) := procAddress

    % Store process parameters
    addressint@(sp + parm1) := p1
    addressint@(sp + parm2) := p2
    addressint@(sp + parm3) := p3

    % Store fake return address to invoke TLKPRUN thread
    addressint@(sp + threadAddress) := addr(TLKPRUN)

    % setup frame chain
    addressint@(sp) := sp + savedContextBP
    addressint@(sp + savedContextBP) := sp + fakeSavedBP

    % -- initialize the new process descriptor
    TLKPDINI(pd)
    TL_Process(pd).fileTable		:= TL_Process(TLKPD).fileTable
    TL_Process(pd).stackLimit		:= memoryBase + ExtraStack
    TL_Process(pd).stackPointer		:= sp
    TL_Process(pd).name			:= name
    TL_Process(pd).memoryBase	 	:= memoryBase
    TL_Process(pd).dispatchPriority	:= TL_Process(TLKPD).dispatchPriority
    TL_Process(pd).devmonLevel		:= TL_Process(TLKPD).devmonLevel

    if not TLKMULTI then
	% -- turn on asynch. I/O
	TLI.TLIAON
	TLKMULTI := true
    end if

    % -- Set the return parameters.
    if forkAddress ~= 0 then
	TL_PDpointer@(forkAddress) := pd
    end if
    if forkStatus ~= 0 then
	boolean@(forkStatus) := true
    end if

    % -- put the new process on the run queue
    TLKRQI(pd) 

    % -- do a resched to allow the new process to run first
    % -- (it might want to setpriority)
    TLKRQI(TLKPD)
    TLKRQD

end TLKPFORK
