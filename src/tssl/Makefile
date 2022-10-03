#
# Compile the Turing S/SL Processor
#

SYS = UNIX64

#TXFLAGS = -Aq4
#DEFINES = -DBIG -DDEBUG
DEFINES = -DBIG
TPCFLAGS = -w100000 -O -m$(SYS)
TPCLDFLAGS = -O -m$(SYS)

TPC = tpc
SHELL=/bin/sh

SSL= tssl
SSLFLAGS=-+ -u

ssl.x: ssl.o
	$(TPC) $(TPCLDFLAGS) $(TXFLAGS) ssl.o

ssl.o: ssl.t ssl.sst.t
	$(TPC) -c $(TPCFLAGS) $(TXFLAGS) ssl.t

ssl.sst.t: ssl.ssl
	$(SSL) $(SSLFLAGS) ssl.ssl

install:	ssl.x
	mv -f ssl.x /local/lib/tplus

clean:
	rm -f ssl.x ssl.o make.out make.err err errs
