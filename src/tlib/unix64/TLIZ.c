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

#if UNIX32
    #include <UNIX32/cinterface.h>
#else
    #include <UNIX64/cinterface.h>
#endif 

// #pragma GCC diagnostic ignored "-Wbuiltin-requires-header"
#pragma -w

typedef	TLnat4	TL_TL_priority_t;
struct	TL_TL_ExceptionInfo {
    TLint4	quitCode;
    TLint4	libraryQuitCode;
    TLstring	errorMsg;
};
typedef	TLnat1	__x737[1];
struct	TL_TL_HandlerArea {
    TLint4	quitCode;
    TLnat4	lineAndFile;
    TLaddressint	fileTable;
    struct TL_TL_HandlerArea	*nextHandler;
    __x737	savedState;
};
typedef	TLnat4	TL_sigmask;
typedef	void 	TL_sigproc();
typedef	TL_sigmask	TL_TL_hardwarePriority_t;
typedef	TL_TL_hardwarePriority_t	TL_TL_lockStatus_t;
typedef	TLnat4	TL_TL_lock_t;
struct	TL_TL_link_t {
    struct TL_TL_ProcessDescriptor	*flink;
    struct TL_TL_ProcessDescriptor	*blink;
};
struct	TL_TL_ProcessDescriptor {
    TLnat4	lineAndFile;
    TLaddressint	fileTable;
    TLaddressint	stackLimit;
    TLaddressint	stackPointer;
    struct TL_TL_HandlerArea	*handlerQhead;
    struct TL_TL_HandlerArea	*currentHandler;
    TLaddressint	name;
    struct TL_TL_ExceptionInfo	exception;
    TLnat4	waitParameter;
    struct TL_TL_ProcessDescriptor	*monitorQlink;
    TLnat4	timeOutStatus;
    TLnat4	pid;
    TLaddressint	memoryBase;
    TLnat4	timeoutTime;
    TLnat4	timeoutEpoch;
    struct TL_TL_link_t	timeoutQ;
    TLboolean	timedOut;
    TLboolean	pausing;
    TL_TL_priority_t	dispatchPriority;
    struct TL_TL_ProcessDescriptor	*runQlink;
    TLboolean	ready;
    struct TL_TL_ProcessDescriptor	*tsyncWaiter;
    TLnat4	quantum;
    TLnat4	quantumCntr;
    TLnat4	devmonLevel;
    TLaddressint	otherInfo;
};

extern void TL_TLM_TLMUDUMP ();

extern void TL_TLB_TLBMAL ();

extern void TL_TLB_TLBMFR ();

extern void TL_TLB_TLBNWU ();

extern void TL_TLB_TLBFRU ();

extern void TL_TLI_TLIFS ();

extern void TL_TLI_TLIAON ();

extern void TL_TLI_TLIAOFF ();

extern void TL_TLI_TLIUDUMP ();

extern void TL_TLI_TLIFINI ();

extern void TL_TLE_TLELF ();
typedef	TLint4	TL_Cint;
extern TLboolean	TL_TLECU;
extern struct TL_TL_ProcessDescriptor	*TL_TLKPD;

void TL_TLQUIT ();

extern void TL_TLK_TLKINI ();

extern void TL_TLK_TLKFINI ();

extern void TL_TLK_TLKUXRS ();

extern void TL_TLK_TLKUXRE ();

extern void TL_TLK_TLKUEXIT ();

extern void TL_TLK_TLKUDMPP ();

extern void TL_TLK_TLKPFORK ();

extern TLboolean TL_TLK_TLKFRKED ();

extern void TL_TLK_TLKLKON ();

extern void TL_TLK_TLKLKOFF ();

extern void TL_TLK_TLKSSYNC ();

extern void TL_TLK_TLKSWAKE ();

extern void TL_TLK_TLKSTIMO ();

extern void TL_TLK_TLKCINI ();

extern TLnat4 TL_TLK_TLKPGETP ();

extern void TL_TLK_TLKPSETP ();

extern void TL_TLK_TLKIPINI ();

extern void TL_TLK_TLKIPENT ();

extern void TL_TLK_TLKIPEXT ();

