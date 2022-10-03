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

stub module TL
    include "%kernelTypes"
    include "%exceptions"
    include "%limits"

    % -- This allows TLK to call TLM, TLI, TLB, and TLE
    child "TLM/TLM.ch"
    child "TLB/TLB.ch"
    child "TLI/TLI.ch"
    child "TLE/TLE.ch"
end TL

body module TL
    include "TL.var"

    % Must be in this order.
    %
    % N.B.  All the initializing code in the library must be compiled with
    % line numbering off, since the "running process descriptor" hasn't been
    % set yet, so any attempt to store the current line/file is going to
    % result in an illegal reference (if we're lucky!).  This is probably
    % not a major concern, since I'd be surprised if *any* of the library
    % is *ever* compiled checked!


    % TLQUIT
    %  Convenient interface for aborting.
    %
    procedure TLQUIT(errorMsg: string, quitCode: int)
	TL_Process(TLKPD).exception.errorMsg := errorMsg
	TL_Process(TLKPD).exception.quitCode := quitCode
	quit: quitCode
    end TLQUIT


    child "TLK/TLK.st"
    child "TLM/TLM.ch"	% imports TLE, TLK

    child "TLX/TLX.st"	% interface to calls to (not TL) librarires.

    child "TLC/TLC.ch"
    child "TLB/TLB.ch"	% imports TLX
    child "TLA/TLA.ch"	% imports TLX
    child "TLI/TLI.ch"	% imports TLB, TLA, TLX
    child "TLS/TLS.ch"	% imports TLA
    child "TLE/TLE.ch"	% imports TLI(TLIFS), TLM, TLK)
end TL
