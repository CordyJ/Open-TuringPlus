% Turing demonstration - character conversion

loop
    put "You give me a character, I'll tell you its ASCII value (q to quit): " ..

    % Get the single character
    var c : string (1)
    get c : 1

    % Output its ASCII value
    put "'", c, "' = ", ord (c)

    exit when c = 'q'

    % Throw away the newline
    get c : 1
end loop
