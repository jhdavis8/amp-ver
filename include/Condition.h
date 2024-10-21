#ifndef _CONDITION_H
#define _CONDITION_H
/* Condition.cvl: model of Java Condition interface (condition variable)
 * Created  : 26-Feb-2024
 * Modified : 26-Feb-2024
 * Author   : Stephen F. Siegel and Joshua H. Davis
 */
#include "Lock.h"

typedef struct Condition * Condition;

// note: tid_init(nthread) must be called before this function
Condition Condition_create(Lock lock);

void Condition_destroy(Condition cond);

void Condition_await(Condition cond);

void Condition_signal(Condition cond);

void Condition_signalAll(Condition cond);

void Condition_releaseAllStuck(Condition cond);

#endif
