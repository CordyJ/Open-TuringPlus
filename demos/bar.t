% Turing demonstration - simple bar graph

% Turing character terminal graphics
include "include/screen.i"

% Data
const firstYear := 1979
const lastYear := 1988

var sharePrice : array firstYear .. lastYear of real := 
    init (12.54, 14.00, 15.63, 22.01, 21.98, 23.05, 27.98, 31.55, 20.00, 13.99)

% Show bar graph
cls

put "    Year  Stock Price"
put ""

for year: firstYear .. lastYear
    colorback (CLEAR)
    put year : 8, "  " ..
    if year mod 2 = 0 then
        colorback (BLUE)
    else
        colorback (GREEN)
    end if
    put " " : round (sharePrice (year)) * 2
end for

colorback (CLEAR)
put ""
