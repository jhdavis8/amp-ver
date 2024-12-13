#ifndef _PQUEUE_H
#define _PQUEUE_H
/* Filename : PQueue.h
   Author   : Stephen F. Siegel
   Created  :
   Modified : 2024-12-12

   Interface for a priority queue.
*/
#include <stdbool.h>
#include "types.h"

typedef struct PQueue * PQueue;

/* Call this once before any other methods in the concurrent data
   sructure are invoked. */
void PQueue_initialize(int nthread);

/* Call this method once at the end; do not call any methods in the
   concurrent data structure implementation after this. */
void PQueue_finalize(void);

/* Inform the concurrent data structure that the thread with given tid
   has terminated. */
void PQueue_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool PQueue_stuck(void);

/* Creates a new empty priority queue, returning an opaque handle to it. */
PQueue PQueue_create();

/* Destroys the priority queue. */
void PQueue_destroy(PQueue pq);

/* Adds an item with the given priority to the priority queue.
   TODO: Can item occur more than once with same priorities?
   different priorities?  Answer this please.  */
void PQueue_add(PQueue pq, T item, int priority);

/* Removes an entry with minimal score, returning its value.  If queue
   is empty a negative value is returned.  The stuck bit may or may
   not be set in that case, depending on implementation. */
T PQueue_removeMin(PQueue pq);

/* Prints the current state of the priority queue */
void PQueue_print(PQueue pq);

#endif
