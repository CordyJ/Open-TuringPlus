all: checked unchecked

checked: helloworld.x hiho.x catch.x

helloworld.x:
	tpc helloworld.t

hiho.x:
	tpc -K hiho.t

catch.x:
	tpc catch.t

unchecked: uhelloworld.x uhiho.x ucatch.x

uhelloworld.x:
	tpc -O -o uhelloworld.x helloworld.t

uhiho.x:
	tpc -O -K -o uhiho.x hiho.t

ucatch.x:
	tpc -O -o ucatch.x catch.t

clean:
	/bin/rm -f *.x
