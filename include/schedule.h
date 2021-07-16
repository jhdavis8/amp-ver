#ifndef _SCHEDULE
/* schedule.h: interface for generation of schedules */
#define ADD 0
#define REMOVE 1
#define CONTAINS 2

typedef enum kind { SET, QUEUE, PQUEUE } kind_t;

typedef struct step_s {
  int op;
  int args[2];
  int result;
  int start_time;
  int stop_time;
} step_t;

typedef struct schedule_s {
  kind_t kind; // kind of data structure
  int num_ops; // number of types of operations (2 or 3)
  int nthreads; // number of threads
  int nsteps_sum; // total number of steps
  int * nsteps; // number of steps for each thread; length nthreads
  step_t ** steps; // length nthreads, steps[i] has length nsteps[i]  
} schedule_t;

schedule_t schedule_create(kind_t kind, int nthreads, int steps_bound);

void schedule_destroy(schedule_t sched);

void schedule_print(schedule_t sched);

#endif
