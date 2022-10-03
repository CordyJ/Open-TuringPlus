%	Computer Systems Research Institute
%   	University of Toronto

%	Turing Demonstration Program -- Space Worm War V4.00
%   	Author:	James R. Cordy
%   	Date:	Originally in Concurrent Euclid  April 1982
%		Turing Version  January 1983

% Copyright (C) 1982,1983  James R. Cordy 


% Support Modules 
include "include/screen.i"	% Terminal screen interface 

% Screen image 
const maxMaxX := 300
const maxMaxY := 60
var screen : array 0 .. maxMaxX, 0 .. maxMaxY of string (1)
var maxX, maxY : int 

% Player state 
var playerx := maxX div 2
var playery := maxY div 2
var ateHim := false
var heQuit := false
var gameOver := false
var score := 0
var bestScore := 0
var bestName := "NOBODY"


% Worm parameters 
const maxWorms := 5
var nWorms : 0 .. maxWorms
const wormLength := 8
const wormWiggle : array 0 .. wormLength - 1 of - 1 .. 1 :=
    init (1, 1, 1, 1, 0, - 1, - 1, 0)
const wormColor : array 1 .. maxWorms of int :=
    init (RED, BLUE, GREEN, MAGENTA, CYAN)

% Segments of the worms 
var segment : array 1 .. maxWorms of
    array 0 .. wormLength - 1 of
    record
	x : 0 .. maxMaxX
	y : 0 .. maxMaxY
    end record

% Direction of motion 
var xdir : array 1 .. maxWorms of - 1 .. 1
var ydir : array 1 .. maxWorms of - 1 .. 1

% Turning parameters 
const maxCount := 1024
var count : array 1 .. maxWorms of 0 .. maxCount - 1
var turn : array 1 .. maxWorms of 1 .. maxCount

% Head and tail segments 
var head : array 1 .. maxWorms of 0 .. wormLength - 1
var tail : array 1 .. maxWorms of 0 .. wormLength - 1
var dead : array 1 .. maxWorms of boolean


% Worm initialization
procedure WormInit (w : 1 .. maxWorms)
    var random : int

    xdir (w) := 1
    ydir (w) := 1
    dead (w) := false
    turn (w) := w * 10
    count (w) := 0
    head (w) := 0
    tail (w) := 0

    for i : 1 .. wormLength - 1
	segment (w) (i).x := 0
	segment (w) (i).y := 0
    end for

    randint (random, 1, 100000)

    if random div 64 mod 2 = 0 then
	if random div 1024 mod 2 = 0 then
	    segment (w) (head (w)).y := 0
	else
	    segment (w) (head (w)).y := maxY - 1
	end if
	segment (w) (head (w)).x := random mod (maxX - 1)
    else
	if random div 1024 mod 2 = 0 then
	    segment (w) (head (w)).x := 0
	else
	    segment (w) (head (w)).x := maxX - 1
	end if
	segment (w) (head (w)).y := random mod (maxY - 1)
    end if
end WormInit



