#ifndef _DRIVER_H
#define _DRIVER_H
/* Filename : driver.h
   Author   : Stephen F. Siegel
   Created  : 2024-01-25
   Modified : 2025-01-18

   A translation unit specifying a schedule should include this header
   file, which declares one function, make_schedule().  The
   translation unit should define this function.  That translation
   unit can be linked with driver.cvl (along with other modules) to
   from a complete program for analyzing all concurrent executions of
   the specified schedule.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "schedule.h"

/* Creates the schedule to be used by a driver.  May be
 * deterministic or nondeterministic. */
schedule_t make_schedule();

#endif
