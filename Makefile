# Turing+ Version 6.2 production build process
# J.R. Cordy, October 2022

# Copyright 2022, James R. Cordy and others

# This process builds the production Turing+ compiler and command line tools.

# Default system type
SYS = UNIX64

# Main 
all : commands passes libs machdeps scripts includes distrib

# Runtime libraries
libs : lib/tlib$(SYS).a lib/tlib$(SYS)u.a 

lib/tlib$(SYS).a : lib
	cd src/tlib/$(SYS); make; cd ../..
	cp src/tlib/$(SYS)/tlib$(SYS).a lib/tlib$(SYS).a

lib/tlib$(SYS)u.a : lib lib/tlib$(SYS).a
	cp src/tlib/$(SYS)/tlib$(SYS)u.a lib/tlib$(SYS)u.a

# Machine dependencies
machdeps : lib/tp2cUNIX32.mdp lib/tp2cUNIX64.mdp

lib/tp2cUNIX32.mdp : lib
	cp src/tp2c/tp2cUNIX32.mdp lib/tp2cUNIX32.mdp

lib/tp2cUNIX64.mdp : lib
	cp src/tp2c/tp2cUNIX64.mdp lib/tp2cUNIX64.mdp

# Library scripts
scripts : lib/as lib/cc lib/ld 

lib/as : lib
	cp src/cmd/lib/as.$(SYS).sh lib/as 

lib/cc : lib
	cp src/cmd/lib/cc.$(SYS).sh lib/cc 

lib/ld : lib
	cp src/cmd/lib/ld.$(SYS).sh lib/ld 

# Commands
commands : bin/tpc bin/tssl

bin/tpc : bin  
	cd src/cmd; make; cd ../..
	cp src/cmd/tpc bin/tpc

bin/tssl : bin 
	cp src/tssl/tssl.sh bin/tssl

# Passes
passes : lib/scanparse.x lib/semantic1.x lib/semantic2.x lib/tp2c.x lib/ssl.x

lib/scanparse.x : lib
	cd src/scanparse; make; cd ../..
	cp src/scanparse/scanparse.x lib/scanparse.x

lib/semantic1.x : lib
	cd src/semantic.1; make; cd ../..
	cp src/semantic.1/semantic1.x lib/semantic1.x

lib/semantic2.x : lib
	cd src/semantic.2; make; cd ../..
	cp src/semantic.2/semantic2.x lib/semantic2.x

lib/tp2c.x : lib
	cd src/tp2c; make; cd ../..
	cp src/tp2c/tp2c.x lib/tp2c.x

lib/ssl.x : lib
	cd src/tssl; make; cd ../..
	cp src/tssl/ssl.x lib/ssl.x

# Includes
includes : include/common include/UNIX32 include/UNIX64

include/common : include
	cp -r src/tinclude/common include/common

include/UNIX32 : include
	cp -r src/tinclude/UNIX32 include/UNIX32

include/UNIX64 : include
	cp -r src/tinclude/UNIX64 include/UNIX64

# Configure for distribution
distrib : bin lib opentplus
	@echo ""
	@echo "Configuring for distribution"
	@echo ""
	cp bin/* opentplus/bin/
	cp lib/* opentplus/lib/
	cp -r include/* opentplus/include/
	cp -r src/distrib/* opentplus/
	cp LICENSE.txt opentplus/
	uname=`uname -s`
	mv opentplus opentplus-$$(uname)
	tar cfz opentplus-$$(uname).tar.gz opentplus-$$(uname)
	@echo ""
	@echo "Distributable binary in opentplus-$$(uname).tar.gz"
	@echo ""

# Directories
bin :
	mkdir bin

lib :
	mkdir lib

./include :
	mkdir include

opentplus :
	mkdir opentplus opentplus/bin opentplus/lib opentplus/include

# Cleanup
clean :
	rm -rf bin/* lib/* include/* 
	rm -rf opentplus opentplus-* opentplus-*.tar.gz
	cd test; make clean; cd ..
	cd src/tlib/$(SYS); make clean; cd ../..
	cd src/cmd; make clean; cd ../..
	cd src/scanparse; make clean; cd ../..
	cd src/semantic.1; make clean; cd ../..
	cd src/semantic.2; make clean; cd ../..
	cd src/tp2c; make clean; cd ../..
	cd src/tssl; make clean; cd ../..

