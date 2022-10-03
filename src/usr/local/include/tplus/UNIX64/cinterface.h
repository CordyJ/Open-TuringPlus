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
 * Interface for Turing Plus to C translator	
 * Turing+ 6.1 revision - JRC 5.6.20
 */

#ifndef __TPLUSC__
#define __TPLUSC__

#include <setjmp.h>

/*
** Predefined Types
*/
typedef char		TLboolean;
typedef unsigned char	TLchar;
typedef char		TLint1;
typedef short		TLint2;
typedef int		TLint4;
typedef unsigned char	TLnat1;
typedef unsigned short	TLnat2;
typedef unsigned int	TLnat4;
typedef float		TLreal4;
typedef double		TLreal8;
typedef char		TLstring[4096];
typedef char		*TLaddressint;


struct C_queue_t {
	char *head, *tail;
};

/* the size of this must be kept current with %monitor and t+toc.mdp */
struct	TLCOND {
    struct C_queue_t	signalQ;
    struct TLMON	*md;
    char		*name;
    TLnat4		index;
    struct TLCOND	*nextCondition;
    struct TLCOND	*prevCondition;
    TLaddressint	otherInfo;
};

/* the size of this must be kept current with %monitor */
struct	TLMON {
    int		mQLock;
    int		entryParameter;
    int		monitorPriority;
    char		deviceMonitor;
    struct C_queue_t	entryQ;
    struct C_queue_t	reEntryQ;
    char		*name;
    struct TLCOND	*firstCondition;
    struct TLMON	*nextMonitor;
    struct TLMON	*prevMonitor;
    TLaddressint	otherInfo;
};

struct TLFTAB {
    int	numFiles;
    char	names[1];	/* really larger */
};

struct TLHAREA {
    int		quitCode;
    int		lineAndFile;
    struct TLFTAB	*fileTable;
    void		*nextHandler;
    jmp_buf		savedState;
};

#ifdef CHECKING
/*
 * Process descriptor for current process
 */
extern struct {
    TLnat4		lineAndFile;
    struct TLFTAB	*fileTable;
    TLaddressint	stackLimit;
    TLaddressint	stackPointer;
    struct TLHAREA	*handlerQhead;
    struct TLHAREA	*currentHandler;
    /* more fields */
} *TL_TLCPD;
#endif /* CHECKING */

/*
 * Library routines
 */
char	TL_TLI_TLIEOF(), TL_TLM_TLMCEMP();	/* boolean */

unsigned int TL_TLS_TLSVSN(), TL_TLA_TLANDV(), TL_TLA_TLANMD();

double	TL_TLA_TLA8TR(), TL_TLA_TLA8TD(), TL_TLA_TLA8CR(), TL_TLA_TLA8CD(),
	TL_TLA_TLA8XP(), TL_TLA_TLAVI8(), TL_TLA_TLA8LN(), TL_TLA_TLA8SR(),
	TL_TLA_TLA8SD(), TL_TLA_TLA8QR(), TL_TLS_TLSVS8(), TL_TLA_TLAVN8(),
	TL_TLA_TLAPRI(), TL_TLA_TLAPRR(), TL_TLC_TLCRMIN(), TL_TLC_TLCRMAX(),
	TL_TLA_TLA8MN(), TL_TLA_TLA8MX(), TL_TLA_TLA8MD();

int	TL_TLA_TLA8CL(), TL_TLA_TLA8FL(), TL_TLS_TLSLEN(), TL_TLS_TLSIND(),
	TL_TLA_TLA8RD(), TL_TLA_TLA8SG(), TL_TLS_TLSVSI(), TL_TLA_TLAPII(),
	TL_TLA_TLA8DV();

void	TL_TLS_TLSVES(), TL_TLS_TLSVIS(), TL_TLS_TLSVNS(), TL_TLA_TLARNR(),
	TL_TLA_TLARNI(), TL_TLA_TLARSR(), TL_TLA_TLARSZ(), TL_TLA_TLARNZ(),
	TTL_TLM_TLMCPG(), TL_TLS_TLSVRS(), TL_TLS_TLSRPT(), TL_TLM_TLMCPS(),
	TL_TLS_TLSDEL(), TL_TLE_TLEABT();

double	fabs();	/* from C library */

#ifdef CHECKING 
char *	TL_TLE_TLECRS();
#endif /* CHECKING */

/*
 * Predefined Routines
 */
