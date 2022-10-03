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

MODS = 	actuals.o context.o count.o loop.o \
	scope.o symbol.o type.o error.o predefined.o emit.o

STUBS =	actuals.st context.st count.st loop.st \
	scope.st symbol.st type.st error.st predefined.st emit.st

OPS =	actuals.ops context.ops count.ops emit.ops loop.ops \
	scope.ops symbol.ops type.ops predefined.st

semantic1.x:	semantic.o $(MODS)
	tpc $(TPCLDFLAGS) $(TXFLAGS) $(LIB) -o semantic1.x semantic.o $(MODS)

install:	semantic1.x
	mv -f semantic1.x /usr/local/lib/tplus

semantic.o:	semantic.t $(STUBS) semantic.def.t semantic.sst.t \
		ident.mod $(OPS) semantic.def semantic.lim

actuals.o:	actuals.st semantic.def semantic.lim
context.o:	context.st semantic.def semantic.lim
count.o:	count.st semantic.def semantic.lim
emit.o:		emit.st semantic.def semantic.lim
loop.o:		loop.st semantic.def semantic.lim
scope.o:	scope.st semantic.def semantic.lim
type.o:		type.st semantic.def semantic.lim
symbol.o:	symbol.st semantic.def semantic.lim
error.o:	error.st semerr.msg
predefined.o:	predefined.st

semantic.def.t semantic.sst.t:	semantic.ssl
	tssl -+ -u $(ssl) semantic.ssl

clean:
	rm -f *.sst.t *.def.t semantic.o semantic1.x $(MODS) DumpAllMsgs.x
	rm -f make.out make.log

list:
	lpr -p semantic.ssl semantic.t *.ops *.st *.bd semerr.msg \
	    semantic.glb semantic.lim
