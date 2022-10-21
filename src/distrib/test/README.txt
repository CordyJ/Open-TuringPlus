Turing+ basic functionality test

This directory contains a basic first functionality test that should be run after installing Turing+.

To run the test, use the command "make" in this directory to compile the test programs
helloworld.t, hiho.t and catch.t with and without optimization. 

To run the results,

	./helloworld.x		should greet you
	./hiho.x		should randomly say hi, ho, he until you interrupt it 
	./catch.x		should count down until you interrupt it

	./uhelloworld.x		should greet you
	./uhiho.x		should randomly say hi, ho, he until you interrupt it 
	./ucatch.x		should count down until you interrupt it

These tests simply insure that the tpc command is installed and runnable,
and that both sequential and concurrent Turing+ programs are working.

