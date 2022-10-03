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

// Fork a subprocess to run a pass of the compiler

#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/wait.h>

extern void exit();

void callsys (int *res, char name[], char prog[], char args[][4096], int argsUpper)
{
    register int i;
    int pid;
    int status;
#ifdef RUSAGE_SELF
    struct rusage ru;
#endif
    char *nargs[100];

    nargs[0] = name;

    for( i = 0; args[i][0]; i++ ){
	nargs[i+1] = args[i];
    }
    nargs[i+1] = 0;

    if( ( pid = fork() ) < 0 ){
	perror( "tpc: fork" );
	*res = 10;
	return;
    }

    if( pid == 0 ){
	/* child process */
	(void) execv (prog, nargs);
	perror( prog );
	exit( 10 );
    }

    /* we are now the parent */
    /* wait for the pass to terminate */

#ifdef RUSAGE_SELF
    while( wait3( &status, 0, &ru ) != pid ){
	continue;
    }
#else
    while( wait( &status ) != pid ){
	continue;
    }
#endif

    switch( *res = WTERMSIG(status) ){
	case -1:
	case 0:
	    break;
	case SIGINT:
	case SIGQUIT:
	case SIGHUP:
	case SIGPIPE:
	case SIGTERM:
	    return;
#ifdef SIGXCPU
	case SIGXCPU:
	    (void) fprintf( stderr, "CPU time limit exceeded in %s\n", prog );
	    return;
#endif
#ifdef SIGXFSZ
	case SIGXFSZ:
	    (void) fprintf( stderr, "File size limit exceeded in %s\n", prog );
	    return;
#endif
	default:
	    (void) fprintf( stderr, "Fatal compiler error in %s\n", prog );
	    return;
    }

    *res = WEXITSTATUS(status);
}
