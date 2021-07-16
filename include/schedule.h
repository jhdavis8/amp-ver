#ifndef _SCHEDULE

/* schedule.h: interface for generation of schedules for testing concurrent
   data structures.  */

// The 3 possible operations on a data structure. Sets supports all 3;
// queues and pqueues (priority queues) support ADD and REMOVE.
#define ADD 0      // takes 1 arg for SET and QUEUE; 2 args for PQUEUE
#define REMOVE 1   // takes 1 arg for SET; 0 for QUEUE and PQUEUE
#define CONTAINS 2 // takes 1 arg

// The different kinds of data structures
typedef enum kind { SET, QUEUE, PQUEUE } kind_t;

/* A step represents a call to a single method from one thread */
typedef struct step_s {
  int op; // the operation (ADD, REMOVE, or CONTAINS)
  int args[2]; // the 0, 1, or 2 arguments; not all are used
  int result; // the results returned by the operation (if not void)
  int start_time; // time at which operation was invoked
  int stop_time; // time at which operation returned
} step_t;

/* a schedule specifies a sequence of steps for each thread */
typedef struct schedule_s {
  kind_t kind; // kind of data structure
  int num_ops; // number of types of operations (2 or 3)
  int nthreads; // number of threads
  int nsteps_sum; // total number of steps
  int * nsteps; // number of steps for each thread; length nthreads
  step_t ** steps; // length nthreads, steps[i] has length nsteps[i]  
} schedule_t;

/* Creates a new schedule using nondeterministic choice and symmetry
   reduction. */
schedule_t schedule_create(kind_t kind, int nthreads, int steps_bound);

/* Deallocates memory allocated in schedule_create. */
void schedule_destroy(schedule_t sched);

/* Prints a schedule in nice human-readable form (for debugging). */
void schedule_print(schedule_t sched);

#endif
