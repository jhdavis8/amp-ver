#ifndef _PQUEUE_H
#define _PQUEUE_H
/* Filename : PQueue.h
   Author   : Stephen F. Siegel
   Created  :
   Modified : 2024-12-31

   Interface for a priority queue.
*/
#include <stdbool.h>
#include "types.h"

typedef struct PQueue * PQueue;

/* Creates a new empty priority queue, returning an opaque handle to
   it. */
PQueue PQueue_create();

/* Destroys the priority queue. */
void PQueue_destroy(PQueue pq);

/* Prepares for a concurrent execution.  Call this after setting
   number of threads with tid_init(nthread). */
void PQueue_initialize_context(void);

/* Frees memory allocated by PQueue_initialize_context.  Called after
   a concurrent execution ends. */
void PQueue_finalize_context(void);

/* Prepares the given PQueue for a concurrent execution.  Call this on
   each queue that will be used in the execution, after calling
   PQueue_initialize_context(). */
void PQueue_initialize(PQueue pq);

/* Frees up memory allocated by PQueue_initialize(pq).  Call this on
   each priority queue after the concurrent execution ends. */
void PQueue_finalize(PQueue pq);

/* Informs the context that the thread with given tid has
   terminated. */
void PQueue_terminate(int tid);

/* Did the concurrent execution get stuck (deadlock or livelock)? */
bool PQueue_stuck(void);

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
