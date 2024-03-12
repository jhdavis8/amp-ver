/* Condition.cvl: model of Java Condition interface (condition variable)
 * Created  : 26-Feb-2024
 * Modified : 26-Feb-2024
 * Author   : Stephen F. Siegel and Joshua H. Davis
 */
#include "Lock.h"

typedef struct Condition * Condition;

Condition Condition_create(Lock lock);

void Condition_destroy(Condition cond);

void Condition_await(Condition cond);

void Condition_signal(Condition cond);

void Condition_signalAll(Condition cond);
