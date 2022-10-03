% Turing+ v6.2, Sept 2022
% Copyright 1986 University of Toronto, 2022 Queen's University at Kingston
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software
% and associated documentation files (the “Software”), to deal in the Software without restriction,
% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
% subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all copies
% or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
% AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

parent "../TL.ch"

%
% TURING PLUS LIBRARY KERNEL
%  This module hides the abstraction of processes from the rest of
%  the library.  Thus functionality includes timeslicing, real-time
%  support, and interrupt support.
%
stub module TLK
    import (
	    /* modules (used for up-calls) */
	    var TLE, var TLB, var TLI, var TLM,

	    /* collections */
	    var TL_Process, TL_Handler,

	    /* routines */
	    TLQUIT,

	    /* variables */
	    var TLKPD,

	    /* constants */
	    maxnat
	   )

    export ( 
	     /* constants*/
	     Unlocked,		% for TLKLKON()

	    % --
	    % -- routines called from the rest of the library
	    %
	     TLKLKON, TLKLKOFF,		% lock, unlock
	     TLKUXRS, TLKUXRE,		% external routine (syscall) start/end

	     TLKUEXIT,			% program exit
	     TLKUDMPP,			% dump state of a single process
				        
	     TLKSTIMO, TLKSSYNC,  	% synchronize, synchronize w/ timeout
	     TLKSWAKE,		 	% non-blocking wakeup (devmon support)

	     TLKINI,			% initialize
	     TLKFINI,			% finialize (for 'main' process only)
	     TLKFRKED,			% has a fork occured ?

	    % --
	    % -- routines that the compiler calls
	    % 
	     TLKCINI,			% setupClock

	     TLKPFORK,			% fork
	     TLKPGETP, TLKPSETP,	% getPrio, setPrio
	     TLKPPAUS,			% pause

	     TLKIPINI,			% interrupt procedure initialize
	     TLKIPENT, TLKIPEXT,	% interrupt procedure enter/exit

	     TLKDMINI,			% device monitor initialize
	     TLKDMENT, TLKDMEXT		% device monitor enter/exit

	    )

    % -- Initial value of lock variables used in 'lock' and 'unlock'.
    const *Unlocked : TL_lock_t := 0


    % INITIALIZE
    %  This routine must be called just prior to executing the user program.
    %  (i.e. is one of last things done in TL library initialization)
    %
    procedure TLKINI


    % FINALIZE
    %  This routine called ONLY by 'main' process after it returns from TProg.
    %
    procedure TLKFINI


    % EXTERNAL ROUTINE START/END
    %  These routines should bracket all external library routines that
    %  are not written for concurrency. (e.g Unix library routines).
    %
    procedure TLKUXRS
    procedure TLKUXRE


    % EXIT 
    %  Exit program performing a dump if required.
    %  exitCode = 0: indicates a non-exceptional termination
    %  exitCode > 0: indicates an exceptional termination
    %  exitCode < 0: indicates a serious problem termination (NO DUMP)
    %
    procedure TLKUEXIT ( exitCode : Cint)


    % DUMP PROCESS
    %  Print out the state of process 'pd'.
    %
    procedure TLKUDMPP ( pd : TL_PDpointer)


    % RESCHEDULE LOOP/ROUTINE/ALWAYS
    %  Routines used to simulate concurrency on loop and routine boundaries.
    %  Inserted into the source by T+ compiler.
    %  (RRSCH may be used by fast (inline) versions)
    %
    procedure TLKRLOOP
    procedure TLKRROUT
    procedure TLKRRSCH

    % PROCESS FORK
    %  Fork a new process.
    %  "paramSize" is the size of the parameters to the new process (in bytes).
    %  "name" is a pointer to a static string containing this process' name.
    %  "procAddress" is the address of the process routine.
    %  "forkAddress", if non-zero, points to where the address of the process
    %  descriptor should be copied.
    %  "stackSize" is the user's requested stack size (in bytes).
    %  "forkStatus", if non-zero, points to a boolean that should be set
    %  TRUE or FALSE depending upon if the fork succeeded or did not.
    %  "p1-" are the first few parameters to the new process 
    %  (poor man's varargs).  Need a lot to force stack allocation on RISCS.
    %
    procedure TLKPFORK ( paramSize	: nat,
			 name		: addressint,
			 procAddress	: addressint,
			 forkAddress	: addressint,
			 stackSize	: nat,
			 forkStatus	: addressint,
			 p1		: addressint,
			 p2		: addressint,
			 p3		: addressint )


    % FORKED?
    %  Return true iff a fork has occured.
    %
    function TLKFRKED : boolean


    % LOCK/UNLOCK
    %  the "lck" variable is a binary semaphore used to enforce mutual 
    %  exclusion around a critical section.

    %  Use as follows:
    %		var x: TL_lockStatus_t
    %		TLKLKON(L,x)
    %		 critical section
    %		TLKLKOFF(L,x)
    %
    procedure TLKLKON  ( var lck : TL_lock_t, var x : TL_lockStatus_t )
    procedure TLKLKOFF ( var lck : TL_lock_t, x     : TL_lockStatus_t )


    % SYNCHRONIZE
    %  Two process barrier synchronization on "pd".
    %  The first process to SYNC on "pd" will block.  The next process
    %  to SYNC on "pd" will awaken the first and keep going itself.
    %
    procedure TLKSSYNC ( pd : TL_PDpointer )


    % SYNC WAKEUP
    %  If a process is blocked syncing on "pd" then wake it up,
    %  otherwise do nothing.
    %
    procedure TLKSWAKE ( pd : TL_PDpointer )

     
    % SYNCH WITH TIMEOUT
    %  Like SYNC but if the process blocks and is not awakened after
    %  "interval" time units it is allowed to proceed with "timedOut"
    %  set to TRUE.
    %
    procedure TLKSTIMO ( interval : nat, var timedOut : boolean )


    % CLOCK INITIALIZE
    %  This routine is called to start real-time timeslicing.
    %  (prior to this call simulated time is used).
    %
    procedure TLKCINI


    % PROCESS GET/SET SCHEDULING PRIORITY
    %  Routines to set and get the current process' priority.
    %
    function TLKPGETP : nat
    procedure TLKPSETP ( prio : nat )


    % INTERRUPT PROCEDURE INITIALIZE
    %  Make "sighandler" the routine to be called when the "sig" interrupt
    %  occurs.  The hardware priority level of the enclosing device monitor
    %  is "level".
    %  
    procedure TLKIPINI ( sig 		: nat,
			 sighandler 	: addressint,
			 level 		: int )


    % INTERRUPT PROCEDURE ENTER/EXIT
    %  Optional routines that may be called at the start and end of interrupt
    %  procedures.  "info" is an implementation dependent quantity that may
    %  be used to point to the device monitor record.
    %
    procedure TLKIPENT	
    procedure TLKIPEXT ( info : addressint )


    % DEVICE MONITOR INITIALIZE
    %  Returns TRUE iff "level" is a valid device monitor hardware level.
    %
    function  TLKDMINI ( level : int ) : boolean


    % DEVICE MONITOR ENTER/EXIT
    %  Brackets all calls to device monitor routines.
    %  "level" is the device monitor's hardware level.
    procedure TLKDMENT ( level : int )
    procedure TLKDMEXT


    % PAUSE
    %  Block the calling process for "pauseTime" timeunits.
    %
    procedure TLKPPAUS ( pauseTime : nat )
end TLK
