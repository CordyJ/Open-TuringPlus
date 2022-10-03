all: 
	cp -r ../generic/* .
	cp -r machdep/* .
	if [ "`uname -o`" = "Cygwin" -o "`uname -o`" = "Msys" ]; then \
	    cp ./TLK/TLKCS-CYGWIN.s ./TLK/TLKCS.s; \
	    make -f Makefile_Generic ARCH="-m64" SYS=UNIX64 DEFINES="-DIEEE -DUNIX64 -DCYGWIN"; \
	else \
	    cp machdep/TLK/TLKCS-UNIX64.s machdep/TLK/TLKCS.s; \
	    make -f Makefile_Generic ARCH="-m64" SYS=UNIX64; \
	fi

clean:
	make -f Makefile_Generic clean
	rm -r -f TL* Makefile_Generic main.*
