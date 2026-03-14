function isAlpha (ch : char) : boolean
  result (ch >= 'A' and ch <= 'Z')
      or (ch >= 'a' and ch <= 'z')
end isAlpha

var line := "123abc"

var i := 1 
loop
  exit when i = length(line) - 1
  % Broken
  exit when true and (isAlpha(line(i)) and true)
  i += 1
end loop

if i = 4 then
    put "ok"
else
    put "bug!"
end if
