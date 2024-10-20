#ifndef _DLCATCH_H
#define _DLCATCH_H
/* Deadlocker catcher.  This module is used to model concurrent
   (multithreaded) programs that execute operations that may block on
   Condition variables.  It allows such a model to detect when a
   deadlock occurs (because all threads are either terminated or
   waiting, and at least one thread is not terminated) and exit
   gracefully, reporting the deadlock. */
#include "tid.h"

/* Initialize the deadlock catcher.  This should be called before
   the threads are created */
void dlcatch_init(int nthread);

/* Call after all threads return. */
void dlcatch_destroy();

/* A thread calls this function to proclaim that it is entering an
   "await" call on the Condition cond.  This function returns true iff
   this call results in deadlock, i.e., all nonterminated threads are
   stuck waiting on some condition.  In the case of deadlock, the
   global deadlock bit is set and all nonterminated threads are
   released from their awaits. */
bool dlcatch_awaiting(Condition cond, int tid);

/* Declares that the thread tid is being released from its waiting
   status so is no longer stuck. */
void dlcatch_release(int tid);

/* Declares that thread tid has terminated. */
void dlcatch_terminate(int tid);

/* Returns the deadlock bit.  If true, all threads became deadlocked. */
bool dlcatch_isDeadlocked();

/* Tells whether thread tid has terminated. */
bool dlcatch_isTerminated(int tid);

#endif
