#ifndef _CONDITION_DL_H
#define _CONDITION_DL_H
/* Filename : Condition_dl.h
   Created  : 2024-10-23
   Modified : 2024-10-23
   Author   : Stephen F. Siegel

   Extension to the standard Condition.h interface, adding functions
   to detect deadlock involving Conditions and allowing the client to
   resume executing after a deadlock occurs.
*/
#include "Condition.h"

/* Initialize the deadlock catcher.  This should be called once,
   before the threads are created. */
void Condition_init(int nthread);

/* Destroys the deadlock catcher.  This should be called once, after
   threads terminate. */
void Condition_finalize();

/* Declares that thread tid has terminated.  Each thread should call
   this function, using its own tid, just before it terminates, to
   enable proper deadlock detection. */
void Condition_terminate(int tid);

/* Returns the deadlock bit.  If true, the program deadlocked---there
   was at least one nonterminated thread and all nonterminated threads
   were in waiting rooms of Conditions. This function should be called
   immediately after a call to Condition_await returns to see if the
   await completed normally or returned due to a deadlock. */
_Bool Condition_isDeadlocked();

#endif
