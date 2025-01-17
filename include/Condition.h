#ifndef _CONDITION_H
#define _CONDITION_H
/* Filename : Condition.h
   Created  : 2024-02-26
   Modified : 2025-01-17
   Author   : Stephen F. Siegel and Joshua H. Davis

   Model of Java Condition interface (condition variable):
   java.util.concurrent.locks.Condition.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "Lock.h"

/* The Condition type, which is an opaque handle (pointer) to a
   Condition object. */
typedef struct Condition * Condition;

/* Creates a new Condition object associated to the given Lock and
   returns a pointer to it.  This function should be called before the
   threads are created.  Note: tid_init(nthread) must be called before
   this function. */
Condition Condition_create(Lock lock);

/* Destroys the Condition object pointed to by cond. */
void Condition_destroy(Condition cond);

/* Puts the thread into the "waiting room" and releases the lock.  The
   thread remains in the waiting room until awakened by a signal,
   after which it attempts to re-obtain the lock.  This function
   should be called only when the calling thread owns the lock.  */
void Condition_await(Condition cond);

/* Sends a signal to one of the waiting threads.  The thread to signal
   is chosen nondeterministically from among the set of threads in the
   waiting room.  If there are no waiting threads, this is a no-op.
   This function should be called only when the calling thread owns
   the lock. */
void Condition_signal(Condition cond);

/* Sends a signal all of the threads in the waiting room.  This
   function should be called only when the calling thread owns the
   lock.  */
void Condition_signalAll(Condition cond);

#endif
