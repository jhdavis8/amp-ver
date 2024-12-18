#ifndef _SET_H
#define _SET_H
/* Filanme : Set.h
   Author  : Josh Davis and Stephen F. Siegel
   Created :
   Modified: 2024-12-12

   Interface for a set collection.  Note: in the actual concurrent
   executions we model, a method call may get "stuck", i.e., result in
   deadlock.  However, in our framework, the functions modeling these
   methods will always return.  Instead, a stuck flag will be set in
   the implementation.  The flag can be checked using the isStuck()
   function; if it is set (true), the return value of the previous
   function call should be ignored and no further calls should be made
   on the collection.  In general, isStuck() should be called after
   each function returns, unless you have some reason to be sure the
   method could not get stuck.
*/
#include <stdbool.h>
#include "types.h"

typedef struct Set * Set;

/* Call this once before any other methods in the concurrent data
   sructure are invoked. */
void Set_initialize(int nthread);

/* Call this method once at the end; do not call any methods in the
   concurrent data structure implementation after this. */
void Set_finalize(void);

/* Inform the concurrent data structure that the thread with given tid
   has terminated. */
void Set_terminate(int tid);

/* Did the concurrent execution deadlock? */
bool Set_stuck(void);

/* Adds value to set.  Returns true iff value was not already in the
   set. */
bool Set_add(Set set, T value);

/* Removes value from set, if value was in set.  Returns true iff
   value was in the set. */
bool Set_remove(Set set, T value);

/* Determines whether set contains value. */
bool Set_contains(Set set, T value);

/* Creates a new empty set, returning an opaque handle to it. */
Set Set_create();

/* Destroys the set.  */
void Set_destroy(Set set);

/* Prints the set in human-readable form. */
void Set_print(Set set);

/* Returns the number of elements currently in the set */
int Set_size(Set set);

#endif
