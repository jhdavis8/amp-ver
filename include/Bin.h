#ifndef _BIN_H
#define _BIN_H
/* Filename : Bin.h
   Author   : Stephen F. Siegel
   Created  : 2025-01-13
   Modified : 2025-01-17

   A "bin" is a collection that provides two operations: put and get.
   It is basically a multiset, i.e., it may contain multiple == copies
   of an object.  Put adds an element to the bin, get removes and
   returns one item (it is unspecified which element is returned).  If
   the Bin is empty, get returns null, here represented by -1.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "types.h"
#include <stdbool.h>

typedef struct Bin * Bin;

/* Creaates a new empty bin. */
Bin Bin_create(void);

/* Deallocates the bin. */
void Bin_destroy(Bin bin);

/* Adds an item to the bin. */
void Bin_put(Bin bin, T item);

/* Removes an item from the bin and returns it, if the bin is
   nonempty, else returns -1 without modifying the empty bin. */
T Bin_get(Bin bin);

/* Tells whether the bin is empty. */
bool Bin_isEmpty(Bin bin);

/* Prints the bin. */
void Bin_print(Bin bin);

#endif
