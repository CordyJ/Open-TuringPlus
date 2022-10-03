% Turing Demonstration Program          
% Robot-Killers game
% Stephen Perelgut & J.R. Cordy - May 1985

randomize

include "include/screen.i"

setscreen (GAME)

% Define the main robot window and the message areas
const Lborder := 2 	% Left border
const Rborder := 53 	% right border
const Tborder := 2 	% Top border
const Bborder := 21 	% Bottom border
type Row : Tborder .. Bborder
type Col : Lborder .. Rborder

% Command characters
const directionVector := "qweasdzxctlb"
const UL := 1 	% Up left
const U := 2 	% Up
const UR := 3 	% Up right
const LT := 4 	% Left
const S := 5 	% Stand still
const RT := 6 	% Right
const DL := 7 	% Down left
const D := 8 	% Down
const DR := 9 	% Down right
const T := 10 	% Teleport
const LS := 11 	% Last Stand
const BL := 12 	% Blast (must be the last command)
const numCommands := BL

% Define the display characters
const Blank := " "
const Player := "P"
const Robot := "r"
const Wreck := "*"
const Dead := "@"

% MODULE FOR THIS?
var board : array Row, Col of string (1) % initially blank
for r : Tborder .. Bborder
    for c : Lborder .. Rborder
	board (r, c) := Blank
    end for
end for

% Score info
var score := 0
const scorePts := 20

% Draw screen border 
colorback (CYAN)

% Top border line
locate (Tborder - 1, Lborder - 1)
put " " + repeat (" ", (Rborder - Lborder + 1)) + " " ..

% Side borders
for l : Tborder .. Bborder
    locate (l, Lborder - 1)
    put " " ..
    locate (l, Rborder + 1)
    put " " ..
end for

% Bottom border line
locate (Bborder + 1, Lborder - 1)
put " " + repeat (" ", (Rborder - Lborder + 1)) + " " ..
colorback (CLEAR)

% Draw credits
var MsgRow := Tborder
const MsgCol := Rborder + 5
locate (MsgRow, MsgCol)
put "   Turing" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put "Robot Killers" ..
MsgRow += 2
locate (MsgRow, MsgCol)
put Robot ..
put " - Robot" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put Wreck ..
put " - Wreck" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put Player ..
put " - You" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put Dead ..
put " - Ex You" ..
MsgRow += 2
const TurnHdr := "Board: "
const TurnRow := MsgRow
const TurnCol := MsgCol + length (TurnHdr)
locate (TurnRow, MsgCol)
put "Board: " ..
MsgRow += 1
const ScoreHdr := "Score: "
const ScoreRow := MsgRow
const ScoreCol := MsgCol + length (ScoreHdr)
locate (ScoreRow, MsgCol)
put ScoreHdr ..
MsgRow += 2

% Draw general information window
locate (MsgRow, MsgCol)
put "q w e" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put " \\|/   b - blast" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put "a-s-d  l - last stand" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put " /|\\   t - teleport" ..
MsgRow += 1
locate (MsgRow, MsgCol)
put "z x c" ..
MsgRow += 2
const FinalRow := MsgRow + 1
assert FinalRow <= Bborder % make sure there is room for all message lines

procedure CleanBoard
    for r : Tborder .. Bborder
	for c : Lborder .. Rborder
	    if board (r, c) not= Blank then
		board (r, c) := Blank
		locate (r, c)
		put Blank ..
	    end if
	end for
    end for
end CleanBoard

% Describe positions
const Density := 9 % one space in 9 will be a robot
const maxRobots := (Rborder - Lborder + 1) * (Bborder - Tborder + 1) div
    Density

var numRobots : 1 .. maxRobots

type Posn :
    record
	x : int % use -ve codes for dead objects
	y : int
    end record

var robots : array 1 .. maxRobots of Posn
var human : Posn

procedure DisplayHuman (deltaX, deltaY : int, ch : string (1))
    % Erase old person position and any movement bars
    for x : human.x - deltaX - 1 .. human.x - deltaX + 1
	for y : human.y - deltaY - 1 .. human.y - deltaY + 1
	    if x >= Tborder and x <= Bborder and
		    y >= Lborder and y <= Rborder and
		    board (x, y) = Blank then
		locate (x, y)
		put Blank ..
	    end if
	end for
    end for

    board (human.x - deltaX, human.y - deltaY) := Blank
    locate (human.x - deltaX, human.y - deltaY)
    put Blank ..

    % Display human with movement bars if possible
    const hDisplay : array - 1 .. 1, - 1 .. 1 of string (1) :=
	init ("\\", "|", "/", "-", Player, "-", "/", "|", "\\")

    for r : human.x - 1 .. human.x + 1
	for c : human.y - 1 .. human.y + 1
	    if r >= Tborder and r <= Bborder and
		    c >= Lborder and c <= Rborder and
		    board (r, c) = Blank then
		color (RED)
		locate (r, c)
		put hDisplay (r - human.x, c - human.y) ..
		color (CLEAR)
	    end if
	end for
    end for

    % Draw Player
    board (human.x, human.y) := ch
    locate (human.x, human.y)
    put ch ..
