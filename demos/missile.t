%	Computer Systems Research Institute
%   	University of Toronto

%	Turing Demonstration Program -- Missile Command V1.04
%   	Author:	James R. Cordy
%   	Date:	February 1983


% Copyright (C) 1983  James R. Cordy 


% Support Modules 
include "include/screen.i"	% Terminal screen interface 

% Screen image 
const maxX := 78
const maxY := 23
var screen : array 0 .. maxX, 0 .. maxY of string (1)


% Player state 
const maxBases := 8
var nBases : 0 .. maxBases
const base : array 1 .. maxBases of 0 .. maxX :=
    init (4, 14, 24, 34, 44, 54, 64, 74)
const baseChar : array 1 .. maxBases of string (1) :=
    init ("a", "s", "d", "f", "j", "k", "l", ";")

const maxShots := 8
var shotBase : array 1 .. maxShots of 0 .. maxBases
var shot : array 1 .. maxShots of 0 .. maxY

var score : int := 0
var heQuit : boolean := false
var gameOver : boolean := false
var bestScore : int := 0
var bestName : string (100) := "NOBODY"


% Invader parameters 
const maxInvaders := 5
var nInvaders : 0 .. maxInvaders
const invaderString := "<*>"

% The invaders
var invader : array 1 .. maxInvaders of
    record
	x : 0 .. maxX
	y : 0 .. maxY
    end record

% Direction of motion 
const maxdir := 4
var dir : array 1 .. maxInvaders of - maxdir .. maxdir

% Movement parameters 
const maxCount := 1024
var count : array 1 .. maxInvaders of 0 .. maxCount - 1

% Invader state
var dead : array 1 .. maxInvaders of boolean
var done : array 1 .. maxInvaders of boolean


% Invader initialization
procedure InvaderInit (n : 1 .. maxInvaders)
    var i : int

    randint (i, 1, maxX - 1)
    invader (n).x := i
    invader (n).y := 0
    randint (i, - maxdir, maxdir)
    dir (n) := i
    randint (i, 0, 5)

    if i = 1 then
	dir (n) := - dir (n)
    end if

    dead (n) := false
    done (n) := false
    count (n) := 0
end InvaderInit


% Invader movement algorithm
procedure InvaderMove (n : 1 .. maxInvaders)
    var turn : int
    var rand_ : int

    % Check to see if invader has been shot
    for i : invader (n).x - 1 .. invader (n).x + 1
	dead (n) := screen (i, invader (n).y) = "|"
	exit when dead (n)
    end for

    % Erase old image
    for i : invader (n).x - 1 .. invader (n).x + 1
	screen (i, invader (n).y) := " "
	locate (invader (n).y, i)
	put " " ..
    end for

    if dead (n) then
	return
    end if

    % Compute new position 
    if score > 85 then
	turn := 15
    else
	turn := 100 - score
    end if

    randint (rand_, 0, turn - 1)

    if rand_ = 0 then
	% The invader turns
	dir (n) := - dir (n)
    end if

    if (invader (n).x >= maxX - maxdir and dir (n) > 0) or
	    (invader (n).x <= maxdir + 1 and dir (n) < 0) then
	dir (n) := - dir (n)
    end if

    invader (n).x += dir (n)
    assert (invader (n).x >= 1 and invader (n).x <= maxX - 1)

    if invader (n).y not= maxY then
	invader (n).y += 1
    else
	done (n) := true
	return
    end if

    % Check to see if invader walked into a missile
    for i : invader (n).x - 1 .. invader (n).x + 1
	dead (n) := screen (i, invader (n).y) = "|"
	exit when dead (n)
    end for

    if dead (n) then
	% Erase missile
	for i : invader (n).x - 1 .. invader (n).x + 1
	    screen (i, invader (n).y) := " "
	    locate (invader (n).y, i)
	    put " " ..
	end for

	return
    end if

    % Check to see if invader destroyed a base
    if screen (invader (n).x - 1, invader (n).y) = "_" or
	    screen (invader (n).x, invader (n).y) = "_" or
	    screen (invader (n).x + 1, invader (n).y) = "_" then
	nBases := nBases - 1
    end if

    % Draw new position
    for i : invader (n).x - 1 .. invader (n).x + 1
	screen (i, invader (n).y) := "*"
    end for

    locate (invader (n).y, invader (n).x - 1)
    color (RED)
    put invaderString ..
    color (CLEAR)
end InvaderMove


procedure InvaderDead (n : 1 .. maxInvaders)
    if dead (n) then
	score := score + 1
	locate (0, 0)
	put score ..

	if nInvaders < maxInvaders and (score = 10 or
		score = 25 or score = 50 or score = 100) then
	    nInvaders := nInvaders + 1
	end if
    end if
end InvaderDead


