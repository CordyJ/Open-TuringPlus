function isAlpha (ch : char) : boolean
    result (ch >= 'A' and ch <= 'Z')
        or (ch >= 'a' and ch <= 'z')
end isAlpha

var line := "ab12cd34"

var i := 1 
loop
    exit when i = length(line) - 1
    % Broken--the original test that triggered this
    exit when isAlpha(line(i)) and (not (isAlpha(line(i + 1))) and true)  
    i += 1
end loop

if i = 2 then
    put "ok"
else
    put "bug!"
end if
