% Turing+ v6.2, Sept 2022
% Copyright 1986 University of Toronto, 2022 Queen's University at Kingston
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software
% and associated documentation files (the “Software”), to deal in the Software without restriction,
% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
% subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all copies
% or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
% AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%
% Interface to external (UNIX) environment
%

parent "../TL.ch"

stub module TLX
    import ( var TLK )
    export ( 
	    TLXDT,
	    TLXTM,
	    TLXCL, TLXSC, TLXGE, TLXSYS,
	    TLXATF,
	    TLXPID, TLXTIM
	)

    procedure TLXPID (var pid : Cint)
    procedure TLXTIM (var time: Cint)

    % real function atof(char*)
    procedure TLXATF (str : string, var val : real)

    % external procedure Date (var d : string)
    %          d := date in form "dd mmm yy"
    procedure TLXDT ( var date : string )

    % external proc Time(var t : string)
    %          t := time in format "hh:mm:ss"
    procedure TLXTM (var time : string)

    % external procedure Clock(var c : int)
    %          c := milliseconds of user time.
    procedure TLXCL(var clock : Cint)

    % external procedure Sysclock(var c : int)
    %          c := milliseconds of system time.
    procedure TLXSC(var sysclock : Cint)

    % procedure getenv(symbol : string, var ret : string)
    procedure TLXGE (symbol: string, var ret : string)

    % external procedure System(str:string, var ret:int)
    % Execute the command str as if it was typed at the terminal to /bin/sh
    procedure TLXSYS(str : string, var ret : Cint)

end TLX
