This is the driver program for the Turing Plus compiler

To compile, you must define the default machine (UNIX32/UNIX64) in tpc.t .

To add a new machine type,  the type must be defined, the const arrays
must be changed, the #ifdef DEFAULT must be changed.  There are also 2 case
statements where the new machine must be added.

You may have to change the Preproc routine as well.
