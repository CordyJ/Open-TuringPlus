% Turing demonstration - modules and functions
% Bubble sort a random list of integers

% How many elements of what range of values?
const * nelements := 12
const * maxval := 50

% Hide data inside a module
module elements
    export lessthan, swap, print

    % The data list
    var list : array 1 .. nelements of int

    % Initially fill it with randome values
    randomize
    for i : 1 .. nelements
	randint (list (i), 1, maxval)
    end for

    % Is element i less than element j?
    function lessthan (i, j : 1 .. nelements) : boolean
	result list (i) < list (j)
    end lessthan

    % Swap elements i and j
    procedure swap (i, j : 1 .. nelements)
	const t := list (i)
	list (i) := list (j)
	list (j) := t
    end swap

    % Print the list
    procedure print 
	for i : 1 .. nelements
	    put list (i), " " ..
	end for
	put ""
    end print
end elements

% Generic bubble sort, which doesn't even know what it's sorting!
procedure sort
    for decreasing i : nelements - 1 .. 1
	for j : i .. nelements - 1
	    if elements.lessthan (j + 1, j) then
		elements.swap (j, j + 1)
	    end if
	end for
    end for
end sort

% Main program
put "Unsorted list: " ..
elements.print
sort
put "Sorted list:   " ..
elements.print
