# Tests for some driver modules

all: nb_pqueue nb_set nb_queue b_queue s_queue

nb_pqueue: nonblocking_pqueue_oracle.cvl
	civl verify -userIncludePath=../../include -D_NB_PQUEUE_ORACLE_TEST \
  nonblocking_pqueue_oracle.cvl

nb_set: nonblocking_set_oracle.cvl
	civl verify -userIncludePath=../../include -D_NB_SET_ORACLE_TEST \
  nonblocking_set_oracle.cvl

nb_queue: nonblocking_queue_oracle.cvl
	civl verify -userIncludePath=../../include -D_NB_QUEUE_ORACLE_TEST \
  nonblocking_queue_oracle.cvl

b_queue: bounded_queue_oracle.cvl
	civl verify -userIncludePath=../../include -D_B_QUEUE_ORACLE_TEST \
  bounded_queue_oracle.cvl

s_queue: sync_queue_oracle.cvl
	civl verify -userIncludePath=../../include -D_S_QUEUE_ORACLE_TEST \
  sync_queue_oracle.cvl

.PHONE: all nb_pqueue nb_set nb_queue b_queue s_queue
