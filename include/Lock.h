#ifndef _LOCK_H
#define _LOCK_H
/* Lock.h: header file for any lock implementation, including
 * ReentrantLock.cvl and fair_ReentrantLock.cvl
 * Updated 26-Dec-2023
 * Josh Davis, Stephen Siegel
 * Verified Software Lab, CIS Dept.
 * University of Delaware
 */

typedef struct Lock * Lock;

Lock Lock_create();

void Lock_destroy(Lock l);

void Lock_acquire(Lock l);

void Lock_release(Lock l);

_Bool Lock_isHeldByCurrentThread(Lock l);

_Bool Lock_isLocked(Lock l);

#endif
