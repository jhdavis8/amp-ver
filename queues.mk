# Filename : queues.mk
# Author   : Josh Davis, Stephen F. Siegel
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for queue experiments.
ROOT = .
include $(ROOT)/common.mk


## Common definitions

QUEUES = queue_1 queue_2 queue_3

all: $(QUEUES) queue_schedules

$(QUEUES): queue_%: out/BoundedQueue_%.out \
  out/UnboundedQueue_%.out out/LockFreeQueue_%.out \
  out/SynchronousQueue_%.out out/SynchronousDualQueue2_%.out

queue_schedules: \
  $(addprefix out/BoundedQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/UnboundedQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LockFreeQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/SynchronousQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/SynchronousDualQueue2_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf out/BoundedQueue*.* out/UnboundedQueue*.* \
  out/LockFreeQueue*.* out/SynchronousQueue*.* out/SynchronousDualQueue*.*

.PHONY: clean all myall $(QUEUES) queue_schedules

# 25 schedules
QUEUE_LIMITS_1  = -kind=queue -genericVals -threadSym -nthread=1..2 \
  -nstep=1..3 -npreAdd=0 -checkTermination -ncore=$(NCORE)

# 58 schedules
QUEUE_LIMITS_2 = -kind=queue -genericVals -threadSym -nthread=1..3 \
  -nstep=1..3 -npreAdd=0..1 -checkTermination -ncore=$(NCORE)

# 249 schedules
QUEUE_LIMITS_3  = -kind=queue -genericVals -threadSym -nthread=1..3 \
  -nstep=1..4 -npreAdd=0..2 -checkTermination -ncore=$(NCORE)

QUEUE_INC = $(DRIVER_INC) $(QUEUE_H) queues.mk
QUEUE_SRC = $(DRIVER_SRC) $(QUEUE_COL)
QUEUE_DEP = $(QUEUE_INC) $(QUEUE_SRC)
QUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_queue_1.cvl
QUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_queue_2.cvl
QUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_queue_3.cvl
QUEUE_SCHED_4 = $(SCHEDULE_DIR)/sched_queue_4.cvl


## BoundedQueue

BQUEUE = $(QUEUE_DIR)/BoundedQueue.cvl
BQUEUE_SRC = $(BQUEUE) $(LOCK_SRC) $(AI_SRC) $(COND2_SRC)
BQUEUE_ALL = $(QUEUE_SRC) $(BQUEUE_SRC) $(BQUEUE_OR)
BQUEUE_DEP = $(BQUEUE_ALL) $(QUEUE_INC) $(LOCK_INC) $(AI_INC) $(COND2_INC)
BQUEUE_OUT = $(addprefix out/BoundedQueue_,$(addsuffix .out,1 2 3))

# Multiple schedule analyses.
# Example: make -f queues.mk out/BoundedQueue_1.out
CAP=2 # queue capacity
$(BQUEUE_OUT): out/BoundedQueue_%.out: $(MAIN_CLASS) $(BQUEUE_DEP)
	rm -rf out/BoundedQueue_$*.dir.tmp
	$(AMPVER) $(QUEUE_LIMITS_$*) -spec=bounded -capacity=$(CAP) \
  -checkMemoryLeak=false -tmpDir=out/BoundedQueue_$*.dir.tmp \
  $(BQUEUE_SRC) > out/BoundedQueue_$*.out.tmp
	rm -rf out/BoundedQueue_$*.dir
	mv out/BoundedQueue_$*.out.tmp out/BoundedQueue_$*.out
	mv out/BoundedQueue_$*.dir.tmp out/BoundedQueue_$*.dir

# Single Schedules.
# Ex: make -f queues.mk out/BoundedQueue_S1.out
out/BoundedQueue_S%.out: $(BQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  -DCAPACITY=2 $(BQUEUE_ALL) $(QUEUE_SCHED_$*) >out/BoundedQueue_S$*.out


## UnboundedQueue

UBQUEUE = $(QUEUE_DIR)/UnboundedQueue.cvl
UBQUEUE_SRC = $(UBQUEUE) $(LOCK_SRC)
UBQUEUE_ALL = $(QUEUE_SRC) $(UBQUEUE_SRC) $(NBQUEUE_OR)
UBQUEUE_DEP = $(UBQUEUE_ALL) $(QUEUE_INC) $(LOCK_INC)
UBQUEUE_OUT = $(addprefix out/UnboundedQueue_,$(addsuffix .out,1 2 3))

# Example: make -f queues.mk out/UnboundedQueue_1.out
$(UBQUEUE_OUT): out/UnboundedQueue_%.out: $(MAIN_CLASS) $(UBQUEUE_DEP)
	rm -rf out/UnboundedQueue_$*.dir.tmp
	$(AMPVER) $(QUEUE_LIMITS_$*) -spec=nonblocking \
  -checkMemoryLeak=false -tmpDir=out/UnboundedQueue_$*.dir.tmp \
  $(UBQUEUE_SRC) >out/UnboundedQueue_$*.out.tmp
	rm -rf out/UnboundedQueue_$*.dir
	mv out/UnboundedQueue_$*.out.tmp out/UnboundedQueue_$*.out
	mv out/UnboundedQueue_$*.dir.tmp out/UnboundedQueue_$*.dir

# Example: make -f queues.mk out/UnboundedQueue_S1.out
out/UnboundedQueue_S%.out: $(UBQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  $(UBQUEUE_ALL) $(QUEUE_SCHED_$*) >out/UnboundedQueue_S$*.out


## LockFreeQueue

LFQUEUE = $(QUEUE_DIR)/LockFreeQueue.cvl
LFQUEUE_SRC = $(LFQUEUE) $(AR_SRC)
LFQUEUE_ALL = $(QUEUE_SRC) $(LFQUEUE_SRC) $(NBQUEUE_OR)
LFQUEUE_DEP = $(LFQUEUE_ALL) $(QUEUE_INC) $(AR_INC)
LFQUEUE_OUT =  $(addprefix out/LockFreeQueue_,$(addsuffix .out,1 2 3))

# Example: make -f queues.mk out/LockFreeQueue_1.out
$(LFQUEUE_OUT): out/LockFreeQueue_%.out: $(MAIN_CLASS) $(LFQUEUE_DEP)
	rm -rf out/LockFreeQueue_$*.dir.tmp
	$(AMPVER) $(QUEUE_LIMITS_$*) -spec=nonblocking \
  -checkMemoryLeak=false -tmpDir=out/LockFreeQueue_$*.dir.tmp \
  $(LFQUEUE_SRC) >out/LockFreeQueue_$*.out.tmp
	rm -rf out/LockFreeQueue_$*.dir
	mv out/LockFreeQueue_$*.out.tmp out/LockFreeQueue_$*.out
	mv out/LockFreeQueue_$*.dir.tmp out/LockFreeQueue_$*.dir

# Example: make -f queues.mk out/LockFreeQueue_S0.out
out/LockFreeQueue_S%.out: $(LFQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  $(LFQUEUE_ALL) $(QUEUE_SCHED_$*) >out/LockFreeQueue_S$*.out


## SynchronousQueue

SQUEUE = $(QUEUE_DIR)/SynchronousQueue.cvl
SQUEUE_SRC = $(SQUEUE) $(LOCK_SRC) $(COND2_SRC)
SQUEUE_ALL = $(QUEUE_SRC) $(SQUEUE_SRC) $(SQUEUE_OR)
SQUEUE_DEP = $(SQUEUE_ALL) $(QUEUE_INC) $(LOCK_INC) $(COND2_INC)
SQUEUE_OUT =  $(addprefix out/SynchronousQueue_,$(addsuffix .out,1 2 3))

# Example: make -f queues.mk out/SynchronousQueue_1.out
$(SQUEUE_OUT): out/SynchronousQueue_%.out: $(MAIN_CLASS) $(SQUEUE_DEP)
	rm -rf out/SynchronousQueue_$*.dir.tmp
	$(AMPVER) $(QUEUE_LIMITS_$*) -spec=sync \
  -checkMemoryLeak=true -checkTermination=true \
  -tmpDir=out/SynchronousQueue_$*.dir.tmp \
  $(SQUEUE_SRC) >out/SynchronousQueue_$*.out.tmp
	rm -rf out/SynchronousQueue_$*.dir
	mv out/SynchronousQueue_$*.out.tmp out/SynchronousQueue_$*.out
	mv out/SynchronousQueue_$*.dir.tmp out/SynchronousQueue_$*.dir

# Example: make -f queues.mk out/SynchronousQueue_S0.out
out/SynchronousQueue_S%.out: $(SQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=true -checkTermination=true \
  $(SQUEUE_ALL) $(QUEUE_SCHED_$*) >out/SynchronousQueue_S$*.out


# SynchronousDualQueue

# This one uses the synchronous queue oracle.  No "pre-adds" are allowed,
# they don't make sense for a synchronous queue.

SQUEUE_LIMITS_1 = -kind=queue -fair -genericVals -threadSym -nthread=1..2 \
  -nstep=1..3 -npreAdd=0 -checkTermination=true -ncore=$(NCORE)

SQUEUE_LIMITS_2 = -kind=queue -fair -genericVals -threadSym -nthread=1..3 \
  -nstep=1..3 -npreAdd=0 -checkTermination=true -ncore=1

SQUEUE_LIMITS_3 = -kind=queue -fair -genericVals -threadSym -nthread=1..3 \
  -nstep=1..4 -npreAdd=0 -checkTermination=true -ncore=1

SQUEUE_LIMITS_4 = -kind=queue -fair -genericVals -threadSym -nthread=4 \
  -nstep=4 -npreAdd=0 -checkTermination=true -ncore=1

SDQUEUE = $(QUEUE_DIR)/SynchronousDualQueue2.cvl
SDQUEUE_SRC = $(SDQUEUE) $(AI_SRC) $(AR_SRC) $(NPD_SRC)
SDQUEUE_ALL = $(QUEUE_SRC) $(SDQUEUE_SRC) $(SQUEUE_OR)
SDQUEUE_DEP = $(SDQUEUE_ALL) $(QUEUE_INC) $(AI_INC) $(AR_INC) $(NPD_INC)
SDQUEUE_OUT = $(addprefix out/SynchronousDualQueue2_,$(addsuffix .out,1 2 3 4))

# Example: make -f queues.mk out/SynchronousDualQueue2_1.out
$(SDQUEUE_OUT): out/SynchronousDualQueue2_%.out: $(MAIN_CLASS) $(SDQUEUE_DEP)
	rm -rf out/SynchronousDualQueue2_$*.dir.tmp
	$(AMPVER) $(SQUEUE_LIMITS_$*) -spec=sync \
  -checkMemoryLeak=false -tmpDir=out/SynchronousDualQueue2_$*.dir.tmp \
  $(SDQUEUE_SRC) >out/SynchronousDualQueue2_$*.out.tmp
	rm -rf out/SynchronousDualQueue2_$*.dir
	mv out/SynchronousDualQueue2_$*.out.tmp out/SynchronousDualQueue2_$*.out
	mv out/SynchronousDualQueue2_$*.dir.tmp out/SynchronousDualQueue2_$*.dir

# using preemptionBound ...

SDQUEUE1 = $(QUEUE_DIR)/SynchronousDualQueue1.cvl
SDQUEUE1_SRC = $(SDQUEUE1) $(AI_SRC) $(AR_SRC)
SDQUEUE1_ALL = $(QUEUE_SRC) $(SDQUEUE1_SRC) $(SQUEUE_OR)
SDQUEUE1_DEP = $(SDQUEUE1_ALL) $(QUEUE_INC) $(AI_INC) $(AR_INC)
# Example: make -f queues.mk
out/SynchronousDualQueue1_S%.out: $(SDQUEUE1_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  -preemptionBound=4 \
  $(SDQUEUE1_ALL) $(QUEUE_SCHED_$*) >out/SynchronousDualQueue1_S$*.out
