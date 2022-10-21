Turing+ basic functionality test

This directory contains a basic first functionality test for any new version of Turing+
that should be run after compiling any new set of changes.

To run the test, use the command "make" in this directory to compile the test programs
helloworld.t, hiho.t and catch.t with and without optimization. 

To run the results,

	./helloworld.x		should greet you
	./hiho.x		should randomly say hi, ho, he until you interrupt it 
	./catch.x		should count down until you interrupt it

	./uhelloworld.x		should greet you
	./uhiho.x		should randomly say hi, ho, he until you interrupt it 
	./ucatch.x		should count down until you interrupt it

These tests simply insure that the tpc command is runnable,
and that both sequential and concurrent Turing+ programs are working.

