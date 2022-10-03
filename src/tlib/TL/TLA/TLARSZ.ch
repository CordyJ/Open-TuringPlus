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
% pRandSeed	{ predefined procedure randseed(seed:int, seq:1..10) }
%
% Restart the sequence of psuedo random numbers for the specified sequence
%

parent "TLA.ch"

stub procedure TLARSZ (
	    seed	: nat,
	    seqNo	: int
	)

body procedure TLARSZ

    %
    % check validity of seqNo argument
    %
    if (seqNo <= 0) or (seqNo > MaxRandSequence) then
	TLQUIT( "Sequence number " + intstr(seqNo)
			+ "passed to \"randnext\" not in range 1.."
			+ intstr(MaxRandSequence),
		excpIllegalRandSequenceNumber )
    end if

    var value : nat4

    if (seed and 1) ~= 0 then
	value := seed xor 16#a205b064
    else
	value := seed xor 16#bb40de7d
    end if

    %
    % ensure initial random number is an odd number
    %
    if (value and 1) = 0 then
	value += 1
    end if

    TLARS(seqNo) := value

end TLARSZ
