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

parent "TLK.bd"

% TLKUEXIT (utility exit program)
%  Routine to cause program termination.
%
stub procedure TLKUEXIT ( exitCode : Cint )

body procedure TLKUEXIT
    % -- flush streams
    TLI.TLIFS

    % -- exitCode < 0 : means an internal Library error - exit quickly
    % -- exitCode > 0 : an exception occured
    % -- exitCode = 0 : no more processes(threads) left to dispatch

    if TLKMULTI and exitCode >= 0 then
	TLKUDMPA
    end if

    TLI.TLIFS

    % -- cleanup any IO and restore any state changes made
    % -- via async IO
    %
    TLI.TLIFINI

    external "exit" procedure Exit (exitCode : Cint )
    Exit(exitCode)

    /* NOT REACHED */
end TLKUEXIT
