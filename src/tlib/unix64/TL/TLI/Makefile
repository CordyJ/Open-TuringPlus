MOD=	TLI
OBJS=	TLI.obj \
	TLICL.obj \
	TLIEFR.obj \
	TLIEOF.obj \
	TLIFA.obj \
	TLIFS.obj \
	TLIGC.obj \
	TLIGCB.obj \
	TLIGF.obj \
	TLIGI.obj \
	TLIGIB.obj \
	TLIGK.obj \
	TLIGN.obj \
	TLIGR.obj \
	TLIGS.obj \
	TLIGSS.obj \
	TLIGSW.obj \
	TLIGT.obj \
	TLIOA.obj \
	TLIOF.obj \
	TLIOP.obj \
	TLIOS.obj \
	TLIPC.obj \
	TLIPE.obj \
	TLIPF.obj \
	TLIPI.obj \
	TLIPK.obj \
	TLIPN.obj \
	TLIPR.obj \
	TLIPS.obj \
	TLIRE.obj \
	TLIRER.obj \
	TLISF.obj \
	TLISK.obj \
	TLISKE.obj \
	TLISS.obj \
	TLISSI.obj \
	TLISSO.obj \
	TLISSS.obj \
	TLITL.obj \
	TLIWR.obj \
	TLIWRR.obj


#
# Default values.
#
TPC=	tpc
TFLAGS=

SHELL=	/bin/sh


#.KEEP_STATE:


.SUFFIXES:
.SUFFIXES:	.obj .ch .bd .c .s

.s.bd .s.ch .s.c .c.bd .c.ch:
	@rm -f $<

.s.obj:
	@rm -f $*.obj
	$(AS) -o $*.o $(ASFLAGS) $<
#ifdef CHECKED
	@-cp $*.o ../checked/$*.o
#endif CHECKED
#ifdef UNCHECKED
	@-cp $*.o ../unchecked/$*.o
#endif UNCHECKED
	@rm -f $*.o
	@touch $*.obj

.c.obj:
	@rm -f $*.obj
#ifdef CHECKED
	@echo $(CC) -c -O -DCHECKED $(CFLAGS) $<
	@cd ../checked && $(CC) -c -O -DCHECKED $(CFLAGS) ../$(MOD)/$<
#endif CHECKED
#ifdef UNCHECKED
	@echo $(CC) -c -O $(CFLAGS) $<
	@cd ../unchecked && $(CC) -c -O $(CFLAGS) ../$(MOD)/$<
#endif UNCHECKED
	@touch $*.obj

.bd.obj .ch.obj:
	@rm -f $*.obj
#ifdef CHECKED
	@echo $(TPC) -cO -C -DCHECKED $(TFLAGS) $<
	@cd ../checked && $(TPC) -cO -C -DCHECKED $(TFLAGS) ../$(MOD)/$<
#endif CHECKED
#ifdef UNCHECKED
	@echo $(TPC) -cO -C $(TFLAGS) $<
	@cd ../unchecked && $(TPC) -cO -C $(TFLAGS) ../$(MOD)/$<
#endif UNCHECKED
	@touch $*.obj


$(MOD).a:	$(OBJS)
	@touch $@


$(OBJS):	$(MOD).def $(MOD).var


#ifndef Makefile
Make.c:		Makefile
	@sed -e '/^#ifndef CHECKED/,/^#endif CHECKED/d' \
	    -e '/^#ifdef UNCHECKED/,/^#endif UNCHECKED/d' \
	    -e '/^#ifndef Makefile/,/^#endif Makefile/d' \
	    -e '/^#/d' -e 's/Makefile/$@/g' Makefile > $@

Make.u:		Makefile
	@sed -e '/^#ifdef CHECKED/,/^#endif CHECKED/d' \
	    -e '/^#ifndef UNCHECKED/,/^#endif UNCHECKED/d' \
	    -e '/^#ifndef Makefile/,/^#endif Makefile/d' \
	    -e '/^#/d' -e 's/Makefile/$@/g' Makefile > $@
#endif Makefile


clean:
	rm -f $(OBJS)
	rm -f $(MOD).a *.o
	rm -f core err errs make.err make.log make.out
	rm -f Make.c Make.u .make.state