#define TLSTRCTASS(dest,src,type)	dest = src
#ifdef lint
#	define TLNONSCLASS(dest,src,type)    (void) bcopy((char *)(src), \
						 (char *)(dest), (sizeof(type)))
#else
#	define TLNONSCLASS(dest,src,type)    { \
					    struct TL_str { \
						char TL_d[sizeof(type)]; \
					    }; \
					    *((struct TL_str *)(dest)) = \
						*((struct TL_str *)(src)); \
					}
#endif

/*
 * New and Free of register pointers
 */
#define	TLNEWREG(t, p, s)	{ \
				    t TL_ptr; \
				    TL_TLB_TLBNWU(&TL_ptr, s); \
				    p = TL_ptr; \
				}
#define	TLFREEREG(t, p, s)	{ \
				    t TL_ptr = p; \
				    TL_TLB_TLBFRU(&TL_ptr, s); \
				    p = TL_ptr; \
				}


/*
 * Conversion macros
 */
#define TLCHRTOSTR(c, t)	t[0] = c, t[1] = '\0'
#define TLCHRTOCHARS(c, t)	t[0] = c
#define TLCVTTOCHR(c)		c[0]


/* construct a small set (<= 32 bits)*/
#define TLSMLSETCONST(x)	(1 << (x))
#define TLSMLSMLSETCONST(x)	(1 << (x))
#define TLLRGSETCLR(x)		{	\
					register int TL_set = sizeof(x); \
					register unsigned char *TL_ptr = \
						(unsigned char *)(x); \
					for (;TL_set; TL_set--) \
						*TL_ptr++ = 0; \
				}
#define TLLRGSETALL(x)		{	\
					register int TL_set = sizeof(x); \
					register unsigned char *TL_ptr = \
						(unsigned char *)(x); \
					for (;TL_set; TL_set--) \
						*TL_ptr++ = 0xff; \
				}
#define TLLRGSETMANCONST(s, v)	s[(v) >> 3] |= 1 << ((v) & 7)
#define TLLRGSETCONST(s, v)	{	\
					register int TL_set = v; \
					s[TL_set >> 3] |= 1 << (TL_set & 7); \
				}
#define TLLRGSETIN(var,v,s)	{ \
					register int TL_set = v; \
					var = (s[TL_set >> 3] & \
						(1 << (TL_set & 7))) != 0; \
				}
#define TLLRGSETOP(res,a,b,op)	{	\
					register int TL_set = sizeof(res); \
					register unsigned char *TL_ptr1 = \
						(unsigned char *)(res); \
					register unsigned char *TL_ptr2 = \
						(unsigned char *)(a); \
					register unsigned char *TL_ptr3 = \
						(unsigned char *)(b); \
					for (;TL_set; TL_set--) \
						*TL_ptr1++ = \
						    *TL_ptr2++ op *TL_ptr3++; \
				}
#define TLLRGSETINT(res,a,b)	TLLRGSETOP(res,a,b, &)
#define TLLRGSETUNION(res,a,b)	TLLRGSETOP(res,a,b, |)
#define TLLRGSETXOR(res,a,b)	TLLRGSETOP(res,a,b, ^)
#define TLLRGSETDIFF(res,a,b)	TLLRGSETOP(res,a,b, & ~)

#define TLLRGSETAOP(a,b,op)	{	\
					register int TL_set = sizeof(a); \
					register unsigned char *TL_ptr1 = \
						(unsigned char *)(a); \
					register unsigned char *TL_ptr2 = \
						(unsigned char *)(b); \
					for (;TL_set; TL_set--) \
						*TL_ptr1++ op *TL_ptr2++; \
				}
#define TLLRGSETAINT(a,b)	TLLRGSETAOP(a,b, &=)
#define TLLRGSETAUNION(a,b)	TLLRGSETAOP(a,b, |=)
#define TLLRGSETAXOR(a,b)	TLLRGSETAOP(a,b, ^=)
#define TLLRGSETADIFF(a,b)	TLLRGSETAOP(a,b, &= ~)

#define TLLRGSETCMP(res,a,b,op)	{	\
					register int TL_set = sizeof(a); \
					register unsigned char *TL_ptr1 = \
						(unsigned char *)(a); \
					register unsigned char *TL_ptr2 = \
						(unsigned char *)(b); \
					res = 1; \
					for (;TL_set; TL_set--) \
						if (*TL_ptr1++ op *TL_ptr2++) {\
							res = 0; \
							break; \
						} \
				}
