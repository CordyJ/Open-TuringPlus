Turing+ 6.2 (Sept 2022) for Unix-like systems

Copyright 1986, University of Toronto
Version 6.2 Copyright 2022, Queen's University at Kingston

This is the complete buildable source of Turing+ 6.2 for Unix systems.  

Turing+ 6.2 has a number of differences from original Turing+ :

(1) alias checking is disabled - aliasing is silently allowed.

(2) import checking is disabled - import lists are not required.

(3) bugs in the external naming of modules and monitors have been
    fixed, allowing for multiple modules of the same name in
    different contexts.  This provides a method for using modules
    as "classes" with multiple "object" instances.

(4) the default and maximum length of varying-length strings has 
    been increased from 255 to 4095 characters.

(5) source has been updated to be both 32-bit and 64-bit clean.

To make a new version of Turing+, make your changes to the source
files, then from this directory, run the command:

	./Makeall systemname

where 'systemname' is one of the supported systems in ./tlib,
at present "unix32" or "unix64", on MacOSX, Linux, Cygwin or MinGW.

To test your new version, change to the folder ./test and run the
following commands to test your new version of sequential and 
concurrent Turing+ :

	./tpc helloworld.t
	./helloworld.x

	./tpc -O helloworld.t
	./helloworld.x

	./tpc -K hiho.t
	./hiho.x

	./tpc -O -K hiho.t
	./hiho.x

JRC 30.9.22
