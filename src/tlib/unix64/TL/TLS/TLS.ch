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

parent "../TL.ch"

stub module TLS

    import (
	% Modules
	    var TLA,
	% Procedures
	    TLQUIT,
	% Collections
	    var TL_Process,
	% Variables
		TLKPD,
	% Constants
	    maxstr,
	    defaultew,
	    defaultfw
	)
    export (
	)

    include "TLS.def"

end TLS

body module TLS

    include "TLS.var"

    child "TLSASN.ch"
    child "TLSBX.ch"
    child "TLSBS.ch"
    child "TLSBXX.ch"
    child "TLSBSS.ch"
    child "TLSBSX.ch"
    child "TLSBXS.ch"
    child "TLSCAT.ch"
    child "TLSCTA.ch"
    child "TLSCXX.ch"
    child "TLSCSS.ch"
    child "TLSCSX.ch"
    child "TLSCXS.ch"
    child "TLSDEL.ch"
    child "TLSIND.ch"
    child "TLSLEN.ch"
    child "TLSMCC.ch"
    child "TLSMCS.ch"
    child "TLSMSC.ch"
    child "TLSMSS.ch"
    child "TLSREC.ch"
    child "TLSRES.ch"
    child "TLSRPT.ch"
    child "TLSVCS.ch"
    child "TLSVES.ch"
    child "TLSVFS.ch"
    child "TLSVIS.ch"
    child "TLSVNS.ch"
    child "TLSVRS.ch"
    child "TLSVS8.ch"
    child "TLSVSI.ch"
    child "TLSVSN.ch"

end TLS
