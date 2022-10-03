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

stub module TLM

    import (
	% Modules
	    var TLK,

	% Procedures
	    TLQUIT,

	% Collections
	    var TL_Process,

	% Variables
	    var TLKPD
	)

    export (
	% Procedures
	    TLMUDUMP       % so user programs can dump the monitor state
	)

    child "TLMUDUMP.ch"	% note: this allows TLK to import and call TLMUDUMP 

end TLM

body module TLM

      % initialize TLM variables and set up the initially process
    include "TLM.var"	% THIS MUST BE FIRST

    child "TLMCLEN.ch"	% returns conditionQ length (experimental feature)
    child "TLMCEMP.ch"

    child "TLMUDUMP.ch"

    child "TLMGNEP.ch"
    child "TLMRENT.ch"
    child "TLMREXT.ch"   % calls TLMGNEP
    child "TLMRINI.ch"

    child "TLMDINI.ch"	  % calls TLMRINI
    child "TLMDENT.ch"
    child "TLMDEXT.ch"
    child "TLMDCTWT.ch"

    child "TLMCTSIG.ch"
    child "TLMCPSIG.ch"
    child "TLMCDSIG.ch"
    child "TLMCRSIG.ch"

    child "TLMCRWT.ch"    % calls TLMGNEP
    child "TLMCDWT.ch"    % calls TLMCRWT
    child "TLMCTWT.ch"    % calls TLMGNEP
    child "TLMCPWT.ch"    % calls TLMGNEP

    child "TLMCRINI.ch"
    child "TLMCDINI.ch"	  % calls TLMCRINI
    child "TLMCPINI.ch"   % calls TLMCRINI
    child "TLMCTINI.ch"   % calls TLMCRINI

    child "TLMIPINI.ch"
    child "TLMIPENT.ch"
    child "TLMIPEXT.ch"

    child "TLMRFIN.ch"
    child "TLMCFIN.ch"

end TLM
