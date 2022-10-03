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
% pOpenFile
%

parent "TLI.ch"

stub procedure TLIOF (
	    openMode	: StreamModeSet,
	    fileName	: string,
	var streamNo	: int
	)

body procedure TLIOF

    streamNo := 0

    begin
	var firstStream : Cint := TLIARC+1
	if firstStream > maxargfiles+1 then
	    firstStream := maxargfiles+1
	end if

	for decreasing sn : maxstream .. firstStream
	    bind register streamMode to TLIS(sn).mode

	    if (streamMode = StreamModeSet())
		    or (IoClosedMode in streamMode) then
		%
		% Found an empty stream descriptor.
		%
		streamNo := sn
		exit
	    end if
	end for
	if streamNo = 0 then
	    %
	    % No empty stream descriptor.
	    %
	    return
	end if
    end

    begin
	%
	% Save the file name in the stream entry.
	%
	bind var streamName to TLIS(streamNo).fileName
	const nameLength := length(fileName)

	TLB.TLBMAL (nameLength + 1, streamName)
	if streamName = 0 then
	    streamNo := 0
	    return
	end if

	var register dst	: addressint	:= streamName
	var register src	: addressint	:= addr(fileName)
	const lastAddr		: addressint	:= addr(fileName) + nameLength

	loop
	    exit when src >= lastAddr
	    char@(dst) := char@(src)
	    dst += 1
	    src += 1
	end loop
	char@(dst) := '\0'
    end

    const sn := streamNo

    TLIOS (streamNo, openMode, false)
    if streamNo = 0 then
	TLB.TLBMFR (TLIS(sn).fileName)
    end if

end TLIOF
