#ifndef _QUEUE_H
#define _QUEUE_H
/* Filename : Queue.h
   Author   : Stephen F. Siegel
   Created  :
   Modified : 2024-12-12

   Interface for a queue.
*/
#include <stdbool.h>
#include "types.h"

typedef struct Queue * Queue;

/* Call this once before any other methods in the concurrent data
   sructure are invoked. */
void Queue_initialize(int nthread);

/* Call this method once at the end; do not call any methods in the
   concurrent data structure implementation after this. */
void Queue_finalize(void);

/* Inform the concurrent data structure that the thread with given tid
   has terminated. */
void Queue_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool Queue_stuck(void);

/* Creates a new empty queue, returning an opaque handle to it. */
Queue Queue_create();

/* Destroys the queue. */
void Queue_destroy(Queue queue);

/* Enqueues an element on the queue. */
void Queue_enq(Queue queue, T value);

/* Dequeues an element from the queue.  If queue is empty, or control
   deadlocks, -1 is returned.  */
T Queue_deq(Queue queue);

/* Prints the current state of the queue in human-readable format. */
void Queue_print(Queue queue);

#endif
