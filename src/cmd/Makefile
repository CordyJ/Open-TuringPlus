#
#    Compile the Turing Plus Driver program tpc
#
#    Syntax: make tpc 
#
#

SYS=UNIX64

DEFINES = -D$(SYS)
TPCFLAGS = -O -C -m$(SYS)

TPC = tpc
SHELL=/bin/sh

SRCS= 	tpc.t signal.c callsys.c 

STUBS =	callsys.st signal.st

all:	tpc

tpc:	$(SRCS) ${STUBS}
	$(TPC) $(TPCFLAGS) $(DEFINES) $(LIB) -o tpc.x $(SRCS)
	mv tpc.x tpc

install:	all
		cp tpc /usr/local/bin
		rm tpc
clean:
	rm -f tpc *.o err make.out make.log
