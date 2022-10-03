% Dining Philosphers in Turing Plus
% Copyright 1989, James R. Cordy  

% Turing Plus terminal graphics
include "include/screen.i"

% Five's the usual number of diners, no?
const * numberofdiners := 5
type * eachdiner : 0 .. numberofdiners - 1
type * eachfork : 0 .. numberofdiners

% Meals eaten by each diner
const * maxmeals := 25
var meals : array eachdiner of 0 .. maxmeals := init (0, 0, 0, 0, 0)

% Maximum eating and thinking times
const * maxeatingtime := 10
const * maxthinkingtime := 10

% Diner states
const * thinking := 0
const * eating := 1
const * satisfied := 2
type * eachstate : thinking .. satisfied


% Only one process can be updating the screen at a time (otherwise output chaos!)

monitor output
    export (initialize, change, finalize)

    % Position of each diner at the table
    const diner_x : array eachdiner of int := init (36, 56, 48, 24, 16)
    const diner_y : array eachdiner of int := init (2, 9, 18, 18, 9)

    % Positions of fork to left and right of each diner
    const fork_x : array eachfork of int := init (25, 49, 57, 37, 19, 25)
    const fork_y : array eachfork of int := init (5, 5, 14, 21, 14, 5)

    % Diner's expressions
    const frowning := 0
    const smiling := 1
    const chewing := 2
    type eachexpression : frowning .. chewing

    % Diner's sides
    const left := 0
    const right := 1
    type eachside : left .. right

    procedure drawdiner (diner : eachdiner)
	const x := diner_x (diner)
	const y := diner_y (diner)

	if diner mod 3 = 0 then
	    color (BROWN)
	else
	    color (BLACK)
	end if

	locate (y, x)
	put "MMMMMMM" ..
	locate (y + 1, x)
	put "| o,o |" ..
	locate (y + 2, x)
	put "| --- |" ..
	locate (y + 3, x)
	put " \"\"\"\"\" " ..

	color (BLACK)
    end drawdiner

    procedure changeexpression (diner : eachdiner, expression : eachexpression)
	const x := diner_x (diner)
	const y := diner_y (diner)

	if diner mod 3 = 0 then
	    color (BROWN)
	else
	    color (BLACK)
	end if

	locate (y + 2, x)

	if expression = frowning then
	    put "| --- |" ..
	elsif expression = smiling then
	    put "| \\_/ |" ..
	else
	    put "| (_) |" ..
	end if

	color (BLACK)
    end changeexpression

    procedure drawfork (diner : eachdiner, side : eachside, state : eachstate)
	var x, y : int

	if state = thinking then
	    x := fork_x (diner + side)
	    y := fork_y (diner + side)
	else
	    if side = left then
		x := diner_x (diner) - 7
	    else
		x := diner_x (diner) + 9
	    end if

	    y := diner_y (diner) + 1
	end if

	color (BLUE)

	locate (y, x)
	put "|_|_|" ..
	locate (y + 1, x)
	put "  |  " ..
	locate (y + 2, x)
	put "  |  " ..

	color (BLACK)
    end drawfork

    procedure erasefork (diner : eachdiner, side : eachside, activity : eachstate)
	var x, y : int

	if activity = thinking then
	    x := fork_x (diner + side)
	    y := fork_y (diner + side)
	else
	    if side = left then
		x := diner_x (diner) - 7
	    else
		x := diner_x (diner) + 9
	    end if

	    y := diner_y (diner) + 1
	end if

	locate (y, x)
	put "     " ..
	locate (y + 1, x + 2)
	put " " ..
	locate (y + 2, x + 2)
	put " " ..
    end erasefork

    procedure movefork (diner : eachdiner, side : eachside, state : eachstate)
	if state = thinking then
	    erasefork (diner, side, eating)
	else
	    erasefork (diner, side, thinking)
	end if

	drawfork (diner, side, state)
    end movefork

    procedure initialize
	cls
	put "THE DINING PHILOSOPHERS"
	put "Processes in Turing Plus"

	for diner : eachdiner
	    drawdiner (diner)
	    drawfork (diner, left, thinking)
	    drawfork (diner, right, thinking)
	end for
    end initialize

    procedure change (diner : eachdiner, state : eachstate)
	case state of
	    label eating :
		movefork (diner, left, eating)
		movefork (diner, right, eating)
		changeexpression (diner, chewing)
	    label thinking :
		movefork (diner, left, thinking)
		movefork (diner, right, thinking)
		changeexpression (diner, frowning)
	    label satisfied :
		changeexpression (diner, smiling)
	end case
	delay (200)
    end change

    procedure finalize
	var c : string (1)
	locate (24, 1)
	put "Press return to clear " ..
	get c : 1
	cls
    end finalize
end output


% Only one process can be manipulating forks at a time

monitor forks
    export (pickup, putdown)

    function leftdiner (diner : eachdiner) : eachdiner
	result (diner + 1) mod numberofdiners
    end leftdiner

    function rightdiner (diner : eachdiner) : eachdiner
	result (diner + numberofdiners - 1) mod numberofdiners
    end rightdiner

    var forksavail : array eachdiner of 0 .. 2 := init (2, 2, 2, 2, 2)
    var okaytoeat : array eachdiner of condition

    procedure pickup (diner : eachdiner)
	if forksavail (diner) not= 2 then
	    wait okaytoeat (diner)
	end if

	forksavail (leftdiner (diner)) -= 1
	forksavail (rightdiner (diner)) -= 1
    end pickup

    procedure putdown (diner : eachdiner)
	forksavail (leftdiner (diner)) += 1
	forksavail (rightdiner (diner)) += 1

	if forksavail (leftdiner (diner)) = 2 then
	    signal okaytoeat (leftdiner (diner))
	end if

	if forksavail (rightdiner (diner)) = 2 then
	    signal okaytoeat (rightdiner (diner))
	end if
    end putdown
end forks


% Diners signal when they are all done
% Main program must wait until all diner processes are done

monitor diners
    export (done, alldone)

    var eachdone : condition

    procedure done (diner : eachdiner)
	signal eachdone
    end done

    procedure alldone
	var numberdone := 0
	loop
	    wait eachdone
	    numberdone += 1
	    exit when numberdone = numberofdiners
	end loop
    end alldone
end diners


% Each diner is a fork (heh heh!) of this process

process adiner (diner : eachdiner)
    var random : int
    loop
	% hungry, so get my forks and eat for a while
	forks.pickup (diner)
	output.change (diner, eating)
	randint (random, 1, maxeatingtime)
	pause (random)
	meals (diner) += 1

	% stuffed, so put my forks down and think for a while
	output.change (diner, thinking)
	forks.putdown (diner)

	exit when meals (diner) = maxmeals

	randint (random, 1, maxthinkingtime)
	pause (random)
    end loop

    % done whole meal - burp!
    output.change (diner, satisfied)
    diners.done (diner)
end adiner


% Main program
output.initialize

for diner : eachdiner
    fork adiner (diner)
end for

diners.alldone
output.finalize
