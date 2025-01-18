#ifndef _ORACLE_H
#define _ORACLE_H
/*
  Filename : oracle.h
  Author   : Stephen F. Siegel
  Created  : 2024-12-12
  Modified : 2025-01-18

  Interface for a collection oracle.  The oracle specifies the
  intended behavior of a data structure.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "types.h"
#include <stdbool.h>

/* Creates an oracle, returning an opaque handle do it. */
void * oracle_create();

/* Destroys oracle */
void oracle_destroy(void * o);

/* Duplicates oracle */
void * oracle_duplicate(void * o);

/* Adds element to oracle */
bool oracle_add(void * o, T a0, int a1);

/* Checks whether a belongs to oracle */
bool oracle_contains(void * o, T a);

/* Removes element from oracle. a is the argument to the remove
   command; it is ignored for structures that do not take an argument
   for remove, such as a queue or priority queue.  It is used for
   set-like structures.  Argument expect is the expected result from
   the remove command.  This is used by priority queues to specify
   which item with minimal score should be selected, because there can
   be more than one item with minimal score, and the oracle should try
   to pick one that agrees with what the concurrent structure did.
   The expect field is ignored by other structures.  Use -1 for expect
   and it will be ignored for any kind of structure.

   Some oracles will return a boolean value, others will return a
   value in T or -1.  In any case, the value to return is cast to int.
 */
int oracle_remove(void * o, T a, T expect);

/* Prints the oracle (simple sequential) data structure to stdout */
void oracle_print(void * o);

/* Is the oracle currently in a state from which it can never reach an
   accepting state?  In that case, there is no sense in continuing the
   execution.  If stuck is true, then accepting refers to a final
   accepting state in which the oracle is "stuck" (invoked a method
   which cannot return), otherwise accepting means ending in an
   unstuck state. */
bool oracle_trapped(void * o, bool stuck);

/* Is the oracle in an accepting state?  The argument stuck specifies
   whether the oracle is expected to be in a stuck state.  This
   function should be called at the end of an execution of a
   sequential schedule on the oracle.  If it returns true, the
   sequential schedule matches the concurrent one from which the
   sequential one was derived.  The stuck argument should be true iff
   the concurrent collection ended in a stuck state.
 */
bool oracle_accepting(void * o, bool stuck);



#endif
