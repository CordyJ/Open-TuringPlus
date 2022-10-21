Turing+ 6.2 (Sept 2022) for Unix-like systems

Copyright 1986, University of Toronto
Copyright 2021, Queen's University at Kingston
Version 6.2 Copyright 2022, James R. Cordy and others

This is the complete buildable source of Turing+ 6.2 for Unix systems.  

Turing+ 6.2 has a number of differences from original Turing+ :

(1) alias checking is disabled - aliasing is silently allowed.

(2) procedure-level imports are automatic if no import list is given.
    module-level imports are required and checked.

(3) the default and maximum length of varying-length strings has 
    been increased from 255 to 4095 characters.

(4) source has been updated to be both 32-bit and 64-bit clean.

