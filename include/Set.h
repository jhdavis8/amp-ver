#ifndef _SET_H
#define _SET_H
/* Filanme : Set.h
   Author  : Josh Davis and Stephen F. Siegel
   Created :
   Modified: 2024-12-30

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

/* Creates a new empty set, returning an opaque handle to it. */
Set Set_create();

/* Destroys the set.  */
void Set_destroy(Set set);

/* Prepares for a concurrent execution.  Call this after setting
   number of threads with tid_init(nthread). */
void Set_initialize_context(void);

/* Frees memory allocated by Set_initialize_context.  Called
   after a concurrent execution ends. */
void Set_finalize_context(void);

/* Prepares the given Set for a concurrent execution.  Call this on
   each set that will be used in the execution, after calling
   Set_initialize_context(). */
void Set_initialize(Set set);

/* Frees up memory allocated by Set_initialize(set).  Call this on
   each set after the concurrent execution ends. */
void Set_finalize(Set set);

/* Inform the context that the thread with given tid has
   terminated. */
void Set_terminate(int tid);

/* Did the concurrent execution get stuck (due to deadlock or
   livelock)? */
bool Set_stuck(void);

/* Adds value to set.  Returns true iff value was not already in the
   set. */
bool Set_add(Set set, T value);

/* Removes value from set, if value was in set.  Returns true iff
   value was in the set. */
bool Set_remove(Set set, T value);

/* Determines whether set contains value. */
bool Set_contains(Set set, T value);

/* Prints the set in human-readable form. */
void Set_print(Set set);

/* Returns the number of elements currently in the set */
int Set_size(Set set);

#endif
