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

#include <stdio.h>
#include <sys/types.h>

#include <fcntl.h>

#ifdef OSX32
#include <sys/filio.h>
#endif

#ifndef LINUX
#include <sys/socket.h>
#include <signal.h>
#include <sys/ioctl.h>
#endif /* LINUX */

FILE *TLIstdin;
FILE *TLIstdout;
FILE *TLIstderr;

void
TLIZC_Initialize( )
{
	TLIstdin	= stdin;
	TLIstdout	= stdout;
	TLIstderr	= stderr;
	setbuf (stdout, NULL);
	setbuf (stderr, NULL);
}

static int save_flags;

void
TLIsaveFlags( )
{
    save_flags = fcntl( 0, F_GETFL, 0 );
}

void
TLIrestoreFlags( )
{
    (void) fcntl( 0, F_SETFL, save_flags );
}

void
TLIenableSIGIO( )
{
#ifndef LINUX
    int flags = fcntl( 0, F_GETFL, 0 );
    (void) fcntl( 0, F_SETFL, flags|FASYNC );
#endif /* LINUX */
}

void
TLIdisableSIGIO( )
{
#ifndef LINUX
    int flags = fcntl( 0, F_GETFL, 0 );
    (void) fcntl( 0, F_SETFL, flags&~FASYNC );
#endif /* LINUX */
}

void
TLIcatchSIGIO( signalHandler )
    void (*signalHandler)();
{
#ifndef LINUX
    (void) signal( SIGIO, signalHandler );
#endif /* LINUX */
}

char
TLIinputAvail( )
{
    /* Check if stdio has pending buffered characters */
    int c;
    c = getchar ();
    if (c == EOF) {
	return (0);
    } else {
	ungetc (c, stdin);
	return (1);
    }
}

void
TLIreset( fd )
    FILE *fd;
{
    clearerr( fd );
    fseek(fd,0L,SEEK_SET);
}
