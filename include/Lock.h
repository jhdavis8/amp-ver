#ifndef _LOCK_H
#define _LOCK_H
/* Filename : Lock.h
   Authors  : Josh Davis, Stephen F. Siegel
   Created  : 2023-12-26
   Modified : 2025-01-17

   Model of Java interface java.util.concurrent.locks.Lock.
   Interface for both ReentrantLock.cvl and FairReentrantLock.cvl.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
*/

typedef struct Lock * Lock;

/* Creates a new lock */
Lock Lock_create();

/* Deallocates the lock */
void Lock_destroy(Lock l);

/* Acquires the lock, corresponds to Java's lock() */
void Lock_acquire(Lock l);

/* Releases the lock, corresponds to Java's unlock() */
void Lock_release(Lock l);

/* Is the thread calling this function holding lock l? */
_Bool Lock_isHeldByCurrentThread(Lock l);

#endif
