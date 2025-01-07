#ifndef _COLLECTION_H
#define _COLLECTION_H
/* Filename : collection.h
   Author   : Stephen F. Siegel
   Created  : 2024-12-12
   Modified : 2024-12-29

   Generic interface for a concurrent collection.  The collection
   should implement functions create, destroy, add, remove, contains,
   isStuck, and print.  An implementation may have various semantics,
   including set, queue, priority queue, and variations on these such
   as nonblocking, blocking, etc.

   The standard pattern for using these functions is as follows:

   1. Call collection_create() to create new collection.
   2. Call tid_init(nthread) to set the number of threads.
   3. Call collection_initialize_context().
   4. Call collection_initialize(c) for all c that will be used.
   5. launch threads, join threads, check for stuckness.
   6. Call collection_finalize(c) for all c.
   7. Call collection_finalize_context().
   8. Call tid_finalize() to undo whatever tid_init(nthread) did.
   9. go to step 2 if you want to do another run, possibly with a
      different nthread.
  10. Call collection_destroy(c).

*/
#include "types.h"
#include <stdbool.h>

/* Creates the concurrent data structure, returning an opaque
   handle to it. */
void * collection_create();

/* Destroys the concurrent data structure (collection). */
void collection_destroy(void * c);

/* Prepares the context for a concurrent execution.  Call this once,
   after the number of threads has been set using tid_init(nthread),
   and before the threads have been created. */
void collection_initialize_context(void);

/* Undoes whatever was done by collection_initialize_context().
   Call this once after all threads terminate. */
void collection_finalize_context(void);

/* Prepares the specified collection for a concurrent run.  Call this
   on each collection involved in the run after calling
   collection_initilaize_context() but before the threads are
   created. */
void collection_initialize(void * c);

/* Undoes whatever collection_initialize(c) did. */
void collection_finalize(void * c);

/* Inform the concurrent data structure that the thread with given tid
   has terminated. */
void collection_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool collection_stuck(void);

/* Adds an element to c.  It is not necessarily the case that both
   arguments are used.  For all structures other than priority queues,
   only a0 is used.  For priority queues, a0 is the value and a1 the
   "score". */
bool collection_add(void * c, T a0, int a1);

/* Determines whether a belongs to c */
bool collection_contains(void * c, T a);

/* Removes a from c.  The argument a may be ignored (e.g., by queues
   and priority queues).  Depending on the kind of collection, may
   return a value in T (the object removed), a negative integer (e.g.,
   if a queue is empty), or a boolean (e.g, if c is a set, true iff a
   was in c).  In any case, the return value is converted to int.  */
int collection_remove(void * c, T a);

/* Prints the contents of the concurrent data structure to stdout */
void collection_print(void * c);

#endif
