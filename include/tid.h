#ifndef _TID_H
#define _TID_H
/* Filename : tid.h
 * Author   : Stephen F. Siegel
 * Created  : 2024-03-12
 * Modified : 2024-03-12
 *
 * Provides a way for a multi-threaded program to assign and retrieve
 * a thread ID (tid) to each thread.

 * CIVL-C has no notion of threads, but rather processes ($proc).
 * Typically a CIVL-C program modeling a multithreaded program will
 * have some processes which represent threads and other processes
 * which do not.  CIVL does not have any way to know which are which,
 * and does not associate an integer ID number to processes, as this
 * would break process symmetry which is the key to much state space
 * reduction. This module allows a user to designate certain processes
 * as threads and assign ID numbers to them, and allow any such thread
 * to retrieve its ID number at any time.
 */

/* This function should be called once, before the "threads" are
 * created, specifying an upper bound on the number of threads that
 * will be created.
 */
void tid_init(int nthread);

/* Gets the number of threads specified in tid_init.  Undefined
 * behavior if tid_init has not yet been called.
 */
int tid_nthread();

/* This method should be called once, after the threads are destroyed.
 */
void tid_destroy(void);

/* Each thread should call this function once, specifying its ID.  A
 * thread typically calls this shortly after its creation.  It must be
 * called before the thread calls tid_get().  The tid should be in the
 * range 0..nthread-1 and it must be distinct from the tid of every
 * other thread.
 */
void tid_register(int tid);

/* Each thread should call this function once, before termination.
 * After calling this function, the thread can no longer call
 * tid_get().
 */
void tid_unregister();

/* This method is called by a thread to get its TID.  It can be called
 * any number of times after a thread registers. */
int tid_get(void);

#endif
