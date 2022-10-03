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

#
# TLdata.s
#
#  This file contains the global definitions for TLKPD and TLCPD
#   ( processDescriptorPtr used by TLK and by cinterface)
#  Both these labels must point to the SAME data location
#
    .bss 		# MUST be BSS area, in case we use "as -R"
    .align 8
    .global _TL_TLKPD, _TL_TLCPD
    .global TL_TLKPD, TL_TLCPD

_TL_TLKPD:
_TL_TLCPD:
TL_TLKPD:
TL_TLCPD:
    # allocate 4 or 8 bytes in bss (uninitialized data)
    .int 0,0		# must be 8 bytes for -m64 
