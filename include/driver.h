#ifndef _DRIVER_H
#define _DRIVER_H
#include <stdbool.h>
#include "schedule.h"

/* Creates the schedule to be used by this driver.  May be
 * deterministic or nondeterministic. */
schedule_t make_schedule();



#endif