% Worm movement algorithm
procedure WormMove (w : 1 .. maxWorms)
    % Check to see if worm is dead 
    for i : 0 .. wormLength - 1
	exit when dead (w)
	dead (w) := screen (segment (w) (i).x, segment (w) (i).y) = "X"
    end for

    if dead (w) then
	return
    end if

    % Erase old tail 
    tail (w) := (head (w) + 1) mod wormLength
    screen (segment (w) (tail (w)).x, segment (w) (tail (w)).y) := " "
    locate (segment (w) (tail (w)).y, segment (w) (tail (w)).x)
    put " " ..

    % Compute new head position 
    if segment (w) (head (w)).x >= maxX - 1 then
	xdir (w) := - 1
    elsif segment (w) (head (w)).x <= 1 then
	xdir (w) := 1
    end if
    segment (w) (tail (w)).x :=
	segment (w) (head (w)).x + xdir (w) + xdir (w) * wormWiggle (tail (w))
    assert (segment (w) (tail (w)).x >= 0 and segment (w) (tail (w)).x <= maxX)

    if segment (w) (head (w)).y = maxY then
	ydir (w) := - 1
    elsif segment (w) (head (w)).y = 0 then
	ydir (w) := 1
    end if
    segment (w) (tail (w)).y := segment (w) (head (w)).y + ydir (w)
    assert (segment (w) (tail (w)).y >= 0 and segment (w) (tail (w)).y <= maxY)

    % Make old head a segment 
    screen (segment (w) (head (w)).x, segment (w) (head (w)).y) := "o"
    locate (segment (w) (head (w)).y, segment (w) (head (w)).x)
    color (wormColor (w))
    put "o" ..
    color (BLACK)
    head (w) := tail (w)

    % Put on new head
    screen (segment (w) (head (w)).x, segment (w) (head (w)).y) := "O"
    locate (segment (w) (head (w)).y, segment (w) (head (w)).x)
    color (wormColor (w))
    put "O" ..
    color (BLACK)

    if not ateHim then
	ateHim := abs (segment (w) (head (w)).x - playerx) <= 1
	    and abs (segment (w) (head (w)).y - playery) <= 1
    end if

    if ateHim then
	return
    end if

    % Decide if it's time to turn around 
    if count (w) mod turn (w) = 0 or
	    abs (segment (w) (head (w)).x - playerx) +
	    abs (segment (w) (head (w)).y - playery) < 5 then
	% The worm turns
	if segment (w) (head (w)).x > playerx then
	    xdir (w) := - 1
	else
	    xdir (w) := 1
	end if
	if segment (w) (head (w)).y > playery then
	    ydir (w) := - 1
	else
	    ydir (w) := 1
	end if
    end if

    count (w) := (count (w) + 1) mod maxCount
end WormMove



% Worm is dead; decay away
procedure WormDead (w : 1 .. maxWorms)
    var i : 0 .. wormLength := head (w)

    loop
	screen (segment (w) (i).x, segment (w) (i).y) := " "
	locate (segment (w) (i).y, segment (w) (i).x)
	put " " ..
	i := (i + 1) mod wormLength
	exit when i = head (w)
    end loop

    score := score + 1
    locate (0, maxX - 10)
    put "Score: ", score ..
end WormDead



% Player Commands 
const stop := ord (" ")
const moveLeft := ord ("j")
const moveRight := ord ("l")
const moveUp := ord ("i")
const moveDown := ord (",")
const moveUpLeft := ord ("u")
const moveUpRight := ord ("o")
const moveDownLeft := ord ("m")
const moveDownRight := ord (".")
const shootLeft := ord ("J")
const shootRight := ord ("L")
const shootUp := ord ("I")
const shootDown := ord ("<")
const shootUpLeft := ord ("U")
const shootUpRight := ord ("O")
const shootDownLeft := ord ("M")
const shootDownRight := ord (">")
const quit_ := ord ("q")

% Directions to Move or Shoot 
const none := - 1
const left := 0
const right := 1
const up := 2
const down := 3
const upLeft := 4
const upRight := 5
const downLeft := 6
const downRight := 7
const deltax : array none .. downRight of - 2 .. 2 :=
    init (0, - 1, 1, 0, 0, - 2, 2, - 2, 2)
const deltay : array none .. downRight of - 2 .. 2 :=
    init (0, 0, 0, - 1, 1, - 1, - 1, 1, 1)


procedure Move (direction : none .. downRight)
    var nx : int
    var ny : int

    screen (playerx, playery) := " "
    locate (playery, playerx)
    put " " ..

    nx := playerx + deltax (direction)
    if nx >= 0 and nx <= maxX then
	playerx := nx
    end if

    ny := playery + deltay (direction)
    if ny >= 0 and ny <= maxY then
	playery := ny
    end if

    screen (playerx, playery) := "@"
    locate (playery, playerx)
    put "@" ..
end Move



