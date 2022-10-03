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

/*
** Machine-dependent trap processing.
*/

#include <stdlib.h>
#include <signal.h>

#define SignalExceptionBase	150


/*
** Trap handler.
** This routine will be called when a signal (error) occurs.
** We must convert the signal into the correct quit operation.
*/
static void
TrapHandler( signalNo )
    int signalNo;
{
    extern void *TL_TLKPD;
    extern void TL_TLQUIT();
    char *message;

    /*
    ** Check whether TLKPD is valid yet.
    ** If it is then we can continue.
    ** Otherwise, there's no sense going further so leave a core
    ** dump, so I can figure out what's going on.
    */
    if( TL_TLKPD == 0 ){
	abort( );
	exit( 0 );
    }

    /*
    ** Reset the environment, since we are not going to properly return
    ** from this signal handler.
    ** Just re-enable current signal.
    */
    (void) signal( signalNo, TrapHandler );

    switch( signalNo ){
#ifdef SIGINT
	case SIGINT:
	    message = "Program terminated";
	    break;
#endif
#ifdef SIGILL
	case SIGILL:
	    message = "Illegal instruction";
	    break;
#endif
#ifdef SIGBUS
	case SIGBUS:
	    message = "Bus error";
	    break;
#endif
#ifdef SIGSEGV
	case SIGSEGV:
	    message = "Segmentation violation";
	    break;
#endif
#ifdef SIGXCPU
	case SIGXCPU:
	    message = "CPU time limit exceeded.  Program terminated";
	    break;
#endif
#ifdef SIGFPE
	case SIGFPE:
	    message = "Floating exception";
	    break;
#endif
	default:
	    message = "Internal Turing+ System Error - Unexpected signal";
	    break;
    }
    TL_TLQUIT( message, SignalExceptionBase + signalNo );
}


/*
** Initialize the trap handling for Unix signals.
*/
void
TL_TLE_TLETR( )
{
#ifdef SIGINT
    /* -- if SIGINT is being ignored, continue to ignore it */
    if( signal( SIGINT, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGINT, TrapHandler );
    }
#endif
#ifdef SIGILL
    (void) signal( SIGILL, TrapHandler );
#endif
#ifdef SIGFPE
    (void) signal( SIGFPE, TrapHandler );
#endif
#ifdef SIGBUS
    (void) signal( SIGBUS, TrapHandler );
#endif
#ifdef SIGSEGV
    (void) signal( SIGSEGV, TrapHandler );
#endif
#ifdef SIGXCPU
    (void) signal( SIGXCPU, TrapHandler );
#endif
}


/*
** Reset the trap handling to system defaults.  This is done
** when about to run the default handler, to make sure that
** an incoming signal does not leave us with no handler to
** execute.
*/
void
TL_TLE_TLETR_TLETRR( )
{
#ifdef SIGINT
    if( signal( SIGINT, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGINT, SIG_DFL );
    }
#endif
#ifdef SIGILL
    if( signal( SIGILL, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGILL, SIG_DFL );
    }
#endif
#ifdef SIGFPE
    if( signal( SIGFPE, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGFPE, SIG_DFL );
    }
#endif
#ifdef SIGBUS
    if( signal( SIGBUS, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGBUS, SIG_DFL );
    }
#endif
#ifdef SIGSEGV
    if( signal( SIGSEGV, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGSEGV, SIG_DFL );
    }
#endif
#ifdef SIGXCPU
    if( signal( SIGXCPU, SIG_IGN ) != SIG_IGN ){
	(void) signal( SIGXCPU, SIG_DFL );
    }
#endif
}