end DisplayHuman

% Can only blast once per game
var blasted : boolean

procedure Setup (turn : int)
    var x : int
    var y : int

    locate (TurnRow, TurnCol)
    put intstr (turn, 1) ..
    locate (ScoreRow, ScoreCol)
    put intstr (score, 1) ..

    % How many robots this time?
    numRobots := min (2 ** round (sqrt (turn)) + 4 * turn, maxRobots)
    CleanBoard
    blasted := false

    % Place player
    randint (x, Tborder, Bborder)
    randint (y, Lborder, Rborder)
    human.x := x
    human.y := y
    board (x, y) := Player
    DisplayHuman (0, 0, Player)

    % Place robots
    for r : 1 .. numRobots
	loop
	    randint (x, Tborder, Bborder)
	    randint (y, Lborder, Rborder)
	    exit when board (x, y) = Blank
	end loop

	robots (r).x := x
	robots (r).y := y
	board (x, y) := Robot
	color (BLUE)
	locate (x, y)
	put Robot ..
	color (CLEAR)
    end for
end Setup

% Direction already determined and verified, now update the display
procedure MoveHuman (deltaX : - 1 .. 1, deltaY : - 1 .. 1, var over :
    boolean)
    board (human.x, human.y) := Blank
    locate (human.x, human.y)
    put Blank ..
    human.x += deltaX
    human.y += deltaY

    % Did the player bump into anything?
    if board (human.x, human.y) = Blank then
	DisplayHuman (deltaX, deltaY, Player)
    else
	DisplayHuman (deltaX, deltaY, Dead)
	over := true
    end if
end MoveHuman

procedure MoveRobots (var over : boolean)
    for r : 1 .. numRobots
	var b := robots (r)

	if b.x > 0 and b.y > 0 then
	    % Robot still "live"
	    % Remove b from current position
	    % unless another b has already moved into that place
	    var replaced := board (b.x, b.y) = Wreck

	    for bb : 1 .. numRobots
		exit when bb = r or replaced
		replaced := (robots (bb).x = b.x and robots (bb).y = b.y)
	    end for

	    if not replaced then
		board (b.x, b.y) := Blank
		locate (b.x, b.y)
		put Blank ..
	    end if

	    % Figure out how to get closest to player
	    b.x += sign (human.x - b.x)
	    b.y += sign (human.y - b.y)
	    locate (b.x, b.y)

	    % Check square being moved into
	    if board (b.x, b.y) = Blank then
		% Safe to move here
		board (b.x, b.y) := Robot
		color (BLUE)
		put Robot ..
		color (CLEAR)
	    elsif board (b.x, b.y) = Player or board (b.x, b.y) = Dead then
		% Got him (Or at least someone did!)
		board (b.x, b.y) := Dead
		put Dead ..
		over := true
	    elsif board (b.x, b.y) = Robot then
		% Might have bumped other b, or might be filling in
		% place about to be vacated (Robots move "simultaneously")
		var bumped := false

		for bb : 1 .. numRobots
		    exit when bb = r % Filling in space about to be vacated

		    if robots (bb).x = b.x and robots (bb).y = b.y then
			% BUMP!!!
			bumped := true
			robots (bb).x := 0
			robots (bb).y := 0
			score += scorePts % One down, one to go
			exit
		    end if
		end for

		if bumped then
		    % and there it goes
		    board (b.x, b.y) := Wreck
		    b.x := 0
		    b.y := 0
		    put Wreck ..
		    score += scorePts
		else
		    % Filling in space to be vacated
		    color (BLUE)
		    put Robot ..
		    color (CLEAR)
		end if
	    else
		% Must already be a wreck or something here
		board (b.x, b.y) := Wreck
		b.x := 0
		b.y := 0
		put Wreck ..
		score += scorePts
	    end if
	end if

	robots (r) := b
    end for

    % Check if there is any reason to keep playing (man dead or no robots left)
    var liveRobot := over % don't care if man is already dead

    for r : 1 .. numRobots
	exit when liveRobot
	liveRobot := liveRobot or (robots (r).x > 0 and robots (r).y > 0)
    end for

    over := over or not liveRobot
end MoveRobots

