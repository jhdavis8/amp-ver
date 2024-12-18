#ifndef _COLLECTION_H
#define _COLLECTION_H
/* Filname : collection.h
   Author  : Stephen F. Siegel
   Created : 2024-12-12
   Modified: 2024-12-12

   Generic interface for a concurrent collection.  The collection
   should implement functions create, destroy, add, remove, contains,
   isStuck, and print.  An implementation may have various semantics,
   including set, queue, priority queue, and variations on these such
   as nonblocking, blocking, etc.
*/
#include "types.h"
#include <stdbool.h>

/* Call this once before any other methods in the concurrent data
   sructure are invoked. */
void collection_initialize(int nthread);

/* Call this method once at the end; do not call any methods in the
   concurrent data structure implementation after this. */
void collection_finalize(void);

/* Inform the concurrent data structure that the thread with given tid
   has terminated. */
void collection_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool collection_stuck(void);

/* Creates the concurrent data structure, returning an opaque
   handle to it. */
void * collection_create();

/* Destroys the concurrent data structure (collection). */
void collection_destroy(void * c);

/* Adds an element to c.  It is not necessarily the case that both
 * arguments are used.  For all structures other than priority queues,
 * only a0 is used.  For priority queues, a0 is the value and a1 the
 * "score". */
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