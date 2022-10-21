procedure try
    handler (c)
	if c = 10 then
	    put skip, "ok caught 10"
	    return	
	else
	    put skip, "caught ", c
	end if
    end handler

    var s := "hi"

    for decreasing i: 10000000 .. 1
	s += "lo"
	if length (s) > 3000 then
	    s := "hi"
	end if
	if i mod 1000000 = 0  then
	    put i div 1000000 
	end if
	if i = 1 then
	    quit: 10
	end if
    end for
end try

try