procedure Teleport
    % Place player randomly on board
    var x, y : int
    loop
	% Determine a free space at random
	randint (x, Tborder, Bborder)
	randint (y, Lborder, Rborder)
	exit when board (x, y) = Blank
    end loop

    const deltaX := x - human.x
    const deltaY := y - human.y
    human.x := x
    human.y := y
    DisplayHuman (deltaX, deltaY, Player)
end Teleport

procedure Blast (var over : boolean, var move : boolean)
    % Blow away any neighbouring robots
    if blasted then
	% Only one shot per screen
	locate (MsgRow, MsgCol)
	put "Already shot      " ..
	move := false
    else
	% Blow 'em away
	blasted := true
	% Check every adjoining spot
	for r : human.x - 1 .. human.x + 1
	    for c : human.y - 1 .. human.y + 1
		if r >= Tborder and r <= Bborder and
			c >= Lborder and c <= Rborder and
			board (r, c) = Robot then
		    % Robot found, blast it
		    for b : 1 .. numRobots % Which robot is it
			if robots (b).x = r and robots (b).y = c then
			    robots (b).x := 0
			    robots (b).y := 0
			    exit
			end if
		    end for

		    board (r, c) := Blank
		    locate (r, c)
		    put Blank ..
		    score += scorePts
		end if
	    end for
	end for

	% Any reason to continue?
	for r : 1 .. numRobots
	    if robots (r).x > 0 and robots (r).y > 0 then
		return
		% if there is even one robot left
	    end if
	end for

	over := true
    end if
end Blast


% Used mainly to figure out how many robots should be on screen
var turn := 0

loop
    turn += 1
    var over := false % done with this turn

    Setup (turn)
    locate (human.x, human.y)

    loop
	var move := true % Legal move?
	var deltaX, deltaY := 0

	var ch : string (1)
	getch (ch)

	% Convert to lower case
	if ch >= "A" and ch <= "Z" then
	    ch := chr (ord ("a") - ord (ch) + ord ("a"))
	end if

	% Process input
	case (index (directionVector, ch) - 1) mod numCommands + 1 of
	    label UL :
		deltaX -= 1
		deltaY -= 1
	    label U :
		deltaX -= 1
	    label UR :
		deltaX -= 1
		deltaY += 1
	    label LT :
		deltaY -= 1
	    label S :
		% do nothing
	    label RT :
		deltaY += 1
	    label DL :
		deltaX += 1
		deltaY -= 1
	    label D :
		deltaX += 1
	    label DR :
		deltaX += 1
		deltaY += 1
	    label T :
		Teleport
	    label BL :
		Blast (over, move)
	    label LS :
		deltaX := 0
		deltaY := 0
		loop
		    MoveHuman (deltaX, deltaY, over)
		    exit when over
		    MoveRobots (over)
		    locate (ScoreRow, ScoreCol)
		    put intstr (score, 1), "         " ..
		    exit when over
		    move := false
		end loop
		exit
	    label :
		locate (MsgRow, MsgCol)
		put "Bad move          " ..
		move := false
	end case

	if move and ( (human.x + deltaX < Tborder or human.x + deltaX > 
	    Bborder) or (human.y + deltaY < Lborder or human.y + deltaY > 
		Rborder)) then
	    % Don't allow player to bump into walls
	    deltaX := 0
	    deltaY := 0
	    locate (MsgRow, MsgCol)
	    put "Bumped horizon    " ..
	    move := false
	end if

	if move then
	    locate (MsgRow, MsgCol)
	    put "                 " ..
	    % See what it gets you
	    MoveHuman (deltaX, deltaY, over)
	    exit when over
	    MoveRobots (over)
	end if

	% Update score before final display
	locate (ScoreRow, ScoreCol)
	put intstr (score, 1), "          " ..
	locate (FinalRow, MsgCol)
	put "                    " ..
	locate (human.x, human.y)
	exit when over
    end loop

    % Over due to death or no more robots
    locate (ScoreRow, ScoreCol)
    put intstr (score, 1), "          " ..

    if board (human.x, human.y) = Player then
	% Not dead, therefore winner
	for r : human.x - 1 .. human.x + 1
	    for c : human.y - 1 .. human.y + 1
		if r >= Tborder and r <= Bborder and
			c >= Lborder and c <= Rborder and
			board (r, c) = Blank then
		    locate (r, c)
		    put Blank ..
		end if
	    end for
	end for

	locate (FinalRow, MsgCol)
	put "Congratulations   " ..
    else
	locate (FinalRow, MsgCol)
	put "Better luck next time" ..
	exit
    end if
end loop

% Clean up the act before stopping
locate (Bborder + 2, 1)
setscreen (NORMAL)
