SYS=UNIX64

all: 
	cp -r ../generic/* .
	cp -r machdep/* .
	case `uname -s` in \
	    CYGWIN*|MINGW*) \
	        cp ./TLK/TLKCS-CYGWIN.s ./TLK/TLKCS.s; \
	        make -f Makefile_Generic ARCH="-m64" SYS=UNIX64 DEFINES="-DIEEE -DUNIX64 -DCYGWIN";; \
	    *) \
	        cp machdep/TLK/TLKCS-UNIX64.s machdep/TLK/TLKCS.s; \
	        make -f Makefile_Generic ARCH="-m64" SYS=UNIX64;; \
	esac

clean:
	make -f Makefile_Generic clean
	rm -r -f TL* Makefile_Generic main.*
