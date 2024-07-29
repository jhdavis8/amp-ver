#ifndef _ATOMICINTEGER_H
#define _ATOMICINTEGER_H
/*
 * AtomicInteger.h: Header file for AtomicInteger.cvl
 * Created 17-Jun-2024
 * Josh Davis, Stephen Siegel
 * Verified Software Lab, CIS Dept.
 * University of Delaware
 */

#include <stdbool.h>

typedef struct AtomicInteger * AtomicInteger;

AtomicInteger AtomicInteger_create(int initialValue);

void AtomicInteger_destroy(AtomicInteger i);

bool AtomicInteger_compareAndSet(AtomicInteger i,
                                 int expect, int update);

int AtomicInteger_get(AtomicInteger i);

void AtomicInteger_set(AtomicInteger i, int newValue);

int AtomicInteger_getAndSet(AtomicInteger i, int newValue);

int AtomicInteger_getAndIncrement(AtomicInteger i);

int AtomicInteger_getAndDecrement(AtomicInteger i);

#endif