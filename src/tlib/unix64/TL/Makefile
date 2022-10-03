OBJS=	TL.obj


#
# Default values.
#
TPC=	tpc
TFLAGS=

MAKE=	make
MKFLAGS=$(MFLAGS) -f Makefile

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
	@-cp $*.o checked/$*.o
#endif CHECKED
#ifdef UNCHECKED
	@-cp $*.o unchecked/$*.o
#endif UNCHECKED
	@rm -f $*.o
	@touch $*.obj

.c.obj:
	@rm -f $*.obj
#ifdef CHECKED
	@echo $(CC) -c -O -DCHECKED $(CFLAGS) $<
	@cd checked && $(CC) -c -O -DCHECKED $(CFLAGS) ../$<
#endif CHECKED
#ifdef UNCHECKED
	@echo $(CC) -c -O $(CFLAGS) $<
	@cd unchecked && $(CC) -c -O $(CFLAGS) ../$<
#endif UNCHECKED
	@touch $*.obj

.bd.obj .ch.obj:
	@rm -f $*.obj
#ifdef CHECKED
	@echo $(TPC) -cO -C -DCHECKED $(TFLAGS) $<
	@cd checked && $(TPC) -cO -C -DCHECKED $(TFLAGS) ../$<
#endif CHECKED
#ifdef UNCHECKED
	@echo $(TPC) -cO -C $(TFLAGS) $<
	@cd unchecked && $(TPC) -cO -C $(TFLAGS) ../$<
#endif UNCHECKED
	@touch $*.obj


TL.a:		DIRs $(OBJS) TLA.a TLB.a TLC.a TLE.a TLI.a TLM.a TLS.a LIBs


#ifdef CHECKED
DIRs:		checked
LIBs:		TLc.a
#endif CHECKED
#ifdef UNCHECKED
DIRs:		unchecked
LIBs:		TLu.a
#endif UNCHECKED


checked unchecked profiled dbx:
	@-mkdir $@


$(OBJS):	TL.def TL.var


DEFS=	TPC='$(TPC)' TFLAGS='$(TFLAGS)' CFLAGS='$(CFLAGS)'

TLA.a:		DIRs
	@cd TLA && $(MAKE) Makefile > /dev/null
	@cd TLA && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLB.a:		DIRs
	@cd TLB && $(MAKE) Makefile > /dev/null
	@cd TLB && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLC.a:		DIRs
	@cd TLC && $(MAKE) Makefile > /dev/null
	@cd TLC && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLE.a:		DIRs
	@cd TLE && $(MAKE) Makefile > /dev/null
	@cd TLE && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLI.a:		DIRs
	@cd TLI && $(MAKE) Makefile > /dev/null
	@cd TLI && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLM.a:		DIRs
	@cd TLM && $(MAKE) Makefile > /dev/null
	@cd TLM && $(MAKE) $(MKFLAGS) $(DEFS) $@

TLS.a:		DIRs
	@cd TLS && $(MAKE) Makefile > /dev/null
	@cd TLS && $(MAKE) $(MKFLAGS) $(DEFS) $@


#ifdef CHECKED
TLc.a:		$(OBJS) TLA/TLA.a TLB/TLB.a TLC/TLC.a \
		TLE/TLE.a TLI/TLI.a TLM/TLM.a TLS/TLS.a
	@echo 'Creating machine-independent checked library'
	@rm -fr $@
	@-cd checked && ar cr ../$@ *.o
#endif CHECKED

#ifdef UNCHECKED
TLu.a:		$(OBJS) TLA/TLA.a TLB/TLB.a TLC/TLC.a \
		TLE/TLE.a TLI/TLI.a TLM/TLM.a TLS/TLS.a
	@echo 'Creating machine-independent unchecked library'
	@rm -fr $@
	@-cd unchecked && ar cr ../$@ *.o
#endif UNCHECKED

# So "make -n" doesn't get confused:
TLA/TLA.a TLB/TLB.a TLC/TLC.a TLE/TLE.a TLI/TLI.a TLM/TLM.a TLS/TLS.a:


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
	@cd TLA && $(MAKE) $(MFLAGS) $@
	@cd TLB && $(MAKE) $(MFLAGS) $@
	@cd TLC && $(MAKE) $(MFLAGS) $@
	@cd TLE && $(MAKE) $(MFLAGS) $@
	@cd TLI && $(MAKE) $(MFLAGS) $@
	@cd TLM && $(MAKE) $(MFLAGS) $@
	@cd TLS && $(MAKE) $(MFLAGS) $@
	rm -f $(OBJS)
	rm -fr checked unchecked profiled dbx
	rm -f TLc.a TLu.a *.o
	rm -f core err errs make.err make.log make.out
	rm -f Make.c Make.u .make.state
