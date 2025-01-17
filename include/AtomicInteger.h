#ifndef _ATOMICINTEGER_H
#define _ATOMICINTEGER_H
/* Filename : AtomicInteger.h
   Authors  : Josh Davis, Stephen F. Siegel
   Created  : 2024-06-17
   Modified : 2025-01-17

   Model of Java's java.util.concurrent.atomic.AtomicInteger.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include <stdbool.h>

struct AtomicInteger {
  int value;
};

typedef struct AtomicInteger * AtomicInteger;

/* Creates a new AtomicInteger object with given value */
AtomicInteger AtomicInteger_create(int initialValue);

/* Deallocates the object i. */
void AtomicInteger_destroy(AtomicInteger i);

/* If the current value of i is expect, change it to update in one
   atomic step and return true, else do nothing and return false. */
bool AtomicInteger_compareAndSet(AtomicInteger i,
                                 int expect, int update);

/* Returns the current integer value wrapped by i. */
int AtomicInteger_get(AtomicInteger i);

/* Sets the value of i to the given new integer value. */
void AtomicInteger_set(AtomicInteger i, int newValue);

/* Sets i to the new value and returns the old value */
int AtomicInteger_getAndSet(AtomicInteger i, int newValue);

/* Increments the value of i and returns the old value of i */
int AtomicInteger_getAndIncrement(AtomicInteger i);

/* Decrements the value of i and returns the old value of i */
int AtomicInteger_getAndDecrement(AtomicInteger i);

/* Like getAndDecrement, but does not allow i to go below 0. */
int AtomicInteger_boundedGetAndDecrement(AtomicInteger i);

#endif
