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

t+toc.x:	$(MODS) t+toc.o
	tpc $(TPCLDFLAGS) $(TXFLAGS) $(LIB) -o t+toc.x t+toc.o $(MODS)

all:	t+toc.x

install:	all
	mv -f t+toc.x /usr/local/lib/tplus
	cp t+toc*.mdp /usr/local/lib/tplus
	-for i in UNIX LINUX OSX32 CYGWIN UNIX64 LINUX64 OSX64 CYGWIN64 ; \
	    do cp cinterface.h.$$i /usr/local/include/tplus/$$i/cinterface.h ; done

t+toc.o:	t+toc.t $(STUBS) t+toc.glb macdep.def predefined.def

expn.o:		expn.st t+toc.glb
error.o:	error.st error.def
transparam.o:	transparam.st
output.o:	output.st $(SOSTUBS) t+toc.glb
token.o:	token.st citoks.in t+toc.glb
transform.o:	transform.st t+toc.glb $(STSTUBS)
tree.o:		tree.st expn.st t+toc.glb
types.o:	types.st tree.st types.def t+toc.glb
arraystring.o:	arraystring.st arraystring.def t+toc.glb
identifier.o:	identifier.st
lineinfo.o:	lineinfo.st
transexpn.o:	transexpn.st $(STESTUBS)
transutil.o:	transutil.st
transutil2.o:	transutil2.st
macdep.o:	macdep.st macdep.def predefined.def
ctype.o:	ctype.st t+toc.glb
outputio.o:	outputio.st t+toc.glb
outputexpn.o:	outputexpn.st t+toc.glb
outpututil.o:	outpututil.st t+toc.glb toktoname.in
outpututil2.o:	outpututil2.st t+toc.glb
predefined.o:	predefined.st
util.o:		util.st
walker.o:	walker.st walker.def.t walker.sst.t walker.ops t+toc.glb

walker.sst.t walker.def.t:	walker.ssl
	tssl -+ -u $(ssl) walker.ssl

clean:
	rm -f walker.sst.t walker.def.t walker.sst t+toc.o make.out \
		t+toc.x $(MODS)
