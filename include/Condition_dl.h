#ifndef _CONDITION_DL_H
#define _CONDITION_DL_H
/* Filename : Condition_dl.h
   Created  : 2024-10-23
   Modified : 2024-12-28
   Author   : Stephen F. Siegel

   Extension to the standard Condition.h interface, adding functions
   to detect deadlock involving Conditions and allowing the client to
   resume executing after a deadlock occurs.

   The client should use the following pattern:

   1. Call Condition_create(...) (repeatedly) to create Condition objects.
   2. Call tid_init(nthread) to specify the number of threads, if you have
      not yet done so.  The threads do not need to exist yet.
   3. Call Condition_init_context().
   4. For each Condition object cond, call Condition_initialize(cond).
   5. Launch the threads. Each thread first calls tid_register(tid).
      Wait for all threads to call tid_unregister and terminate.
   6. Call Condition_finalize(cond) on each cond.
   7. Call Condition_finalize_context().
   8. If you want to run again, possibly with a different numnber of
      threads, goto step 2.
   9. Call Condition_destroy(cond) on each Condition object cond.

*/
#include "Condition.h"

/* Prepares Condition context for an upcoming concurrent execution.
   Call this after the Conditions have been created and
   tid_init(nthread) has been called. */
void Condition_init_context();

/* Wraps up the condition context after the concurrent execution ends
   and all condition objects have been finalized. */
void Condition_finalize_context();

/* Initializes a condition object for an upcoming concurrent run.
   Call after cond has been created and context has been
   initialized. */
void Condition_initialize(Condition cond);

/* Wraps up a condition object after a concurrent run. The condition
   object can be re-used for another concurrent run.  */
void Condition_finalize(Condition cond);

/* Declares that thread tid has terminated.  Each thread should call
   this function, using its own tid, just before it terminates, to
   enable proper deadlock detection. */
void Condition_terminate(int tid);

/* Returns the deadlock bit.  If true, the program deadlocked---there
   was at least one nonterminated thread and all nonterminated threads
   were in waiting rooms of Conditions. This function should be called
   immediately after a call to Condition_await returns to see if the
   await completed normally or returned due to a deadlock.  This
   should be called when the Condition context is active, i.e.,
   between a call to Condition_init_context() and a call to
   Condition_finalize_context().  */
_Bool Condition_isDeadlocked();

#endif
