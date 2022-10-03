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
% Get next token
%

parent "TLI.ch"

stub procedure TLIGT (
	    streamNo	: int2,
	var token	: string
	)

body procedure TLIGT

    bind var register stream to TLIS(streamNo)

#if CHECKED then
    if stream.atEof then
	TLQUIT( "Attempt to read past eof", excpReadPastEof )
    end if
#end if

    var register dst	: addressint	:= addr(token)
    const lastAddr	: addressint	:= dst + upper(token)
    var register ch	: Cint

    loop
	ch := TLIFGC(stream.info)
	#if CHECKED then
	    if ch = EndOfFileChar then
		stream.atEof := true
		TLQUIT( "Attempt to read past eof", excpReadPastEof )
	    end if
	#end if
	exit when (ch ~= #' ') and (ch ~= #'\t') and (ch ~= #'\n')
		and (ch ~= #'\f')
    end loop

    loop
	if (ch and 16#7F) = 0 then
	    TLQUIT( "Illegal character in string", excpGetItemIllegal )
	end if

	char@(dst) := chr(ch)
	dst += 1

	ch := TLIFGC(stream.info)
	if ch = EndOfFileChar then
	    stream.atEof := true
	    char@(dst) := '\0'
	    return
	end if
	exit when (ch = #' ') or (ch = #'\t') or (ch = #'\n') or (ch = #'\f')

	if dst >= lastAddr then
	    TLQUIT( "Input item too large", excpGetItemIllegal )
	end if
    end loop
    char@(dst) := '\0'

    %
    % Flush remaining whitespace up to next token or end of line.
    %
    if ch ~= #'\n' then
	loop
	    ch := TLIFGC(stream.info)
	    if ch = EndOfFileChar then
		stream.atEof := true
		return
	    end if
	    exit when (ch ~= #' ') and (ch ~= #'\t') and (ch ~= #'\f')
	end loop
	if ch ~= #'\n' then
	    TLIFUG (ch, stream.info)
	end if
    end if

end TLIGT
