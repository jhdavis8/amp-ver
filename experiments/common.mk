# Common Makefile elements for the experiments.
# Make sure ROOT is defined before including this file.
# ROOT should be a path to the root directory of the distribution.
include $(ROOT)/common.mk

# Experiment directories
EXP = src
SET_DIR = $(EXP)/hashset
LIST_DIR = $(EXP)/list
QUEUE_DIR = $(EXP)/queue
PQUEUE_DIR = $(EXP)/pqueue
SCHEDULE_DIR = $(EXP)/schedule
OUT_DIR = results/out

# Collection kinds: wrap any kind of collection into one interface
SET_COL = $(DRIVER)/set_collection.cvl
QUEUE_COL = $(DRIVER)/queue_collection.cvl
PQUEUE_COL = $(DRIVER)/pqueue_collection.cvl

# Oracles: specify expected behavior
NBSET_OR = $(DRIVER)/nonblocking_set_oracle.cvl
NBQUEUE_OR = $(DRIVER)/nonblocking_queue_oracle.cvl
BQUEUE_OR = $(DRIVER)/bounded_queue_oracle.cvl
SQUEUE_OR = $(DRIVER)/sync_queue_oracle.cvl
NBPQUEUE_OR = $(DRIVER)/nonblocking_pqueue_oracle.cvl

# Global bound settings
BOUND_A = -hashKind=ident -valueBound=2 -nthread=1..2 -nstep=1..2 \
  -npreAdd=0 -checkTermination -threadSym -ncore=$(NCORE)
BOUND_B = -hashKind=ident -valueBound=3 -nthread=1..2 -nstep=1..2 \
  -npreAdd=0..1 -checkTermination -threadSym -ncore=$(NCORE)
BOUND_C = -hashKind=nd -valueBound=3 -nthread=1..2 -nstep=1..2 \
  -npreAdd=0..1 -checkTermination -threadSym -ncore=$(NCORE) \
  -hashRangeBound=2 -hashDomainBound=3
BOUND_D = -hashKind=ident -valueBound=4 -nthread=1..3 -nstep=1..3 \
  -npreAdd=0..1 -checkTermination -threadSym -ncore=$(NCORE)
BOUND_E = -hashKind=ident -valueBound=5 -nthread=1..3 -nstep=1..4 \
  -npreAdd=0..1 -checkTermination -threadSym -ncore=$(NCORE) \
  -preemptionBound=2

# Notes on the above bounds:
# BOUND_A:
#   - Lists: 63 schedules
#   - Queues: 9 schedules
#   - SyncQueues: 9 schedules
#   - PQueues: 7 schedules
#   - Hashsets: 63 schedules
# BOUND_B:
#   - Lists: 270 schedules
#   - Queues: 18 schedules
#   - SyncQueues: 25 schedules
#   - PQueues: 25 schedules
#   - Hashsets: 270 schedules
# BOUND_C:
#   - Lists: 270 schedules
#   - Queues: 18 schedules
#   - SyncQueues: 25 schedules
#   - PQueues: 25 schedules
#   - Hashsets: 270 schedules
# BOUND_D:
#   - Lists: 8108 schedules
#   - Queues: 58 schedules
#   - SyncQueues: 83 schedules
#   - PQueues: 156 schedules
#   - Hashsets: 8108 schedules
# BOUND_E:
#   - Lists: 322930 schedules
#   - Queues: 166 schedules
#   - SyncQueues: 223 schedules
#   - PQueues: 1096 schedules
#   - Hashsets: 322930 schedules
