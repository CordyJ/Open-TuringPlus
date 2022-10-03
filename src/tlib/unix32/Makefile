SYS=UNIX32

all: 
	cp -r ../generic/* .
	cp -r machdep/* .
	make -f Makefile_Generic ARCH="-m32" SYS=$(SYS) 

clean:
	make -f Makefile_Generic clean
	rm -r -f TL* Makefile_Generic main.*
