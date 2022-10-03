% Turing Plus Life - the game of Life 
% Norm Sanford, Chris Lewis, Jim Cordy
% Computer Systems Research Group, University of Toronto
% December 1981 (Rev June 2020)

% Turing Plus terminal graphics
include "include/screen.i"

% Editing commands
const UP :=    UPARROW
const DOWN :=  DOWNARROW
const LEFT :=  LEFTARROW
const RIGHT := RIGHTARROW
const HOME :=  'h'
const INS :=   ' '
const DEL :=   'd'

% Maximum terminal size
const maxYsize := 60
const maxXsize := 300

% Visible terminal size
var xSize, ySize : int
% const ySize := 38
% const xSize := 118

% Active screen limits
var xMin, xMax : int
var yMin, yMax : int

% Current and previous screen state
var screen : array 0 .. maxXsize of array 0 .. maxYsize of boolean
var oldscreen : array 0 .. maxXsize of array 0 .. maxYsize of boolean

% Next input character
var ch : string (1) := "z"

var gen, live : int


procedure InitScreen
    var x : int
    var y : int

    cls
    locate (1, 1)
    color (BLACK)
    colorback (CYAN)
    put repeat (" ", xSize + 1)
    const message := " TURING PLUS LIFE "
    locate (1, (xSize - length (message)) div 2)
    put message ..

    y := 1
    loop
	exit when y > ySize

	locate (y, 1)
	put " " ..
	locate (y, xSize + 1)
	put " " ..

	x := 0
	loop
	    exit when x > xSize
	    screen (x) (y) := false
	    x := x + 1
	end loop
	y := y + 1
    end loop

    xMin := xSize
    xMax := 0
    yMin := ySize
    yMax := 0

    locate (ySize + 1, 1)
    put repeat (" ", xSize + 1)
    const instructions := " SP - create   D - delete   G - go   S - stop   N - new   Q - quit "
    locate (ySize + 1, (xSize - length (instructions)) div 2)
    put instructions ..

    live := 0

end InitScreen

procedure Move (y : int, x : int)
    locate (y + 1, x + 1)
end Move

procedure Change (y : int, x : int)
    if screen (x) (y) then
	color (CLEAR)
	colorback (gen mod 7 + 1)
	put " " ..
    else
	color (CLEAR)
	put " " ..
    end if

    if x < xMin then
	xMin := x
    end if
    if x > xMax then
	xMax := x
    end if

    if y < yMin then
	yMin := y
    end if
    if y > yMax then
	yMax := y
    end if

end Change

procedure Enter
    const xhome := xSize div 2
    const yhome := ySize div 2

    var x := xhome
    var y := yhome

    loop
	Move (y, x)

	getch (ch)

	exit when ch = "n" or ch = "g" or ch = "q"

	case chr (ord (ch)) of
	    label UP :
		if y > 1 then
		    y := y - 1
		end if
	    label DOWN :
		if y < ySize - 1 then
		    y := y + 1
		end if
	    label LEFT :
		if x > 1 then
		    x := x - 1
		end if
	    label RIGHT :
		if x < xSize - 1 then
		    x := x + 1
		end if
	    label DEL :
		if screen (x) (y) then
		    live -= 1
		end if
		screen (x) (y) := false
		Change (y, x)
		if x > 1 then
		    x := x - 1
		end if
	    label INS :
		if not screen (x) (y) then
		    live += 1
		end if
		screen (x) (y) := true
		Change (y, x)
		if x < xSize - 1 then
		    x := x + 1
		end if
	    label HOME :
		x := xhome
		y := yhome
	    label :
	end case
    end loop
end Enter

procedure Play
    var x : int
    var y : int
    var c : int

    var xStart : int
    var xEnd : int

    var yStart : int
    var yEnd : int

    gen := 0

    loop
	Move (0, 0)

	delay (250)	% 1/4 sec per generation

	if xMin - 1 >= 1 then
	    xStart := xMin - 1
	else
	    xStart := 1
	end if
	if xMax + 1 < xSize - 1 then
	    xEnd := xMax + 1
	else
	    xEnd := xSize - 1
	end if

	if yMin - 1 >= 1 then
	    yStart := yMin - 1
	else
	    yStart := 1
	end if
	if yMax + 1 < ySize - 1 then
	    yEnd := yMax + 1
	else
	    yEnd := ySize - 1
	end if

	oldscreen := screen

	Move (1, 1)

	gen := gen + 1

	color (CLEAR)
	put "  Gen ", gen : 5, "  Pop ", live : 5, " "  ..

	exit when live = 0

	var change := false

	y := yStart
	loop
	    x := xStart
	    loop
		begin
		    bind leftcol to oldscreen (x - 1),
			midcol to oldscreen (x),
			rightcol to oldscreen (x + 1)
		    c := 0

		    if leftcol (y - 1) then
			c := c + 1
		    end if
		    if midcol (y - 1) then
			c := c + 1
		    end if
		    if rightcol (y - 1) then
			c := c + 1
		    end if
		    if leftcol (y) then
			c := c + 1
		    end if
		    if rightcol (y) then
			c := c + 1
		    end if
		    if leftcol (y + 1) then
			c := c + 1
		    end if
		    if midcol (y + 1) then
			c := c + 1
		    end if
		    if rightcol (y + 1) then
			c := c + 1
		    end if
		end 

		begin
		    const osxy : boolean := oldscreen (x) (y)
		    var sxy : boolean

	    	    if c = 3 then
			sxy := true
		    elsif c = 2 then
			sxy := osxy
		    else
			sxy := false
		    end if

		    if sxy not= osxy then
			if osxy then
			    live -= 1
			else
			    live += 1
			end if
			screen (x) (y) := sxy
			Move (y, x)
			Change (y, x)
			change := true
		    end if
		end 

		x := x + 1

		exit when x > xEnd
	    end loop

	    y := y + 1

	    exit when y > yEnd
	end loop

	exit when hasch or not change 
    end loop

    loop
	exit when not hasch
	getch (ch)
    end loop

    ch := HOME
end Play


% Main program
var rows, cols : int
getscreen (rows, cols)

% Leave two rows and two cols for the borders
xSize := min (cols - 2, maxXsize)
ySize := min (rows - 2, maxYsize)

% Put terminal in game mode (key input, no echo)
setscreen (GAME)

InitScreen
loop
    Enter

    exit when ch = "q"

    if ch = "g" then
	Play
    elsif ch = "n" then
	InitScreen
    end if
end loop

% Reset terminal
setscreen (NORMAL)
cls