#define TLLRGSETEQ(res,a,b)	TLLRGSETCMP(res,a,b, !=)
#define TLLRGSETNEQ(res,a,b)	TLLRGSETCMP(res,a,b, !=); res ^= 1
#define TLLRGSETLEQ(res,a,b)	TLLRGSETCMP(res,a,b, & ~)
#define TLLRGSETGEQ(res,a,b)	TLLRGSETCMP(res,b,a, & ~)

/*
 * Large Set helper function macros
 */
#define TLLRGSETCLRFCN(x)	TL_TLC_TLCCLR(x, sizeof(x))
#define TLLRGSETALLFCN(x)	TL_TLC_TLCALL(x, sizeof(x))
#define TLLRGSETCONSTFCN(s, v)	TL_TLC_TLCCON(s, v)
#define TLLRGSETINFCN(var,v,s)	var = TL_TLC_TLCIN(s, v)
#define TLLRGSETINTFCN(res,a,b)	TL_TLC_TLCINT(res, a, b, sizeof(res))
#define TLLRGSETUNIONFCN(res,a,b) TL_TLC_TLCUN(res, a, b, sizeof(res))
#define TLLRGSETXORFCN(res,a,b)	TL_TLC_TLCXOR(res, a, b, sizeof(res))
#define TLLRGSETDIFFFCN(res,a,b) TL_TLC_TLCDIF(res, a, b, sizeof(res))

#define TLLRGSETEQFCN(res,a,b)	res = TL_TLC_TLCEQ(a, b, sizeof(a))
#define TLLRGSETNEQFCN(res,a,b)	res = TL_TLC_TLCNEQ(a, b, sizeof(a))
#define TLLRGSETLEQFCN(res,a,b)	res = TL_TLC_TLCLEQ(a, b, sizeof(a))
#define TLLRGSETGEQFCN(res,a,b)	res = TL_TLC_TLCGEQ(a, b, sizeof(a))

/*
 * Bind and op= helper macros
 */
#define TLTMPPOINTER(t,var,type) register type t = var
#define TLBIND(t,type)		type t
#define TLBINDREG(t,type)	register type t


/*
 * Max, Min, Abs
 */
#define TLSIMPLEMAX(a,b)	((a) > (b) ? (a) : (b))
#define TLSIMPLEMIN(a,b)	((a) < (b) ? (a) : (b))
#define TLSIMPLEABS(a)		((a) < 0 ? -(a) : (a))


/*
 * Handler Macros
 */
#define TLHANDENTER(var)        (TL_TLE_TLEHE(&(var)), setjmp(var.savedState))


/*
 * Concurrency macros
 */

 /*
  * Regular monitors
  */
#define TLINITMONITOR(var,name) \
    TL_TLM_TLMRINI( &(var), name )
#define TLENTERMONITOR(var) \
    TL_TLM_TLMRENT( &(var) )
#define TLEXITMONITOR(var) \
    TL_TLM_TLMREXT(&(var))

 /*
  * Device monitors
  */
#define TLINITDEVICEMONITOR(var,name,prio) \
    TL_TLM_TLMDINI( &(var), name, (int) prio )
#define TLENTERDEVICEMONITOR(var) \
    TL_TLM_TLMDENT( &(var) )
#define TLEXITDEVICEMONITOR(var) \
    TL_TLM_TLMDEXT( &(var) )
#define TLINITINTRPROC(var,intNo,proc) \
    TL_TLM_TLMIPINI( &(var), (int) intNo, proc )
#define TLENTERINTRPROC(var)
#define TLEXITINTRPROC(var)

/*
 * synchronization
 */
#define TLSIGNALFUNC(var, fcn)	if ((var).signalQ.head != 0) fcn(&(var))
#define TLSIGNAL(var)		TLSIGNALFUNC(var, TL_TLM_TLMCRSIG)
#define TLSIGNALDEFERRED(var)	TLSIGNALFUNC(var, TL_TLM_TLMCDSIG)
#define TLSIGNALTIMEOUT(var)	TLSIGNALFUNC(var, TL_TLM_TLMCTSIG)
#define TLSIGNALPRIORITY(var)	TLSIGNALFUNC(var, TL_TLM_TLMCPSIG)

#define TLCSIGNALFUNC(var, fcn)	{\
				struct TLCOND	*TL__dummy = &var;\
				if (TL__dummy->signalQ.head != 0)\
				    fcn(TL__dummy);\
				}
