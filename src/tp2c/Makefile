#
#    Compile the Turing Plus To C Translator pass
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

MODS = 	walker.o expn.o token.o tree.o error.o types.o output.o \
	ctype.o identifier.o transform.o outputio.o outputexpn.o \
	lineinfo.o transexpn.o arraystring.o transparam.o macdep.o \
	transassign.o transutil.o util.o predefined.o outpututil.o \
	outpututil2.o transutil2.o trexpnutil.o

# secondary stubs
SOSTUBS = outputio.st outputexpn.st outpututil.st outpututil2.st
STSTUBS = transexpn.st transparam.st transassign.st \
	  transutil.st transutil2.st
STESTUBS = trexpnutil.st

STUBS =	expn.st token.st tree.st types.st walker.st output.st transform.st \
	predefined.st arraystring.st ctype.st lineinfo.st identifier.st \
	util.st macdep.st

tp2c.x:	$(MODS) tp2c.o
	tpc $(TPCLDFLAGS) $(TXFLAGS) $(LIB) -o tp2c.x tp2c.o $(MODS)

all:	tp2c.x

install:	all
	mv -f tp2c.x /usr/local/lib/tplus
	cp tp2c*.mdp /usr/local/lib/tplus
	-for i in UNIX LINUX OSX32 CYGWIN UNIX64 LINUX64 OSX64 CYGWIN64 ; \
	    do cp cinterface.h.$$i /usr/local/include/tplus/$$i/cinterface.h ; done

tp2c.o:	tp2c.t $(STUBS) tp2c.glb macdep.def predefined.def

expn.o:		expn.st tp2c.glb
error.o:	error.st error.def
transparam.o:	transparam.st
output.o:	output.st $(SOSTUBS) tp2c.glb
token.o:	token.st citoks.in tp2c.glb
transform.o:	transform.st tp2c.glb $(STSTUBS)
tree.o:		tree.st expn.st tp2c.glb
types.o:	types.st tree.st types.def tp2c.glb
arraystring.o:	arraystring.st arraystring.def tp2c.glb
identifier.o:	identifier.st
lineinfo.o:	lineinfo.st
transexpn.o:	transexpn.st $(STESTUBS)
transutil.o:	transutil.st
transutil2.o:	transutil2.st
macdep.o:	macdep.st macdep.def predefined.def
ctype.o:	ctype.st tp2c.glb
outputio.o:	outputio.st tp2c.glb
outputexpn.o:	outputexpn.st tp2c.glb
outpututil.o:	outpututil.st tp2c.glb toktoname.in
outpututil2.o:	outpututil2.st tp2c.glb
predefined.o:	predefined.st
util.o:		util.st
walker.o:	walker.st walker.def.t walker.sst.t walker.ops tp2c.glb

walker.sst.t walker.def.t:	walker.ssl
	tssl -+ -u $(ssl) walker.ssl

clean:
	rm -f walker.sst.t walker.def.t walker.sst tp2c.o make.out \
		tp2c.x $(MODS)