extern TLboolean TL_TLK_TLKDMINI ();

extern void TL_TLK_TLKDMENT ();

extern void TL_TLK_TLKDMEXT ();

extern void TL_TLK_TLKPPAUS ();

extern void TL_TLX_TLXPID ();

extern void TL_TLX_TLXTIM ();

extern void TL_TLX_TLXATF ();

extern void TL_TLX_TLXDT ();

extern void TL_TLX_TLXTM ();

extern void TL_TLX_TLXCL ();

extern void TL_TLX_TLXSC ();

extern void TL_TLX_TLXGE ();

extern void TL_TLX_TLXSYS ();

extern void TL_TLA_TLAVES ();

extern void TL_TLA_TLAVFS ();

extern void TL_TLA_TLAVS8 ();

extern void TL_TLA_TLAVSI ();

extern void TL_TLA_TLAVSN ();
typedef	TLint4	TL_TLI_StreamNumberType;
typedef	TLnat2	TL_TLI_StreamModeSet;
struct	TL_TLI_StreamEntryType {
    TLaddressint	fileName;
    TLaddressint	info;
    TL_Cint	lastOp;
    TL_TLI_StreamModeSet	mode;
    TLboolean	atEof;
    struct TL_TL_ProcessDescriptor	*waitingForInput;
};
typedef	TLaddressint	TL_TLI___x740[21];
typedef	TL_TLI___x740	TL_TLI_ArgList;
typedef	TLchar	TL_TLI___x743[16];
typedef	TL_TLI___x743	TL_TLI___x742[3];
typedef	struct TL_TLI_StreamEntryType	TL_TLI___x744[33];
extern TL_TLI___x744	TL_TLI_TLIS;
extern TLboolean	TL_TLI_TLIUXS;
extern TLint4	TL_TLI_TLIXSN;
extern TLaddressint	TLIstdin;
extern TLaddressint	TLIstdout;
extern TLaddressint	TLIstderr;
extern TLint4	TL_TLI_TLIARC;
extern TLaddressint	TL_TLI_TLIARV;
typedef	TLchar	TL_TLI___x748[42];
extern TL_TLI___x748	TL_TLI_TLIPXL;
typedef	TLchar	TL_TLI___x749[44];
extern TL_TLI___x749	TL_TLI_TLIPXN;
extern TLaddressint 	(*TL_TLI_TLIFOP)();
extern void 	(*TL_TLI_TLIFFL)();
extern void 	(*TL_TLI_TLIFCL)();
extern TL_Cint 	(*TL_TLI_TLIFGC)();
extern void 	(*TL_TLI_TLIFUG)();
extern void 	(*TL_TLI_TLIFPC)();
extern void 	(*TL_TLI_TLIFPS)();
extern void 	(*TL_TLI_TLIFSK)();
extern TLint4 	(*TL_TLI_TLIFTL)();
extern TL_Cint 	(*TL_TLI_TLIFRE)();
extern TL_Cint 	(*TL_TLI_TLIFWR)();
extern void 	(*TL_TLI_TLIFZ)();

extern void TL_TLI_TLIGT ();

extern void TL_TLI_TLIOS ();

extern void TL_TLI_TLIFS ();

extern void TL_TLI_TLIWRR ();

extern void TL_TLI_TLIPS ();

extern void TL_TLI_TLIRER ();

extern void TL_TLI_TLISS ();

extern void TL_TLI_TLIUDUMP ();

extern void TL_TLI_TLIAON ();

extern void TL_TLI_TLIAOFF ();

extern void TL_TLI_TLIFINI ();
static TL_sigproc	(*TL_TLI_TLIZ_BADSIG);
static TL_sigproc	(*TL_TLI_TLIZ_SIG_DFL);
static TL_sigproc	(*TL_TLI_TLIZ_SIG_IGN);
typedef	TL_sigproc	(*TL_TLI_TLIZ___x755);

extern TL_TLI_TLIZ___x755 signal ();

// extern TLint4 kill ();
extern TLaddressint	TLIstdin;
extern TLaddressint	TLIstdout;
extern TLaddressint	TLIstderr;
static TLboolean	TL_TLI_TLIZ_TLIAIE;

