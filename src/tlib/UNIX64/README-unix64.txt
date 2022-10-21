This directory contains the machine dependent files for 64-bit Unix-like systems.  
Currently these files are common between MacOSX, Linux, Cygwin and MinGW, 
as "unix32" or "unix64", and need not be changed from those in ../generic.

The assembler on some platforms does not support preprocessor directives,
so the generic assembly code files have been specialized in machdep/TLK.

To make 64-bit version of the Turing+ compiler on these systems, run the command
"make" in this directory.

JRC 4.7.18
