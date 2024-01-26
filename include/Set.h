#ifndef _SET_H
#define _SET_H

#include <stdbool.h>
#include "types.h"

typedef struct Set * Set;


/* add(Set set, T value)
 * Input:  set, a pointer to a given Hash Set
 *         value, a positive integer
 * Output: true if the value is successfully added,
 *         false if the value is not added
 * If add is given faulty input (ex: a negative number, a non-integer, etc.), 
 * the code will return false for wrong input
 * A value is successfully added if:
 * - it is a non-negative integer
 * - the value does not already exist in the set
 * - the set exists and is unlocked
 * - the value is successfully stored in the set 
 */
bool Set_add(Set set, T value);


/* remove(Set set, T value)
 * Input:  set, a pointer to a given Hash Set
 *         value, a positive integer
 * Output: true if the value is successfully discarded from the set
 *         false if the value is not discarded 
 * If discard is given faulty input (ex: a negative number, a non-integer, etc.), 
 * the code will return false for wrong input
 * A value is successfully discarded if:
 * - it is a non-negative integer
 * - the value initially exists in the set
 * - the set exists and is unlocked
 * - the value is successfully removed from the set
 */
bool Set_remove(Set set, T value);


/* contains(Set set, int value)
 * Input:  set, a pointer to a given Hash Set
 *         value, a positive integer
 * Output: true if the value exists in the set
 *         false if the value does not exist in the set 
 * If contains is given faulty input (ex: a negative number, a non-integer, etc.), 
 * the code will return false for wrong input
 * A value exists in the set if
 * - it is a non-negative integer
 * - the set exists and is unlocked
 * - the value can be referenced at some location in the set
 */
bool Set_contains(Set set, T value);


/* create()
 * Output: Pointer to created set
 * If create is given faulty input (ex: a negative number, a non-integer, etc.), 
 * the code will return NULL for wrong input
 * A set is created if
 * - its memory has been allocated
 * - its values are initialized to -1
 * - the set can be referenced at some location in memory
 */
Set Set_create();


/* destroy(Set set)
 * Input:  set, a pointer to a given Hash Set
 */
void Set_destroy(Set set);

void Set_print(Set set);

int Set_size(Set set);

#endif