procedure ShotMove (s : 1 .. maxShots)
    if shotBase (s) not= 0 then
	const sb := base (shotBase (s))

	if shot (s) < maxY then
	    if screen (sb, shot (s)) not= " " then
		% Erase previous position
		screen (sb, shot (s)) := " "
		locate (shot (s), sb)
		put " " ..
	    else
		% Hit something; force shot to be over
		shot (s) := 1
	    end if
	end if

	shot (s) -= 1

	if shot (s) = 0 then
	    % The shot is over
	    shotBase (s) := 0
	else
	    % Draw next position
	    screen (sb, shot (s)) := "|"
	    locate (shot (s), sb)
	    put "|" ..
	end if
    else
	% Waste time proportional to a shot move
	locate (0, 0)
	locate (maxY, base (s))
    end if
end ShotMove


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
    setscreen (ECHO)

    put "Turing Missile Command      Copyright (C) 1983  James R. Cordy" 
    put ""
    put "Instructions? (y/n/q) " ..

    flushinput
    var c : string (1)
    getch (c)

    if c = "y" then
	cls
	put "Welcome to Missile Command." 
	put ""
	put "Missile Command is a crude war game in which you control eight"
	put "missile bases which are under attack by an alien invasion force."
	put "Your mission is to destroy the aliens before they destroy all"
	put "your missile bases." 
	put ""
	put "Your eight missile bases are controlled by the keys" 
	put ""
	put "        a  s  d  f  j  k  l  ;" 
	put ""
	put "and you may quit at any time by typing 'q'." 
	put ""
	put "As you destroy aliens, the frequency of alien attacks increases,"
	put "and they begin to send in their ace pilots, who are fiendishly"
	put "clever at dodging missiles." 
	put ""

	put "(hit return to begin) " ..
	flushinput
	getch (c)

    elsif c = "q" then
	gameOver := true
    end if

    nInvaders := 1

    for i : 0 .. maxX
	for j : 0 .. maxY
	    screen (i, j) := " "
	end for
    end for

    for i : 1 .. maxShots
	shotBase (i) := 0
    end for

    nBases := maxBases

    cls

    setscreen (NOECHO)
end Initialize


procedure PostScore
    var name : string (100)
    var c : string (1)

    setscreen (ECHO)
    cls

    if nBases = 0 then
	put "GAME OVER."
    else
	assert (heQuit)
	put "QUIT."
    end if

    put "Your score = ", score, " " ..

    if score < 10 then
	put "(crummy)" ..
    elsif score < 20 then
	put "(not bad)" ..
    elsif score < 40 then
	put "(good)" ..
    elsif score < 70 then
	put "(very good)" ..
    elsif score < 100 then
	put "(excellent)" ..
    else
	put "(champion!)" ..
    end if

    put ""

    if score > bestScore then
	put ""
	put "You have qualified for membership in the"
	put "Sacred Society of Champion Missile Commanders."
	put "By what name do you wish to be known, O Mighty General?"
	put ""

        flushinput

	name := ""
	loop
	    getch (c)
	    exit when c = "\n" or length (name) = 100
	    name += c
	end loop

	put ""
	put "So be it!" 
	bestScore := score
	bestName := name

    else
	put "The current champion is " ..
	put bestName ..
	put " with ", bestScore
    end if

    put ""
    put "(Hit any key to continue) " ..

    flushinput
    getch (c)
    cls

end PostScore


procedure Play
    var c : string (1)
    var j : 1 .. maxShots

    heQuit := false
    score := 0

    Initialize

    if gameOver then
	return
    end if

    for i : 1 .. maxBases
	screen (base (i), maxY) := "_"
	locate (maxY, base (i) - 1)
	color (BLUE)
	put "/_\\" ..
	color (CLEAR)
	locate (maxY + 1, base (i))
	put baseChar (i) ..
    end for

    for i : 1 .. maxInvaders
	InvaderInit (i)
    end for

    loop
	exit when nBases = 0 or heQuit

	% delay
	delay (200)

	if hasch then
	    loop
		getch (c)
		exit when not hasch
	    end loop

	    for i : 1 .. maxBases
		if c = baseChar (i) and
			screen (base (i), maxY) not= " " then
		    j := 1
		    loop
			exit when shotBase (j) = 0 or j = maxShots
			j := j + 1
		    end loop

		    if shotBase (j) = 0 then
			shotBase (j) := i
			shot (j) := maxY
		    end if

		elsif c = "q" then
		    heQuit := true
		end if
	    end for
	end if

	for i : 1 .. nInvaders
	    InvaderMove (i)

	    if dead (i) then
		InvaderDead (i)
		InvaderInit (i)
	    elsif done (i) then
		InvaderInit (i)
	    end if
	end for

	for i : 1 .. maxShots
	    ShotMove (i)
	end for

	locate (0,0)
    end loop

    assert (nBases = 0 or heQuit)

    loop
	exit when not hasch
	getch (c)
    end loop

    PostScore

end Play


% Main program
setscreen (KEYINPUT)

loop
    Play
    exit when gameOver
end loop

cls
setscreen (NORMAL)