extern void TLIsaveFlags ();

extern void TLIrestoreFlags ();

extern void TLIenableSIGIO ();

extern void TLIdisableSIGIO ();

extern void TLIcatchSIGIO ();

static void TL_TLI_TLIZ_SigHandler () {
    struct TL_TL_ProcessDescriptor	*pd;
    TLIdisableSIGIO();
    pd = TL_TLI_TLIS[0].waitingForInput;
    if (pd != ((struct TL_TL_ProcessDescriptor *) 0)) {
	TL_TLI_TLIS[0].waitingForInput = (struct TL_TL_ProcessDescriptor *) 0;
	TL_TLK_TLKSSYNC(pd);
    };
}

void TL_TLI_TLIAON () {

    extern TLboolean isatty ();
    if ((!TL_TLI_TLIZ_TLIAIE) && isatty((TL_Cint) 0)) {
	TLIcatchSIGIO(TL_TLI_TLIZ_SigHandler);
	TL_TLI_TLIZ_TLIAIE = 1;
    };
}

void TL_TLI_TLIAOFF () {
    TL_TLI_TLIZ_TLIAIE = 0;
}

void TL_TLI_TLIFINI () {
    TLIrestoreFlags();
}

static void TL_TLI_TLIZ_WaitForInput () {
    if (TL_TLI_TLIZ_TLIAIE) {
	if ((TL_TLI_TLIS[0].waitingForInput) != ((struct TL_TL_ProcessDescriptor *) 0)) {
	    TL_TLQUIT("Concurrent asynchronous input from stdin not allowed.", (TLint4) 88);
	};
	TL_TLK_TLKDMENT((TLint4) ((TLnat4) 0xFEBFFEEA));
	TLIenableSIGIO();
	for(;;) {

	    extern TLboolean TLIinputAvail ();
	    if (TLIinputAvail()) {
		break;
	    };
	    TL_TLI_TLIS[0].waitingForInput = TL_TLKPD;
	    TL_TLK_TLKSSYNC(TL_TLKPD);
	};
	TLIdisableSIGIO();
	TL_TLK_TLKDMEXT();
    };
}

void TL_TLI_TLIUDUMP () {
    if ((TL_TLI_TLIS[0].waitingForInput) != ((struct TL_TL_ProcessDescriptor *) 0)) {
	TL_TLI_TLISS ((TLint4) 0, (TLint2) 2);
	TL_TLI_TLIPS ((TLint4) 0, "\n****** Waiting for I/O:\n", (TLint2) 0);
	TL_TLK_TLKUDMPP(TL_TLI_TLIS[0].waitingForInput);
    };
}

extern TLaddressint fopen ();

extern void fflush ();

extern void fclose ();

extern TL_Cint fgetc ();

extern void ungetc ();

extern void fputc ();

extern void fputs ();

extern void fseek ();

extern TLint4 ftell ();

extern TL_Cint fread ();

extern TL_Cint fwrite ();

extern void TLIreset ();

static TL_Cint TL_TLI_TLIZ_FgetcAsync (stream)
TLaddressint	stream;
{
    TL_Cint	tmp;
    if ((unsigned long) stream == (unsigned long) TLIstdin) {
	TL_TLI_TLIZ_WaitForInput();
    };
    TL_TLK_TLKUXRS();
    tmp = fgetc((TLaddressint) stream);
    TL_TLK_TLKUXRE();
    return (tmp);
    /* NOTREACHED */
}

static TLaddressint TL_TLI_TLIZ_Fopen (fileName, fileMode)
TLstring	fileName;
TLstring	fileMode;
{
    TLaddressint	tmp;
    TL_TLK_TLKUXRS();
    tmp = (TLaddressint) fopen(fileName, fileMode);
    TL_TLK_TLKUXRE();
    return ((TLaddressint) tmp);
    /* NOTREACHED */
}

