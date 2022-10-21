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

/*	@(#)time.h 1.1 85/12/18 SMI; from UCB 4.4 83/07/09	*/
/* Turing Plus version of time.h */

/*
 * Structure returned by gettimeofday(2) system call,
 * and used in other calls.
 */
type *timeval:
    record
	tv_sec	: int4		/* seconds */
	tv_usec	: int4		/* and microseconds */
    end record

type *timezone:
    record
	tz_minuteswest	: int4	/* minutes west of Greenwich */
	tz_dsttime	: int4	/* type of dst correction */
    end record

const *DST_NONE		:= 0	/* not on dst */
const *DST_USA		:= 1	/* USA style dst */
const *DST_AUST		:= 2	/* Australian style dst */
const *DST_WET		:= 3	/* Western European dst */
const *DST_MET		:= 4	/* Middle European dst */
const *DST_EET		:= 5	/* Eastern European dst */

/*
 * Names of the interval timers, and structure
 * defining a timer setting.
 */
const *ITIMER_REAL	:= 0
const *ITIMER_VIRTUAL	:= 1
const *ITIMER_PROF	:= 2

type *itimerval:
    record
	it_interval	: timeval	/* timer interval */
	it_value	: timeval	/* current value */
    end record

/*
** include "../time.h"
*/
