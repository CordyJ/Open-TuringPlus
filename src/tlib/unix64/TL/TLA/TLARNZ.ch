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
% pRandomize   { predefined procedure randomize }
%
% Reset the sequence of pseudo random numbers returned by rand and randint.
% So different executions will produce different results.
%

parent "TLA.ch"

stub procedure TLARNZ

body procedure TLARNZ

    var seed : Cint 	% seed is 'Cint' not 'nat4' because that's what
			% TLX.TLXTIM wants
    var pid : Cint

    %
    % seed = current_time + process_id
    %
    TLX.TLXTIM(seed)            % get current wall clock time
    TLX.TLXPID(pid)    		% get user's process id
    seed += pid

    %
    % Now permute the bits to randomize it some more.
    %
    type t : array 0..1 of int2
    type(t,seed)(0) xor= type(t,seed)(1)
    type(t,seed)(1) xor= type(t,seed)(0)

    %
    % Initialize the random sequence.
    %
    TLARS(0) := seed

    %
    % Run the random number generator once to separate out close seeds.
    %
    var dummy : real
    TLARSC (dummy, 0)

end TLARNZ
