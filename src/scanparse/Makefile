#
#    Compile the Turing Plus Scanner/parser pass
#
#    Syntax: make [big|dbug|dbbig|pc|bics|cms]
#
#

SYS = UNIX64

#TXFLAGS = -Aq4
#DEFINES = -DBIG -DDEBUG
DEFINES = -DBIG
TPCFLAGS = -w100000 -O -m$(SYS)
TPCLDFLAGS = -O -m$(SYS)

TPC = tpc
SHELL=/bin/sh

.SUFFIXES: .bd .t

.t.o: ;$(TPC) -c $(DEFINES) $(TPCFLAGS) $(TXFLAGS) $(LIB) $*.t
.bd.o: ;$(TPC) -c $(DEFINES) $(TPCFLAGS) $(TXFLAGS) $(LIB) $*.bd

scanparse.x:	scanparse.o parser.o scanner.o files.c
	$(TPC) $(TPCLDFLAGS) $(TXFLAGS) $(LIB) scanparse.o parser.o scanner.o files.c

install:	scanparse.x
	mv -f scanparse.x /usr/local/lib/tplus

scanparse.o:	scanner.st parser.st scanparse.t

parser.o:	parser.st parser.def.t parser.sst.t parser.bd scanner.st

scanner.o:	scanner.st scanner.bd scanner.def.t scanner.sst.t scanner.kwds \
	scanner.ascii scanner.ebcdic scanner.inc scanner.mac scanner.pp

scanner.def.t scanner.sst.t:	scanner.ssl
	tssl -+ -u $(ssl) scanner.ssl

parser.def.t parser.sst.t:	parser.ssl
	tssl -+ -u $(ssl) parser.ssl

clean:
	rm -f *.sst.t *.def.t files.o scanparse.o scanner.o \
	    parser.o err make.out scanparse.x
