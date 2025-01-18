#ifndef _QUEUE_H
#define _QUEUE_H
/* Filename : Queue.h
   Author   : Josh Davis, Stephen F. Siegel
   Created  : 2024-01-25
   Modified : 2025-01-17

   Interface for a (FIFO) queue.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
*/
#include <stdbool.h>
#include "types.h"

typedef struct Queue * Queue;

/* Creates a new empty queue, returning an opaque handle to it. */
Queue Queue_create();

/* Destroys the queue. */
void Queue_destroy(Queue queue);

/* Prepares for a concurrent execution.  Call this after setting
   number of threads with tid_init(nthread). */
void Queue_initialize_context(void);

/* Frees memory allocated by Queue_initialize_context.  Called
   after a concurrent execution ends. */
void Queue_finalize_context(void);

/* Prepares the given Queue for a concurrent execution.  Call this on
   each queue that will be used in the execution, after calling
   Queue_initialize_context(). */
void Queue_initialize(Queue queue);

/* Frees up memory allocated by Queue_initialize(queue).  Call this on
   each queue after the concurrent execution ends. */
void Queue_finalize(Queue queue);

/* Inform the context that the thread with given tid has
   terminated. */
void Queue_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool Queue_stuck(void);

/* Enqueues an element on the queue. */
void Queue_enq(Queue queue, T value);

/* Dequeues an element from the queue.  If queue is empty, or control
   deadlocks, -1 is returned.  */
T Queue_deq(Queue queue);

/* Prints the current state of the queue in human-readable format. */
void Queue_print(Queue queue);

#endif
