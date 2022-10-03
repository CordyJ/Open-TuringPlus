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
% pGetString
%

parent "TLI.ch"

stub procedure TLIGS (
	    itemSize	: int,
	    getItem	: addressint,
	    streamNo	: int2
	)

body procedure TLIGS

    bind var register stream to TLIS(streamNo)

    var register dst	: addressint	:= getItem
    const lastAddr	: addressint	:= dst + itemSize

#if CHECKED then
    if stream.atEof then
	char@(dst) := '\0'
	TLQUIT( "Attempt to read past eof", excpReadPastEof )
    end if
#end if

    var register ch : Cint

    loop
	ch := TLIFGC(stream.info)
	#if CHECKED then
	    if ch = EndOfFileChar then
		stream.atEof := true
		char@(dst) := '\0'
		TLQUIT( "Attempt to read past eof", excpReadPastEof )
	    end if
	#end if
	exit when (ch ~= #' ') and (ch ~= #'\t') and (ch ~= #'\n')
		and (ch ~= #'\f')
    end loop

    if ch = #'\"' then
	%
	% Quoted string
	%
	loop
	    ch := TLIFGC(stream.info)

	    exit when ch = #'\"'

	    if (ch = #'\n') or (ch = EndOfFileChar) then
		if ch = EndOfFileChar then
		    stream.atEof := true
		end if
		char@(dst) := '\0'
		TLQUIT( "No terminating quote for quoted string",
			excpGetItemIllegal )
	    end if
	    if dst >= lastAddr then
		char@(dst) := '\0'
		TLQUIT( "Quoted string too large for string variable",
			excpGetItemIllegal )
	    end if
	    if ch = #'\\' then
		ch := TLIFGC(stream.info)
		if ch = EndOfFileChar then
		    stream.atEof := true
		    char@(dst) := '\0'
		    TLQUIT( "Unexpected end-of-file", excpGetItemIllegal )
		else
		    case chr(ch) of
			label '\"', '\'', '\\', '\^':
			label '0':	ch := #'\0'
			label 'b', 'B':	ch := #'\b'
			label 'd', 'D':	ch := #'\d'
			label 'e', 'E':	ch := #'\e'
			label 'f', 'F':	ch := #'\f'
			label 'n', 'N':	ch := #'\n'
			label 'r', 'R':	ch := #'\r'
			label 't', 'T':	ch := #'\t'
			label :
			    TLQUIT( "Illegal extended char '\\" + chr(ch) + "'",
				    excpGetItemIllegal )
		    end case
		end if
	    elsif ch = #'\^' then
		ch := TLIFGC(stream.info)
		if ch = EndOfFileChar then
		    stream.atEof := true
		    char@(dst) := '\0'
		    TLQUIT( "Unexpected end-of-file", excpGetItemIllegal )
		end if
		if ch = #'?' then
		    % ^? => delete
		    ch := #'\d'
		else
		    ch and= 16#1F
		end if
	    elsif (ch and 16#7F) = 0 then
		char@(dst) := '\0'
		TLQUIT( "Illegal character in string", excpGetItemIllegal )
	    end if

	    char@(dst) := chr(ch)
	    dst += 1
	end loop

    else
	%
	% Unquoted token
	%
	loop
	    if (ch and 16#7F) = 0 then
		char@(dst) := '\0'
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
	    exit when (ch = #' ') or (ch = #'\t') or (ch = #'\n')
		    or (ch = #'\f')
	    if dst >= lastAddr then
		char@(dst) := '\0'
		TLQUIT( "Input string too large for string variable",
			excpGetItemIllegal )
	    end if
	end loop
    end if

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

end TLIGS
