#ifndef _ARRAYLIST_H
#define _ARRAYLIST_H
/* Filename : ArrayList.h
   Authors  : Josh Davis, Stephen F. Siegel
   Created  : 2023-12-14
   Modified : 2025-01-17

   Model of the Java ArrayList class.  An ArrayList is a list in which an
   element at an arbitrary index can be accessed in constant time.

   The element type, T, is defined in types.h.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
*/
#include "types.h"
#include <stdbool.h>

typedef struct ArrayList * ArrayList;

/* Creates a new empty ArrayList */
ArrayList ArrayList_create();

/* Deallocates the ArrayList */
void ArrayList_destroy(ArrayList a);

/* Adds an item to the end of the list. */
void ArrayList_add(ArrayList a, T item);

/* Inserts an item at position idx in the list and shifts subsequent
   elements to the right.  requires 0<=idx<=size(a).  In Java, this
   method is called add(idx, item).  We use a different name since in
   CIVL-C and C, functions must have distinct names. */
void ArrayList_insert(ArrayList a, int idx, T item);

/* Removes first occurrence of item from a, if it is present.  Returns
   true iff item was present (so a changed). */
bool ArrayList_remove_item(ArrayList a, T item);

/* Removes element at position index from a. */
T ArrayList_remove_index(ArrayList a, int index);

/* Determines whether a contains item. */
bool ArrayList_contains(ArrayList a, T item);

/* Returns the element at position index in a. */
T ArrayList_get(ArrayList a, int index);

/* Returns the length of the list */
int ArrayList_size(ArrayList a);

/* Prints the list. */
void ArrayList_print(ArrayList a);

#endif
