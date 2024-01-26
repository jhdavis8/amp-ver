#ifndef _QUEUE_H
#define _QUEUE_H
#include "types.h"

typedef struct Queue * Queue;

Queue Queue_create();

void Queue_destroy(Queue queue);

void Queue_enq(Queue queue, T value);

T Queue_deq(Queue queue);

void Queue_print(Queue queue);

#endif