procedure Shoot (direction : left .. downRight)
    % First draw the shot
    var shotx := playerx
    var shoty := playery

    loop
	shotx := shotx + deltax (direction)
	shoty := shoty + deltay (direction)

	exit when shotx < 0 or shotx > maxX or
	    shoty < 0 or shoty > maxY

	assert (shotx >= 0 and shotx <= maxX)
	assert (shoty >= 0 and shoty <= maxY)

	if screen (shotx, shoty) not= " " then
	    screen (shotx, shoty) := "X"
	    locate (shoty, shotx)
	    put "X" ..
	    exit
	else
	    if deltay (direction) not= 0 or shotx mod 3 = 0 then
		locate (shoty, shotx)
		put "*" ..
	    end if
	end if

	if deltay (direction) not= 0 then
	    if shotx > 0 then
		if screen (shotx - 1, shoty) not= " " then
		    screen (shotx - 1, shoty) := "X"
		    locate (shoty, shotx - 1)
		    put "X" ..
		    exit
		end if
	    end if
	    if shotx < maxX then
		if screen (shotx + 1, shoty) not= " " then
		    screen (shotx + 1, shoty) := "X"
		    locate (shoty, shotx + 1)
		    put "X" ..
		    exit
		end if
	    end if
	end if

	delay (2)
    end loop

    % Now erase the shot
    var endx := shotx
    var endy := shoty
    shotx := playerx
    shoty := playery

    loop
	shotx := shotx + deltax (direction)
	shoty := shoty + deltay (direction)
	exit when shotx < 0 or shotx > maxX or
	    shoty < 0 or shoty > maxY

	if deltay (direction) not= 0 or shotx mod 3 = 0 then
	    if screen (shotx, shoty) = " " then
		locate (shoty, shotx)
		put " " ..
	    end if
	end if
	exit when shotx = endx and shoty = endy
    end loop
end Shoot



% Utility to clear leftover input characters
procedure flushinput
    var c : string (1)
    loop
	exit when not hasch
	getch (c)
    end loop
end flushinput



% Initialize a new game
procedure Initialize
    var c : string (1)
    var i : 0 .. maxMaxX
    var j : 0 .. maxMaxY

    flushinput
    setscreen (ECHO)

    put "Turing Space Worm War     Copyright (C) 1982,1983  James R. Cordy"
    put ""
    put "Instructions? (y/n/q) " ..

    getch (c)

    if c = "y" then
	cls
	put "Welcome to Worm War."
	put ""
	put "You are in a lonely outpost in a quadrant of the galaxy inhabited by the dreaded giant Andromedan"
	put "Blind Space Worm.  These vicious creatures are blind, but have a particularly acute sense of smell,"
	put "and are capable of detecting humans from several sectors away."
	put ""
	put "Your mission, should you decide to accept it, is to rid the galaxy of Space Worms and thus"
	put "make it a safer place in which to live. You are warned that the galactic population of"
	put "Space Worms is thought to be in excess of ten million."
	put ""

	put "Do you accept the challenge? (y/n) " ..
	flushinput
	getch (c)

	if c = "n" then
	    nWorms := 0
	    heQuit := true
	    return
	end if

	cls
	put "So be it.  Your space ship has the ability to move using the following controls:"
	put ""
	put "          u  i  o"
	put "           \\ | / "
	put "         j - @ - l"
	put "           / | \\ "
	put "          m  ,  ."
	put ""
	put "Your ultra-lightspeed death ray is controlled by the shift key, using the same direction keys."
	put "The space bar will halt the ship, and you may quit at any time by typing q."
	put ""
	put "Your special worm-repellent shields can be used to limit the number of worms in your quadrant"
	put "of the galaxy at any one time, but will make it harder to kill many worms quickly."
	put "In particular, you may wish to practice in a worm-free quadrant."

    elsif c = "q" then
	gameOver := true
	return

    else
        put ""
    end if

    loop
	put ""
	put "How many worms in the quadrant? (0-5): " ..
        flushinput
	getch (c)

	if c = "\n" then
	    c := "5"
	end if

	exit when c >= "0" and c <= chr (ord ("0") + maxWorms)
    end loop

    nWorms := ord (c) - ord ("0")

    i := 0
    loop
	j := 0
	loop
	    screen (i, j) := " "
	    exit when j = maxY
	    j := j + 1
	end loop
	exit when i = maxX
	i := i + 1
    end loop

    cls
    setscreen (NOECHO)
