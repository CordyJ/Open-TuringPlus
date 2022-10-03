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

stub module TLI

    import (
	% Modules
	    var TLB,
	    var TLA,
	    var TLK,

	% Collections
	    var TL_Process,

	% Procedures
	    TLQUIT,

	% Variables
	    	TLKPD,

	% Constants
	    maxargfiles,
	    maxstream
	)
    export (
	% Procedures
	    TLIFS,
	    TLIAON,
	    TLIAOFF,
	    TLIFINI,
	    TLIUDUMP
	)

    child "TLIFS.ch"

    procedure TLIAON	% asynchronous I/O on
    procedure TLIAOFF	% asynchronous I/O off
    procedure TLIUDUMP	% dump processes waiting for asynch I/O
    procedure TLIFINI	% TLI finalize  - called just before program exits
end TLI

body module TLI

    include "TLI.var"

    child "TLIGT.ch"
    child "TLIOS.ch"
    child "TLICL.ch"
    child "TLIEFR.ch"
    child "TLIEOF.ch"
    child "TLIFA.ch"
    child "TLIFS.ch"
    child "TLIGC.ch"
    child "TLIGCB.ch"
    child "TLIGI.ch"
    child "TLIGIB.ch"
    child "TLIGK.ch"
    child "TLIGN.ch"
    child "TLIGR.ch"
    child "TLIGS.ch"
    child "TLIGSS.ch"
    child "TLIGSW.ch"
    child "TLIOA.ch"
    child "TLIOF.ch"
    child "TLIOP.ch"
    child "TLIWRR.ch"
    child "TLIPC.ch"
    child "TLIPE.ch"
    child "TLIPF.ch"
    child "TLIPI.ch"
    child "TLIPK.ch"
    child "TLIPN.ch"
    child "TLIPR.ch"
    child "TLIPS.ch"
    child "TLIRER.ch"
    child "TLIRE.ch"
    child "TLISS.ch"
    child "TLISK.ch"
    child "TLISKE.ch"
    child "TLISSI.ch"
    child "TLISSO.ch"
    child "TLISSS.ch"
    child "TLITL.ch"
    child "TLIWR.ch"
    child "TLIGF.ch"
    child "TLISF.ch"

    %
    % Machine-dependent initialization.
    %
    child "TLIZ.st"

end TLI
