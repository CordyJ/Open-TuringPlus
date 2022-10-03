/*
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
*/

/* Corresponds to main.ch, which no longer works due to Clang type restrictions */
/* JRC 24.4.14 */

#ifdef UNIX32 
    #include <UNIX32/cinterface>
#else /* UNIX64 */
    #include <UNIX64/cinterface>
#endif

int main (argc, argv)
int	argc;
char**	argv;
{

    extern void TL ();

    extern void TProg ();

    extern void TL_TLK_TLKINI ();

    extern void TL_TLK_TLKFINI ();
    extern TLint4	TL_TLI_TLIARC;
    extern TLaddressint	TL_TLI_TLIARV;

    extern void close ();

    extern void TLIZC_Initialize ();
    TL_TLI_TLIARC = argc - 1;
    TL_TLI_TLIARV = (TLaddressint) argv;
    {
	register TLint4	fd;
	for (fd = 3; fd <= 31; fd++) {
	    close((TLint4) fd);
	};
    };
    TLIZC_Initialize();
    TL();
    TL_TLK_TLKINI();
    TProg();
    TL_TLK_TLKFINI();
}
