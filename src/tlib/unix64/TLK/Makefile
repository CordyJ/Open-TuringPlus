MOD=	TLK
OBJS=	TLK.obj \
	TLKCINI.obj \
	TLKCS.obj \
	TLKDMENT.obj \
	TLKDMEXT.obj \
	TLKDMINI.obj \
	TLKFINI.obj \
	TLKFRKED.obj \
	TLKINI.obj \
	TLKIPENT.obj \
	TLKIPEXT.obj \
	TLKIPINI.obj \
	TLKLKOFF.obj \
	TLKLKON.obj \
	TLKPCS.obj \
	TLKPDINI.obj \
	TLKPFORK.obj \
	TLKPGETP.obj \
	TLKPGID.obj \
	TLKPPAUS.obj \
	TLKPRUN.obj \
	TLKPSETP.obj \
	TLKPSID.obj \
	TLKRGETP.obj \
	TLKRLOOP.obj \
	TLKRQD.obj \
	TLKRQI.obj \
	TLKRROUT.obj \
	TLKRSETP.obj \
	TLKSP.obj \
	TLKSSYNC.obj \
	TLKSTIMO.obj \
	TLKSWAKE.obj \
	TLKTQD.obj \
	TLKTQI.obj \
	TLKTQR.obj \
	TLKTQU.obj \
	TLKUDMPA.obj \
	TLKUDMPP.obj \
	TLKUEXIT.obj \
	TLKUXRE.obj \
	TLKUXRS.obj


#
# Default values.
#
TPC= tpc
TFLAGS= 
CFLAGS=	


SHELL=	/bin/sh


#.KEEP_STATE:


.SUFFIXES:
.SUFFIXES:	.obj .ch .bd .c .s

.s.bd .s.ch .s.c .c.bd .c.ch:
	@rm -f $<

.c.obj .s.obj:
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
	@echo $(TPC) -cO -DCHECKED $(TFLAGS) $<
	@cd ../checked && $(TPC) -cO -DCHECKED $(TFLAGS) ../$(MOD)/$<
#endif CHECKED
#ifdef UNCHECKED
	@echo $(TPC) -cO $(TFLAGS) $<
	@cd ../unchecked && $(TPC) -cO $(TFLAGS) ../$(MOD)/$<
#endif UNCHECKED
	@touch $*.obj


$(MOD).a:	$(OBJS)
	@touch $@


$(OBJS):	$(MOD).var


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
