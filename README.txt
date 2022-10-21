The Turing+ 6.2 build process for Unix-like systems

This is the complete buildable source of Turing+ 6.2 for Unix systems.  
Turing+ requires an installed Turing+ compiler, tpc, to build.

To build the Turing+ compiler, run the command "make" in this directory.
The distributable binary version of Turing+ for this platform will be output
as "tplus-$(OSTYPE).tar.gz".

Tests can be run in the test/ subdirectory. Run "make" in that directory
for a basic functionality test of sequential and concurrent Turing+.

