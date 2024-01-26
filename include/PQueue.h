#ifndef _PQUEUE_H
#define _PQUEUE_H
#include <stdbool.h>
#include "types.h"

typedef struct PQueue * PQueue;

PQueue PQueue_create();

void PQueue_destroy(PQueue q);

void PQueue_add(PQueue q, T item, int priority);

T PQueue_removeMin(PQueue q);

void PQueue_print(PQueue q);

#endif
