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

stub module TLA

    import (
	% Modules
	    var TLX,

	% Collections
	    var TL_Process,

	% Variables
		TLECU,
		TLKPD,

	% Procedures
	    TLQUIT,

	% Constants
	    maxint,
	    maxnat,
	    minint
	)
    export (
	% Procedures
	    TLAVES,
	    TLAVFS,
	    TLAVS8,
	    TLAVSI,
	    TLAVSN
	)

    child "TLAVES.ch"
    child "TLAVFS.ch"
    child "TLAVS8.ch"
    child "TLAVSI.ch"
    child "TLAVSN.ch"

end TLA

body module TLA

    include "TLA.var"

    child "TLA4AD.ch"
    child "TLA4CM.ch"
    child "TLA4DN.ch"
    child "TLA4DV.ch"
    child "TLA4ML.ch"
    child "TLA4MN.ch"
    child "TLA4MX.ch"
    child "TLAV8D.ch"
    child "TLAVD8.ch"
    child "TLA8GX.ch"
    child "TLA8SX.ch"
    child "TLA8T.ch"
    child "TLA8AD.ch"
    child "TLA8CD.ch"
    child "TLA8CL.ch"
    child "TLA8CM.ch"
    child "TLA8CR.ch"
    child "TLA8DN.ch"
    child "TLA8DV.ch"
    child "TLA8FL.ch"
    child "TLA8LN.ch"
    child "TLA8MD.ch"
    child "TLA8ML.ch"
    child "TLA8MN.ch"
    child "TLA8MX.ch"
    child "TLA8QR.ch"
    child "TLA8RD.ch"
    child "TLA8RE.ch"
    child "TLA8SD.ch"
    child "TLA8SG.ch"
    child "TLA8SR.ch"
    child "TLA8TD.ch"
    child "TLA8TR.ch"
    child "TLA8X.ch"
    child "TLA8XP.ch"
    child "TLAIDV.st"
    child "TLAIMD.ch"
    child "TLAIMN.ch"
    child "TLAIMX.ch"
    child "TLAIML.st"
    child "TLANDV.st"
    child "TLANMD.ch"
    child "TLANML.st"
    child "TLANMU.st"
    child "TLAPII.ch"
    child "TLAPRI.ch"
    child "TLAPRR.ch"
    child "TLARSC.ch"
    child "TLARNI.ch"
    child "TLARNR.ch"
    child "TLARNZ.ch"
    child "TLARSR.ch"
    child "TLARSZ.ch"
    child "TLARZ.ch"
    child "TLAV48.ch"
    child "TLAV84.ch"
    child "TLAVRS.ch"
    child "TLAVES.ch"
    child "TLAVFS.ch"
    child "TLAVI4.ch"
    child "TLAVI8.ch"
    child "TLAVN4.ch"
    child "TLAVN8.ch"
    child "TLAVS8.ch"
    child "TLAVSI.ch"
    child "TLAVSN.ch"

    /* initialize random seeds */
    TLARZ

end TLA
