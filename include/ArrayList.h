#ifndef _ARRAYLIST_H
#define _ARRAYLIST_H
/* ArrayList.h: header for ArrayList.cvl
 * Created 14-Dec-2023
 * Josh Davis, Stephen Siegel
 * Verified Software Lab, CIS Dept.
 * University of Delaware
 */
#include <stdbool.h>
#include "types.h"

typedef struct ArrayList * ArrayList;

// create
ArrayList ArrayList_create();

// destroy
void ArrayList_destroy(ArrayList a);

// add
void ArrayList_add(ArrayList a, T item);

// also called add(idx, item), inserts a at position idx and shifts
// subsequent elements to the right.  requires 0<=idx<=size(a)
void ArrayList_insert(ArrayList a, int idx, T item);

// remove_item
bool ArrayList_remove_item(ArrayList a, T item);

// remove_index
T ArrayList_remove_index(ArrayList a, int index);

// contains
bool ArrayList_contains(ArrayList a, T item);

// get
T ArrayList_get(ArrayList a, int index);

// size
int ArrayList_size(ArrayList a);

void ArrayList_print(ArrayList a);

#endif
