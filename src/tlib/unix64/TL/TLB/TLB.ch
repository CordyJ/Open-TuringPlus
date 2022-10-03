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

stub module TLB

    import (
	% Collections
	    var TL_Process,

	% Procedures
	    TLQUIT,

	% Variables
	    TLKPD
	)
    export (
	% Procedures
	    TLBMAL,
	    TLBMFR,
	    TLBNWU,
	    TLBFRU
	)

    child "TLBMAL.st"
    child "TLBMFR.st"
    child "TLBNWU.ch"
    child "TLBFRU.ch"

end TLB

body module TLB

    include "TLB.var"

    child "TLBMAL.st"
    child "TLBMFR.st"
    child "TLBALL.ch"
    child "TLBDAL.ch"
    child "TLBFRC.ch"
    child "TLBFRU.ch"
    child "TLBNWC.ch"
    child "TLBNWU.ch"

    /* uninitialization routines */
    child "TLBUNR.ch"
    child "TLBUNI.ch"
    child "TLBUUN.ch"

end TLB