#define TLCSIGNAL(var)		TLCSIGNALFUNC(var, TL_TLM_TLMCRSIG)
#define TLCSIGNALDEFERRED(var)	TLCSIGNALFUNC(var, TL_TLM_TLMCDSIG)
#define TLCSIGNALTIMEOUT(var)	TLCSIGNALFUNC(var, TL_TLM_TLMCTSIG)
#define TLCSIGNALPRIORITY(var)	TLCSIGNALFUNC(var, TL_TLM_TLMCPSIG)

/*
 * String helpers
 */
#define TLSTRCATASS(dest,src,size) TL_TLS_TLSCTA(dest, (int) size, src)
#define TLCHRSTRCMP(left,right,size) memcmp(left, right, size)

/*
 * checking routines
 */
#ifdef CHECKING

#define	TLASSERT(x)		if (!(x)) TL_TLE_TLEABT(11)
#define TLPRE(x)		if (!(x)) TL_TLE_TLEABT(6)
#define TLPOST(x)		if (!(x)) TL_TLE_TLEABT(7)
#define TLINVARIANT(x,y)	if (!(x)) TL_TLE_TLEABT(y)
#define TLRANGECHECK(x,low,high,abt) TL_TLE_TLECR(x,low,high,abt)
#define TLRANGECHECKSTRING(s,u,abt) ((unsigned char *) TL_TLE_TLECRS(s, u, abt))
#define TLDYN(x)		TL_TLE_TLECR(x,0,2147483647,2)
#define TLSTRASS(size,dest,src)	TL_TLS_TLSASN(dest,size,src)
#define TLINRANGE		TL_TLE_TLECR
#define TLINRANGELOW		TL_TLE_TLECRL
#define TLSUCC(x,upper)		(TL_TLE_TLECR(x, -2147483648, upper-1, 29)+1)
#define TLPRED(x,lower)		(TL_TLE_TLECR(x, lower+1, 2147483647, 28)-1)
#define TLCASEABORT		TL_TLE_TLEABT(15)
#define TLFCNRESULTABORT	TL_TLE_TLEABT(16)
#define TLSTACKCHECK()		{ \
				    char TL_dummy; \
				    if (((TLaddressint) &TL_dummy) < \
					    TL_TLCPD->stackLimit) { \
					TL_TLE_TLEABT(20); \
				    } \
				}

#define	TLSAVELF()		int TL_LINE = TL_TLCPD->lineAndFile; \
				struct TLFTAB *TL_FILE = TL_TLCPD->fileTable
#define	TLRESTORELF()		TL_TLCPD->lineAndFile = TL_LINE; \
				TL_TLCPD->fileTable = TL_FILE
#define	TLSETL(lf)		TL_TLCPD->lineAndFile = lf
#define	TLSETF()		TL_TLCPD->fileTable = (struct TLFTAB *) &TLFTAB
#define	TLINCL()		TL_TLCPD->lineAndFile++
#define	TLSTKCHKSLF(lf)		int TL_LINE; \
				struct TLFTAB *TL_FILE; \
				if (((TLaddressint) &TL_FILE) < \
					TL_TLCPD->stackLimit) { \
				    TLSETF(); \
				    TLSETL(lf); \
				    TL_TLE_TLEABT(20); \
				} \
				TL_LINE = TL_TLCPD->lineAndFile; \
				TL_FILE = TL_TLCPD->fileTable
#else

/* define these as null routines */
#define	TLASSERT(x)
#define TLPRE(x)
#define TLPOST(x)
#define TLINVARIANT(x,y)
#define TLDYN(x)			(x)
#define TLSUCC(x,y)			((x)+1)
#define TLPRED(x,y)			((x)-1)
#define TLSTRASS(size,dest,src)	(void) strcpy((char *)(dest), (char *)(src))
#define TLRANGECHECK(x,low,high,abt)	(x)
#define TLRANGECHECKSTRING(s,u,abt)	(s)
#define	TLINRANGE(x,low,high,abort)	(x)
#define TLINRANGELOW(x,low,high,abort)	((x)-(low))
#define TLCASEABORT
#define TLFCNRESULTABORT
#define TLSTACKCHECK()
#define	TLSAVELF()			char TL_dummy
#define	TLRESTORELF()
#define	TLSETL(lf)
#define	TLSETF()
#define	TLINCL()
#define	TLSTKCHKSLF(lf)

#endif

#define TLRESCHEDLOOP() TL_TLK_TLKRLOOP()
#define TLRESCHEDROUT() TL_TLK_TLKRROUT()

#endif /*ndef ___TPLUSC__*/
