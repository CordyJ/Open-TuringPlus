% The Children's Game of "Eights"
% J.R. Cordy, March 1990

% Turing terminal graphics
include "include/screen.i"

% The current board
var board : array 1 .. 3, 1 .. 3 of int 
var zerorow, zerocol := 2
var nmoves := 0

% The initial board
const initialboard : array 1 .. 3, 1 .. 3 of int := init (
    8, 2, 3,
    4, 0, 5,
    6, 7, 1)

% A winning board counts around from 1 to 8
const winningboard : array 1 .. 3, 1 .. 3 of int := init (
    1, 2, 3,
    8, 0, 4,
    7, 6, 5)

const arrows : array 1 .. 4 of char := 
    init (UPARROW, DOWNARROW, LEFTARROW, RIGHTARROW)

% Move a number tile - we infer which one from the direction
procedure move (dir : char)
    % infer the tile to move from the direction
    var n := 0

    case dir of
	label UPARROW:
	    if zerorow < 3 then
	        n := board (zerorow + 1, zerocol)
	    end if
	label DOWNARROW:
	    if zerorow > 1 then
	        n := board (zerorow - 1, zerocol)
	    end if
	label LEFTARROW:
	    if zerocol < 3 then
	        n := board (zerorow, zerocol + 1)
	    end if
	label RIGHTARROW:
	    if zerocol > 1 then
	        n := board (zerorow, zerocol - 1)
	    end if
	label:
    end case

    if n < 1 or n > 8 then
        return	% not a legal move
    end if

    % move that number tile
    nmoves += 1

    for row : 1 .. 3
        for col : 1 .. 3
            if board (row, col) = n and
                    abs (row - zerorow) +
                    abs (col - zerocol) = 1 then
                assert board (zerorow, zerocol) = 0
                board (zerorow, zerocol) := n
                locate (zerorow * 2, zerocol * 4 - 1)
                put n ..
                board (row, col) := 0
                locate (row * 2, col * 4 - 1)
                put " " ..
                zerorow := row
                zerocol := col
                return
            end if
        end for
    end for
end move

% Randomly shuffle the initial board
procedure initboard
    cls
    put "+-----------+"
    put "| 1 | 2 | 3 |"
    put "|---+---+---|"
    put "| 8 |   | 4 |"
    put "|---+---+---|"
    put "| 7 | 6 | 5 |"
    put "+-----------+"

    locate (9, 1)
    put "Welcome to Eights!"
    put ""
    put "In the game of Eights, you shuffle the tiles with the arrow keys"
    put "to try to get to the winning board shown above."
    put ""
    put "(press return) " ..

    var c : string (1)
    getch (c)

    locate (11, 1)
    put "Ready? Here we go!                                              "
    put "                                                                "
    put "                                                                "
    put "                                                                "
    locate (12, 1)

    % delay (3000)

    board := initialboard

    for row : 1 .. 3
        for col : 1 .. 3
            locate (row * 2, col * 4 - 1)
            if board (row, col) not= 0 then
                put board (row, col) ..
            else
                put " " ..
            end if
        end for
    end for

    locate (11, 1)
    put "Shuffling ...                                                   "

    randomize

    for : 1 .. 1000
        var dir : int
        randint (dir, 1, 4)
        move (arrows (dir))
	delay (10)
    end for

    locate (9, 1)
    put 0, " moves           "
    put "                    "
    put "                    "
    put "                    "
end initboard

function win : boolean
    if zerorow not= 2 or zerocol not= 2 then
        result false
    else
        for row : 1 .. 3
            for col : 1 .. 3
                if board (row, col) not= winningboard (row, col) then
                    result false
                end if
            end for
        end for
        result true
    end if
end win


% Main program

setscreen (GAME)

initboard

nmoves := 0
loop
    locate (9, 1)
    put nmoves, " moves"
    var c : string (1)
    getch (c)
    move (c)
    exit when win or c = "q"
end loop

if win then
    locate (4, 7)
    put "*" ..
    locate (9, 1)
    put "You win in ", nmoves, " moves!"
    put ""
    put "(press return) " ..
    var c : string (1)
    get c : 1
end if

cls

setscreen (NORMAL)
setscreen (ECHO)
