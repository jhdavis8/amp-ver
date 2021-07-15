enum SetOperation { ADD, REMOVE, CONTAINS };

typedef struct set_record {
  SetOperation op;
  int arg;
  _Bool result;
  int start_time;
  int stop_time;
} SetRecord;

enum QueueOperation { ENQUEUE, DEQUEUE };

typedef struct queue_record {
  QueueOperation op;
  int arg;     // only for enq
  int result;  // only for deq
  int start_time;
  int stop_time;
} QueueRecord;

enum PQueueOperation { ADD, REMOVE_MIN };

typedef struct priority_queue_record {
  PQueueOperation op;
  int val;     // only for add
  int score;   // only for add
  int result;  // 0 or 1 for add
  int start_time;
  int stop_time;
} PQueueRecord;

typedef struct set_schedule {
  int* lengths;      // array of length nthreads
  SetRecord** rows;  // array of length nthreads, rows[i] has length lengths[i]  
} SetSchedule;

typedef struct queue_schedule {
  int* lengths;      // array of length nthreads
  QueueRecord** rows;  // array of length nthreads, rows[i] has length lengths[i]  
} QueueSchedule;

typedef struct pqueue_schedule {
  int* lengths;      // array of length nthreads
  PQueueRecord** rows;  // array of length nthreads, rows[i] has length lengths[i]  
} PQueueSchedule;

SetSchedule make_set_schedule(int num_threads, int steps_bound);
void destroy_set_schedule(SetSchedule s);

QueueSchedule make_queue_schedule(int num_threads, int steps_bound);
void destroy_queue_schedule(QueueSchedule s);

PQueueSchedule make_pqueue_schedule(int num_threads, int steps_bound);
void destroy_pqueue_schedule(PQueueSchedule s);