static void TL_TLI_TLIZ_Fflush (stream)
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    fflush((TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

static void TL_TLI_TLIZ_Fclose (stream)
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    fclose((TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

static void TL_TLI_TLIZ_Ungetc (oopsChar, stream)
TL_Cint	oopsChar;
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    ungetc((TL_Cint) oopsChar, (TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

static void TL_TLI_TLIZ_Fputc (outChar, stream)
TLchar	outChar;
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    fputc((TLchar) outChar, (TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

static void TL_TLI_TLIZ_Fputs (stringPtr, stream)
TLstring	stringPtr;
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    fputs(stringPtr, (TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

static void TL_TLI_TLIZ_Fseek (stream, offset, offsetType)
TLaddressint	stream;
TLint4	offset;
TL_Cint	offsetType;
{
    TL_TLK_TLKUXRS();
    fseek((TLaddressint) stream, (TLint4) offset, (TL_Cint) offsetType);
    TL_TLK_TLKUXRE();
}

static TLint4 TL_TLI_TLIZ_Ftell (stream)
TLaddressint	stream;
{
    TLint4	tmp;
    TL_TLK_TLKUXRS();
    tmp = ftell((TLaddressint) stream);
    TL_TLK_TLKUXRE();
    return (tmp);
    /* NOTREACHED */
}

static TL_Cint TL_TLI_TLIZ_Fread (objAddr, byteSize, objSize, stream)
TLaddressint	objAddr;
TL_Cint	byteSize;
TL_Cint	objSize;
TLaddressint	stream;
{
    TL_Cint	tmp;
    TL_TLK_TLKUXRS();
    tmp = fread((TLaddressint) objAddr, (TL_Cint) byteSize, (TL_Cint) objSize, (TLaddressint) stream);
    TL_TLK_TLKUXRE();
    return (tmp);
    /* NOTREACHED */
}

static TL_Cint TL_TLI_TLIZ_Fwrite (objAddr, byteSize, objSize, stream)
TLaddressint	objAddr;
TL_Cint	byteSize;
TL_Cint	objSize;
TLaddressint	stream;
{
    TL_Cint	tmp;
    TL_TLK_TLKUXRS();
    tmp = fwrite((TLaddressint) objAddr, (TL_Cint) byteSize, (TL_Cint) objSize, (TLaddressint) stream);
    TL_TLK_TLKUXRE();
    return (tmp);
    /* NOTREACHED */
}

static void TL_TLI_TLIZ_Freset (stream)
TLaddressint	stream;
{
    TL_TLK_TLKUXRS();
    TLIreset((TLaddressint) stream);
    TL_TLK_TLKUXRE();
}

void TL_TLI_TLIZ () {
    (* (TLint4 *) &(TL_TLI_TLIZ_BADSIG)) = -1;
    (* (TLint4 *) &(TL_TLI_TLIZ_SIG_DFL)) = 0;
    (* (TLint4 *) &(TL_TLI_TLIZ_SIG_IGN)) = 1;
    TL_TLI_TLIS[0].mode = 0xA;
    TL_TLI_TLIS[1].mode = 0x14;
    TL_TLI_TLIS[2].mode = 0x14;
    TL_TLI_TLIZ_TLIAIE = 0;
    TLIsaveFlags();
    TL_TLI_TLIFOP = TL_TLI_TLIZ_Fopen;
    TL_TLI_TLIFFL = TL_TLI_TLIZ_Fflush;
    TL_TLI_TLIFCL = TL_TLI_TLIZ_Fclose;
    TL_TLI_TLIFGC = TL_TLI_TLIZ_FgetcAsync;
    TL_TLI_TLIFUG = TL_TLI_TLIZ_Ungetc;
    TL_TLI_TLIFPC = TL_TLI_TLIZ_Fputc;
    TL_TLI_TLIFPS = TL_TLI_TLIZ_Fputs;
    TL_TLI_TLIFSK = TL_TLI_TLIZ_Fseek;
    TL_TLI_TLIFTL = TL_TLI_TLIZ_Ftell;
    TL_TLI_TLIFRE = TL_TLI_TLIZ_Fread;
    TL_TLI_TLIFWR = TL_TLI_TLIZ_Fwrite;
    TL_TLI_TLIFZ = TL_TLI_TLIZ_Freset;
}
