% Turing demonstration - strings
% Draw an Nacross x Ndown table of boxes of a given size

% Ask for a box size
var width, height: int
put "enter box width and height: " ..
get width, height

% Ask for how many boxes across and down
var Nacross, Ndown: int
put "enter number of boxes across and down: " ..
get Nacross, Ndown

% Compute the text lines for the top, middle, and bottom of each row
var top := "";
var middle := "";
var bottom := "";

for i : 0 .. width * Nacross
    if i mod width = 0 then
	top := top + " ";
	middle := middle + "|";
	bottom := bottom + "|";
    else
	top := top + "_";
	middle := middle + " ";
	bottom := bottom + "_";
    end if
end for

% Now output the whole thing
put top

for i : 1 .. Ndown
    for j : 1 .. height - 1
	put middle
    end for
    put bottom
end for

