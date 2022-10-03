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
 *
 * body "../TL/TLX/TLX.st" module TLX
 *
 */

#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>


extern time_t time();

struct timeval startTime;


void TL_TLX()
{
    /* initialize TLX module here */
    (void) gettimeofday( &startTime, (struct timezone *) 0 );
}

 /* routines to be called before and after calls to UNIX library 
    and system call routines */
extern void TL_TLK_TLKUXRS();
extern void TL_TLK_TLKUXRE();

/*
 * external procedure Date (var d : string)
 *	d := date in form "dd mmm yy"
 */
void TL_TLX_TLXDT(result)
char *result;
{
    time_t t ;
    register char *p;

    TL_TLK_TLKUXRS();
    t = time( (time_t *) 0 );
    TL_TLK_TLKUXRE();

    /* form = Sun Sep 16 01:03:52 1973\n\0" */
    /*        012345678911111111112222 2 2  */
    /*		        01234567890123 4 5  */
    TL_TLK_TLKUXRS();
    p = ctime(&t);
    TL_TLK_TLKUXRE();

    result[0] = p[8];	/* dd mmm yy */
    result[1] = p[9];
    result[2] = ' ';
    result[3] = p[4];
    result[4] = p[5];
    result[5] = p[6];
    result[6] = ' ';
    result[7] = p[22];
    result[8] = p[23];
    result[9] = '\0';
}

/*
 * external proc Time(var t : string)
 *	t := time in format "hh:mm:ss"
 */
void TL_TLX_TLXTM(result)
char *result;
{
    time_t t ;
    register char *p;

    TL_TLK_TLKUXRS();
    t = time( (time_t *) 0 );
    TL_TLK_TLKUXRE();

    /* form = Sun Sep 16 01:03:52 1973\n\0" */
    /*        012345678911111111112222 2 2  */
    /*		        01234567890123 4 5  */
    TL_TLK_TLKUXRS();
    p = ctime(&t);
    TL_TLK_TLKUXRE();

    result[0] = p[11];	/* hh:mm:ss */
    result[1] = p[12];
    result[2] = p[13];
    result[3] = p[14];
    result[4] = p[15];
    result[5] = p[16];
    result[6] = p[17];
    result[7] = p[18];
    result[8] = '\0';
}

/*
 * external procedure Clock(var c : int)
 *	c := milliseconds of elapsed time.
 */
void TL_TLX_TLXCL( result )
    int *result;
{
    struct timeval currentTime;

    TL_TLK_TLKUXRS();
    (void) gettimeofday( &currentTime, (struct timezone *) 0 );
    TL_TLK_TLKUXRE();
    *result = ((currentTime.tv_sec - startTime.tv_sec) * 1000) +
	      ((currentTime.tv_usec - startTime.tv_usec) / 1000);
}

/*
 * external procedure Sysclock(var c : int)
 *	c := milliseconds of system time.
 */
void TL_TLX_TLXSC( result )
    int *result;
{
    *result = 0;
}



extern char * getenv ();
#define MAXLEN 4095

/*
 * external procedure getenv(symbol : string, var result : string)
 */
void TL_TLX_TLXGE (symbol, result)
char *symbol;
char *result;
{
    char *v;

    TL_TLK_TLKUXRS();
    if( (v = getenv( symbol )) ){
	/* only copy the first MAXLEN bytes */
	(void) strncpy( result, v, MAXLEN );
	result[MAXLEN] = '\0';
    } else {
	result[0] = '\0';
    }
    TL_TLK_TLKUXRE();
}


/*
 * external procedure System(str:string, var ret:int)
 *
 * Execute the command str as if it was typed at the terminal to /bin/sh
 */
extern int system();

void TL_TLX_TLXSYS(str, ret)
int *ret;
char *str;
{
    TL_TLK_TLKUXRS();
    *ret = system(str);
    TL_TLK_TLKUXRE();
}


/* 
 * malloc and free
 */
// extern char *malloc();
// extern free();

void
TL_TLB_TLBMAL( size, addr )
    unsigned size;
    char **addr;
{

    TL_TLK_TLKUXRS();
    *addr = malloc(size);
    TL_TLK_TLKUXRE();
}

void
TL_TLB_TLBMFR( addr )
    char *addr;
{
    TL_TLK_TLKUXRS();
    free(addr);
    TL_TLK_TLKUXRE();
}

extern int getpid();

void
TL_TLX_TLXPID (x)
    int *x;
{
    TL_TLK_TLKUXRS();
    *x = getpid();
    TL_TLK_TLKUXRE();
}

void
TL_TLX_TLXTIM (x)
    int *x;
{
    TL_TLK_TLKUXRS();
    *x = time( (time_t *) 0 );
    TL_TLK_TLKUXRE();
}



/* procedure atof ( char*, real) */

void 
TL_TLX_TLXATF(str, value)
char * str;
double *value;
{
    extern double atof();

    TL_TLK_TLKUXRS();
    *value = atof(str);
    TL_TLK_TLKUXRE();
}
