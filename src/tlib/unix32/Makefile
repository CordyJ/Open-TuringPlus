SYS=UNIX32

all: 
	cp -r ../generic/* .
	cp -r machdep/* .
	case `uname -s` in \
	    CYGWIN*|MINGW*) \
	        cp ./TLK/TLKCS-CYGWIN.s ./TLK/TLKCS.s; \
	        make -f Makefile_Generic ARCH="-m32" SYS=UNIX32 DEFINES="-DIEEE -DUNIX32 -DCYGWIN";; \
	    *) \
	        cp machdep/TLK/TLKCS-UNIX32.s machdep/TLK/TLKCS.s; \
	        make -f Makefile_Generic ARCH="-m32" SYS=UNIX32;; \
	esac

clean:
	make -f Makefile_Generic clean
	rm -r -f TL* Makefile_Generic main.*
