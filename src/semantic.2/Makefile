#
#    Compile the Turing Semantic pass
#
#    Syntax: make [big|dbug|dbbig|pc]
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

.SUFFIXES: .bd .t .ch

.t.o: ;$(TPC) -c $(DEFINES) $(TPCFLAGS) $(TXFLAGS) $(LIB) $*.t
.bd.o: ;$(TPC) -c $(DEFINES) $(TPCFLAGS) $(TXFLAGS) $(LIB) $*.bd
.ch.o: ;$(TPC) -c $(DEFINES) $(TPCFLAGS) $(TXFLAGS) $(LIB) $*.ch

MODS = 	emit.o context.o count.o \
	scope.o symbol.o type.o error.o value.o predefined.o substring.o

STUBS =	emit.st context.st count.st \
	scope.st symbol.st type.st error.st value.st predefined.st \
	substring.st

OPS =	context.ops count.ops emit.ops \
	scope.ops symbol.ops type.ops value.ops predefined.ops \
	substring.ops

semantic2.x:	semantic.o $(MODS) 
	tpc $(TPCLDFLAGS) $(TXFLAGS) $(LIB) -o semantic2.x semantic.o $(MODS)

install:	semantic2.x
	mv -f semantic2.x /usr/local/lib/tplus

semantic.o:	semantic.t $(STUBS) semantic.def.t semantic.sst.t \
		ident.mod $(OPS) semantic.def semantic.lim

value.o:	value.st semantic.def semantic.lim
context.o:	context.st semantic.def semantic.lim
count.o:	count.st semantic.def semantic.lim
scope.o:	scope.st semantic.def semantic.lim
type.o:		type.st semantic.def semantic.lim
symbol.o:	symbol.st semantic.def semantic.lim
emit.o:		emit.st value.st semantic.def semantic.lim
predefined.o:	predefined.st symbol.st scope.st value.st type.st \
		    semantic.def semantic.lim
substring.o:	substring.st semantic.def
error.o:	error.st semerr.msg

semantic.def.t semantic.sst.t:	semantic.ssl
	tssl -+ -u $(ssl) semantic.ssl

clean:
	rm -f *.sst.t *.def.t semantic.o semantic2.x $(MODS) DumpAllMsgs.x
	rm -f make.out make.log
