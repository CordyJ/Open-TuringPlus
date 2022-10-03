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

/* execute uninitialization pattern */

parent "TLB.ch"

stub procedure TLBUNR (
		var variable	: addressint,
		var pattern	: addressint,
		    count	: int
		    )
body procedure TLBUNR
    const opcodeStart : addressint := pattern
    const register op : OpcodeType := OpcodeType@(pattern)
    var opCount : nat4

    /* recover the count for the instruction */
    case bits(op, CountTypeBits) of
	label CountNull:
	    opCount := 0
	    pattern += size(OpcodeType)

	label CountByte:
	    opCount := bits(op, CountByteBits)
	    pattern += size(OpcodeType)

	label CountWord:
	    opCount := nat2@(pattern + size(OpcodeType))
	    pattern += 2 * size(OpcodeType)

	label CountLong:
	    opCount := (nat2@(pattern + size(OpcodeType)) shl 16) +
			nat2@(pattern + 2 * size(OpcodeType))
	    pattern += 3 * size(OpcodeType)
    end case

    /* now execute the opcode */
    case bits (op, OpcodeBits) of
	label Skip:
	    /* pass over opCount bytes */
	    variable += opCount

	label Begin:
	    loop
		exit when bits(OpcodeType@(pattern), OpcodeBits) = End
		TLBUNR (variable, pattern, 0)
	    end loop
	    /* skip End */
	    pattern += size (OpcodeType)

	label End:
	    /* can't get here! */
	    assert false

	label Repeat:
	    if opCount = 0 then
		opCount := count
	    end if
	    const origPattern : addressint := pattern
	    for : 1 .. opCount
		pattern := origPattern
		TLBUNR (variable, pattern, 0)
	    end for

	label Call:
	    assert bits(op, CountTypeBits) not= CountNull
	    var subPattern : addressint := opcodeStart - opCount
	    TLBUNR (variable, subPattern, 0)

	label UInt:
	    assert opCount = 4
	    nat4@(variable) := 16#80000000
	    type t : int
	    variable += size(t)

	label UNat:
	    assert opCount = 4
	    nat4@(variable) := 16#FFFFFFFF
	    type t : nat
	    variable += size(t)

	label UReal:
	    /* assume reals are 2 ints long! */
	    assert opCount = 8
	    nat4@(variable) := 16#80000000
	    type t : int
	    variable += size(t)
	    nat4@(variable) := 16#80000000
	    variable += size(t)

	label UBoolean:
	    assert opCount = 1
	    int1@(variable) := -1
	    type t : boolean
	    variable += size(t)

	label USet:
	    case opCount of
		label 1:
		    nat1@(variable) := 16#80
		
		label 2:
		    nat2@(variable) := 16#8000

		label 4:
		    nat4@(variable) := 16#80000000

		label :
	    end case
	    variable += opCount

	label UString:
	    nat1@(variable) := 16#80
	    nat1@(variable+1) := 0
	    assert opCount <= 256
	    variable += opCount

	label UPointer:
	    if opCount = 8 then
		/* checked pointer */
		type t : addressint

		addressint@(variable) := UninitPointerValue
		variable += size(t)
		addressint@(variable) := 0
		variable += size(t)
	    else
		assert opCount = 4
		addressint@(variable) := UninitPointerValue
		type t : addressint
		variable += size(t)
	    end if
    end case
end TLBUNR