end Initialize



procedure PostScore
    var name : string
    var i : int
    var j : int
    var c : string (1)

    cls
    setscreen (ECHO)

    if ateHim then
	put "YOU WERE EATEN!" 
    else
	assert (heQuit)
	put "YOU'RE A COWARD!" 
    end if

    put ""

    put "Your score = ", score, " " ..

    if score < 10 then
	put "(crummy)"
    elsif score < 20 then
	put "(not bad)"
    elsif score < 40 then
	put "(good)"
    elsif score < 70 then
	put "(very good)"
    elsif score < 100 then
	put "(excellent)"
    else
	put "(champion!)"
    end if

    put ""

    if score > bestScore then
	put "You have qualified for membership in then Sacred Society of Champion Worm Warriors."
	put "By what name do you wish to be known, O Mighty Warrior? "
	put ""

	flushinput

	name := ""
	loop
	    getch (c)
	    exit when c = "\n" or length (name) = 100
	    name += c
	end loop

	put ""
	put "So be it, champion ", name, "!"

	bestScore := score
	bestName := name
    else
	put "The current champion is ", bestName, " with ", bestScore
    end if

    put ""
    put "(Hit any key to continue) " ..

    flushinput
    getch (c)
    cls

end PostScore



procedure Play
    var moveDirection : none .. downRight := none
    var shotDirection : none .. downRight := none
    var c : string (1)
    var i : int

    ateHim := false
    heQuit := false
    score := 0

    Initialize

    if gameOver or heQuit then
	cls
	return
    end if

    playerx := maxX div 2
    playery := maxY div 2

    for decreasing ii : 5 .. 1
	locate (playery, playerx)
	put chr (ii + ord ("0")) ..
	delay (1000)
    end for

    for w : 1 .. nWorms
	WormInit (w)
    end for

    Move (none)

    loop
	exit when ateHim or heQuit

	if hasch then
	    % skip keyboard stutter
	    loop
		getch (c)
		exit when not hasch
	    end loop

	    case ord (c) of
		label stop :
		    moveDirection := none
		label moveLeft :
		    moveDirection := left
		label moveRight :
		    moveDirection := right
		label moveUp :
		    moveDirection := up
		label moveDown :
		    moveDirection := down
		label moveUpLeft :
		    moveDirection := upLeft
		label moveUpRight :
		    moveDirection := upRight
		label moveDownLeft :
		    moveDirection := downLeft
		label moveDownRight :
		    moveDirection := downRight
		label shootLeft :
		    shotDirection := left
		label shootRight :
		    shotDirection := right
		label shootUp :
		    shotDirection := up
		label shootDown :
		    shotDirection := down
		label shootUpLeft :
		    shotDirection := upLeft
		label shootUpRight :
		    shotDirection := upRight
		label shootDownLeft :
		    shotDirection := downLeft
		label shootDownRight :
		    shotDirection := downRight
		label quit_ :
		    heQuit := true
		label :
	    end case
	end if

	if moveDirection not= none then
	    Move (moveDirection)
	end if

	if shotDirection not= none then
	    Shoot (shotDirection)
	    shotDirection := none
	else
	    delay (100)
	end if

	for w : 1 .. nWorms
	    WormMove (w)

	    if dead (w) then
		WormDead (w)
		WormInit (w)
	    end if
	end for

    end loop

    assert (ateHim or heQuit)

    delay (500)
    flushinput

    PostScore
end Play



% Main program
getscreen (maxY, maxX)
setscreen (GAME)

loop
    Play
    exit when gameOver
end loop

setscreen (NORMAL)
