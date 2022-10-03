# Turing+ v6.2, Sept 2022
# Copyright 1986 University of Toronto, 2022 Queen's University at Kingston
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
# AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# TLKCS (context switch)
#  The stack pointer of the new proccess stack is passed as parameter -
#      8(%esp) in 32-bit, %rdi in 64 bit
#  Save the current registers on the current process stack, 
#      switch to the new stack and restore registers.

# Debug registers appear to be privileged, and are not handled
# Floating Point registers are not handled 

	.text
	.align	4
	.global	_TLKCS
	.global	TLKCS

_TLKCS:
TLKCS:

#if UNIX32

	# frame setup
	pushl   %ebp
	movl	%esp, %ebp

	# save the int registers ax bx cx dx di si bp
	pushl  %eax
	pushl  %ebx
	pushl  %ecx
	pushl  %edx
	pushl  %edi
	pushl  %esi
	pushl  %ebp

	# restore new process stack
	movl 8(%ebp), %esp

	# restore the int registers ax bx cx dx di si bp
	popl   %ebp
	popl   %esi
	popl   %edi
	popl   %edx
	popl   %ecx
	popl   %ebx
	popl   %eax

	# return to the new process
	popl   %ebp
	ret

#else /* UNIX64 */

	# frame setup.
	pushq   %rbp
	movq	%rsp, %rbp

	# save the callee save registers ax bx cx dx di si bp
	pushq  %rax
	pushq  %rbx
	pushq  %rcx
	pushq  %rdx
	pushq  %rdi
	pushq  %rsi
	pushq  %r8
	pushq  %r9
	pushq  %r10
	pushq  %r11
	pushq  %r12
	pushq  %r13
	pushq  %r14
	pushq  %r15
	pushq  %rbp

	# restore new process stack
	movq %rdi, %rsp

	# restore the callee save registers ax bx cx dx di si bp
	popq   %rbp
	popq   %r15
	popq   %r14
	popq   %r13
	popq   %r12
	popq   %r11
	popq   %r10
	popq   %r9
	popq   %r8
	popq   %rsi
	popq   %rdi
	popq   %rdx
	popq   %rcx
	popq   %rbx
	popq   %rax

	# return to the new process
	popq   %rbp
	retq

#endif /* M64 */

.Ltd2:
	# .size	TLKCS,.Ltd2-TLKCS
