MOD=	TLA
OBJS=	TLA.obj \
	TLA4AD.obj \
	TLA4CM.obj \
	TLA4DN.obj \
	TLA4DV.obj \
	TLA4ML.obj \
	TLA4MN.obj \
	TLA4MX.obj \
	TLA8AD.obj \
	TLA8CD.obj \
	TLA8CL.obj \
	TLA8CM.obj \
	TLA8CR.obj \
	TLA8DN.obj \
	TLA8DV.obj \
	TLA8FL.obj \
	TLA8GX.obj \
	TLA8LN.obj \
	TLA8MD.obj \
	TLA8ML.obj \
	TLA8MN.obj \
	TLA8MX.obj \
	TLA8QR.obj \
	TLA8RD.obj \
	TLA8RE.obj \
	TLA8SD.obj \
	TLA8SG.obj \
	TLA8SR.obj \
	TLA8SX.obj \
	TLA8T.obj \
	TLA8TD.obj \
	TLA8TR.obj \
	TLA8X.obj \
	TLA8XP.obj \
	TLAIMD.obj \
	TLAIMN.obj \
	TLAIMX.obj \
	TLANMD.obj \
	TLAPII.obj \
	TLAPRI.obj \
	TLAPRR.obj \
	TLARNI.obj \
	TLARNR.obj \
	TLARNZ.obj \
	TLARSC.obj \
	TLARSR.obj \
	TLARSZ.obj \
	TLARZ.obj \
	TLAV48.obj \
	TLAV84.obj \
	TLAV8D.obj \
	TLAVD8.obj \
	TLAVES.obj \
	TLAVFS.obj \
	TLAVI4.obj \
	TLAVI8.obj \
	TLAVN4.obj \
	TLAVN8.obj \
	TLAVRS.obj \
	TLAVS8.obj \
	TLAVSI.obj \
	TLAVSN.obj


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
