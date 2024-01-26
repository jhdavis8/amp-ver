#ifndef _DRIVER_H
#define _DRIVER_H
#include <stdbool.h>
#include "schedule.h"

/* Creates the schedule to be used by this driver.  May be
 * deterministic or nondeterministic. */
schedule_t make_schedule();

/* Creates the concurrent data structure */
void * collection_create();

/* Destroys the concurrent data structure (collection). */
void collection_destroy(void * c);

/* Adds an element to c.  It is not necessarily the case that both
 * arguments are used.  For all structures other than priority queues,
 * only a0 is used.  For priority queues, a0 is the value and a1 the
 * "score". */
bool collection_add(void * c, int a0, int a1);

/* Determines whether a belongs to c */
bool collection_contains(void * c, int a);

/* Removes a from c.  The argument a may be ignored (e.g., by queues
 * and priority queues). */
int collection_remove(void * c, int a);

/* Prints the contents of the concurrent data structure to stdout */
void collection_print(void * c);

/* Creates oracle */
void * oracle_create();

/* Destroys oracle */
void oracle_destroy(void * o);

/* Adds element to oracle */
bool oracle_add(void * o, int a0, int a1);

/* Checks whether a belongs to oracle */
bool oracle_contains(void * o, int a);

/* Removes element from oracle. a is the argument to the remove
 * command; it is ignored for structures that do not take an argument
 * for remove, such as a queue or priority queue.  It is used for
 * set-like structures.  Argument expect is the expected result from
 * the remove command.  This is used by priority queues to specify
 * which item with minimal score should be selected, because there can
 * be more than one item with minimal score, and the oracle should try
 * to pick one that agrees with what the concurrent structure did.
 * The expect field is ignored by other structures. */
int oracle_remove(void * o, int a, int expect);

/* Prints the oracle (simple sequential) data structure to stdout */
void oracle_print(void * o);

#endif
