% Turing+ implementation of the Turing standard character screen operations
% J.R. Cordy, Queen's University
% February 2016 (Rev June 2020)

% Include this file and compile with thasch.c, for example:
% tpc life.t thasch.c

% Screen Modes
const NORMAL := 1
const GAME := -1  	
const ECHO := 2   	
const NOECHO := -2  	
const CURSOR := 3   	
const NOCURSOR := -3  	
const NORMALINPUT := 4	
const KEYINPUT := -4  	
const MAPCRNL := 5   	
const NOMAPCRNL := -5  	

% Color Codes
const BLACK := 0
const RED := 1
const GREEN := 2
const BROWN := 3
const BLUE := 4
const MAGENTA := 5
const CYAN := 6
const WHITE := 7
const CLEAR := 8

% Color shifts
const FOREGROUND := 30
const BACKGROUND := 40

% Escape character
const ESC := chr (27)

% Arrow key codes
const UPARROW := chr (24)
const DOWNARROW := chr (25)
const RIGHTARROW := chr (26)
const LEFTARROW := chr (27)


procedure setscreen (mode: int)
    external procedure system (command: string)

    case mode of
	label NORMAL:
	    system ("stty sane")
	label GAME:
	    system ("stty cbreak -echo")
	label ECHO:
	    system ("stty echo")
	label NOECHO:
	    system ("stty -echo")
	label CURSOR:
	label NOCURSOR:
	label NORMALINPUT:
	    system ("stty -cbreak")
	label KEYINPUT:
	    system ("stty cbreak")
	label MAPCRNL:
	    % ignore in Linux
	label NOMAPCRNL:
	    % ignore in Linux
	label:
	    put:0, "***ERROR: setscreen(): no such mode"
	    quit:99
    end case
end setscreen

procedure getscreen (var rows, cols : int)
    external function trows : int 
    external function tcols : int 
    rows := trows
    cols := tcols
end getscreen

procedure cls
    put ESC, "[0m" ..
    put ESC, "[2J" ..
    put ESC, "[;H" ..
end cls

procedure locate (row, col: int)
    var lrow := row
    if lrow < 0 then lrow := 0 end if
    var lcol := col
    if lcol < 0 then lcol := 0 end if
    put ESC, "[" ..
    put lrow, ";", lcol ..
    put "H" ..
end locate

procedure getch (var ch: string (1))
    get ch:1

    if ch = "\e" then
	% ANSI arrow key escape codes
        get ch:1
        get ch:1

	case ord (ch) of
	    label ord ("A") :
		ch := UPARROW
	    label ord ("B") :
		ch := DOWNARROW
	    label ord ("C") :
		ch := RIGHTARROW
	    label ord ("D") :
		ch := LEFTARROW
	    label :
	end case
    end if
end getch

function hasch : boolean
    external function thasch : boolean
    result thasch
end hasch

procedure color (c: int)
    if c = CLEAR then
        put ESC, "[0m" ..
    else
        put ESC, "[", FOREGROUND + c, "m" ..
    end if
end color

procedure colorback (c: int)
    if c = CLEAR then
        put ESC, "[0m" ..
    else
        put ESC, "[", BACKGROUND + c, "m" ..
    end if
end colorback

procedure delay (ms: int)
    external procedure usleep (us: int)
    external "TL_TLI_TLIFS" procedure flushstreams
    flushstreams
    usleep (ms * 1000)
end delay

cls
