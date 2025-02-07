# Filename : queues.mk
# Author   : Josh Davis, Stephen F. Siegel
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for queue experiments.

EROOT=.
include $(EROOT)/common.mk


## Common definitions

QUEUES = queue_A queue_B queue_C queue_D queue_E

all: $(QUEUES)

$(QUEUES): queue_%: $(OUT_DIR)/BoundedQueue_%.out \
  $(OUT_DIR)/UnboundedQueue_%.out $(OUT_DIR)/LockFreeQueue_%.out \
  $(OUT_DIR)/SynchronousQueue_%.out $(OUT_DIR)/SynchronousDualQueue_%.out \
  $(OUT_DIR)/SynchronousDualQueuePatched_%.out

queue_schedules: \
  $(addprefix $(OUT_DIR)/BoundedQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/UnboundedQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/LockFreeQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/SynchronousQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/SynchronousDualQueue_S,$(addsuffix .out,1 2 3))

bugs:	$(OUT_DIR)/SynchronousDualQueue_D.out

clean:
	rm -rf $(OUT_DIR)/BoundedQueue*.* $(OUT_DIR)/UnboundedQueue*.* \
  $(OUT_DIR)/LockFreeQueue*.* $(OUT_DIR)/SynchronousQueue*.* $(OUT_DIR)/SynchronousDualQueue*.*

.PHONY: clean all myall $(QUEUES) queue_schedules bugs

DRY ?= FALSE
DRYFLAG =
ifneq ($(DRY),FALSE)
	DRYFLAG = -dryrun
endif

# New queue bound settings
QUEUE_BOUND_A = -kind=queue -genericVals $(BOUND_A) $(DRYFLAG)
QUEUE_BOUND_B = -kind=queue -genericVals $(BOUND_B) $(DRYFLAG)
QUEUE_BOUND_C = -kind=queue -genericVals $(BOUND_C) $(DRYFLAG)
QUEUE_BOUND_D = -kind=queue -genericVals $(BOUND_D) $(DRYFLAG)
QUEUE_BOUND_E = -kind=queue -genericVals $(BOUND_E) $(DRYFLAG)

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
BQUEUE_OUT = $(addprefix $(OUT_DIR)/BoundedQueue_,$(addsuffix .out,A B C D E))

# Multiple schedule analyses.
# Example: make -f queues.mk $(OUT_DIR)/BoundedQueue_1.out
CAP=2 # queue capacity
$(BQUEUE_OUT): $(OUT_DIR)/BoundedQueue_%.out: $(COLLECT) $(BQUEUE_DEP)
	rm -rf $(OUT_DIR)/BoundedQueue_$*.dir.tmp
	-$(COLLECT) $(QUEUE_BOUND_$*) -spec=bounded -capacity=$(CAP) \
  -checkMemoryLeak=false -tmpDir=$(OUT_DIR)/BoundedQueue_$*.dir.tmp \
  $(BQUEUE_SRC) > $(OUT_DIR)/BoundedQueue_$*.out.tmp
	rm -rf $(OUT_DIR)/BoundedQueue_$*.dir
	mv $(OUT_DIR)/BoundedQueue_$*.out.tmp $(OUT_DIR)/BoundedQueue_$*.out
	mv $(OUT_DIR)/BoundedQueue_$*.dir.tmp $(OUT_DIR)/BoundedQueue_$*.dir

# Single Schedules.
# Ex: make -f queues.mk $(OUT_DIR)/BoundedQueue_S1.out
$(OUT_DIR)/BoundedQueue_S%.out: $(BQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  -DCAPACITY=2 $(BQUEUE_ALL) $(QUEUE_SCHED_$*) >$(OUT_DIR)/BoundedQueue_S$*.out


## UnboundedQueue

UBQUEUE = $(QUEUE_DIR)/UnboundedQueue.cvl
UBQUEUE_SRC = $(UBQUEUE) $(LOCK_SRC)
UBQUEUE_ALL = $(QUEUE_SRC) $(UBQUEUE_SRC) $(NBQUEUE_OR)
UBQUEUE_DEP = $(UBQUEUE_ALL) $(QUEUE_INC) $(LOCK_INC)
UBQUEUE_OUT = $(addprefix $(OUT_DIR)/UnboundedQueue_,$(addsuffix .out,A B C D E))

# Example: make -f queues.mk $(OUT_DIR)/UnboundedQueue_1.out
$(UBQUEUE_OUT): $(OUT_DIR)/UnboundedQueue_%.out: $(COLLECT) $(UBQUEUE_DEP)
	rm -rf $(OUT_DIR)/UnboundedQueue_$*.dir.tmp
	-$(COLLECT) $(QUEUE_BOUND_$*) -spec=nonblocking \
  -checkMemoryLeak=false -tmpDir=$(OUT_DIR)/UnboundedQueue_$*.dir.tmp \
  $(UBQUEUE_SRC) >$(OUT_DIR)/UnboundedQueue_$*.out.tmp
	rm -rf $(OUT_DIR)/UnboundedQueue_$*.dir
	mv $(OUT_DIR)/UnboundedQueue_$*.out.tmp $(OUT_DIR)/UnboundedQueue_$*.out
	mv $(OUT_DIR)/UnboundedQueue_$*.dir.tmp $(OUT_DIR)/UnboundedQueue_$*.dir

# Example: make -f queues.mk $(OUT_DIR)/UnboundedQueue_S1.out
$(OUT_DIR)/UnboundedQueue_S%.out: $(UBQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  $(UBQUEUE_ALL) $(QUEUE_SCHED_$*) >$(OUT_DIR)/UnboundedQueue_S$*.out


## LockFreeQueue

LFQUEUE = $(QUEUE_DIR)/LockFreeQueue.cvl
LFQUEUE_SRC = $(LFQUEUE) $(AR_SRC)
LFQUEUE_ALL = $(QUEUE_SRC) $(LFQUEUE_SRC) $(NBQUEUE_OR)
LFQUEUE_DEP = $(LFQUEUE_ALL) $(QUEUE_INC) $(AR_INC)
LFQUEUE_OUT =  $(addprefix $(OUT_DIR)/LockFreeQueue_,$(addsuffix .out,A B C D E))

# Example: make -f queues.mk $(OUT_DIR)/LockFreeQueue_1.out
$(LFQUEUE_OUT): $(OUT_DIR)/LockFreeQueue_%.out: $(COLLECT) $(LFQUEUE_DEP)
	rm -rf $(OUT_DIR)/LockFreeQueue_$*.dir.tmp
	-$(COLLECT) $(QUEUE_BOUND_$*) -spec=nonblocking \
  -checkMemoryLeak=false -tmpDir=$(OUT_DIR)/LockFreeQueue_$*.dir.tmp \
  $(LFQUEUE_SRC) >$(OUT_DIR)/LockFreeQueue_$*.out.tmp
	rm -rf $(OUT_DIR)/LockFreeQueue_$*.dir
	mv $(OUT_DIR)/LockFreeQueue_$*.out.tmp $(OUT_DIR)/LockFreeQueue_$*.out
	mv $(OUT_DIR)/LockFreeQueue_$*.dir.tmp $(OUT_DIR)/LockFreeQueue_$*.dir

# Example: make -f queues.mk $(OUT_DIR)/LockFreeQueue_S0.out
$(OUT_DIR)/LockFreeQueue_S%.out: $(LFQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false \
  $(LFQUEUE_ALL) $(QUEUE_SCHED_$*) >$(OUT_DIR)/LockFreeQueue_S$*.out


# These use the synchronous queue oracle.  No "pre-adds" are allowed,
# they don't make sense for a synchronous queue.

# New synchronous queue bound settings
SQUEUE_BOUND_A = -kind=queue -fair -genericVals -threadSym -nthread=1..2 \
	-nstep=1..2 -npreAdd=0 -checkTermination=true -ncore=$(NCORE) $(DRYFLAG)
SQUEUE_BOUND_B = -kind=queue -fair -genericVals -threadSym -nthread=1..2 \
	-nstep=1..3 -npreAdd=0 -checkTermination=true -ncore=$(NCORE) $(DRYFLAG)
SQUEUE_BOUND_C = -kind=queue -fair -genericVals -threadSym -nthread=1..2 \
	-nstep=1..3 -npreAdd=0 -checkTermination=true -ncore=$(NCORE) $(DRYFLAG)
SQUEUE_BOUND_D = -kind=queue -fair -genericVals -threadSym -nthread=1..3 \
	-nstep=1..4 -npreAdd=0 -checkTermination=true -ncore=$(NCORE) $(DRYFLAG)
SQUEUE_BOUND_E = -kind=queue -fair -genericVals -threadSym -nthread=1..3 \
	-nstep=1..5 -npreAdd=0 -checkTermination=true -ncore=$(NCORE) $(DRYFLAG) -preemptionBound=2

## SynchronousQueue

SQUEUE = $(QUEUE_DIR)/SynchronousQueue.cvl
SQUEUE_SRC = $(SQUEUE) $(LOCK_SRC) $(COND2_SRC)
SQUEUE_ALL = $(QUEUE_SRC) $(SQUEUE_SRC) $(SQUEUE_OR)
SQUEUE_DEP = $(SQUEUE_ALL) $(QUEUE_INC) $(LOCK_INC) $(COND2_INC)
SQUEUE_OUT =  $(addprefix $(OUT_DIR)/SynchronousQueue_,$(addsuffix .out,A B C D E))

# Example: make -f queues.mk $(OUT_DIR)/SynchronousQueue_1.out
$(SQUEUE_OUT): $(OUT_DIR)/SynchronousQueue_%.out: $(COLLECT) $(SQUEUE_DEP)
	rm -rf $(OUT_DIR)/SynchronousQueue_$*.dir.tmp
	-$(COLLECT) $(SQUEUE_BOUND_$*) -spec=sync \
  -checkMemoryLeak=true -tmpDir=$(OUT_DIR)/SynchronousQueue_$*.dir.tmp \
  $(SQUEUE_SRC) >$(OUT_DIR)/SynchronousQueue_$*.out.tmp
	rm -rf $(OUT_DIR)/SynchronousQueue_$*.dir
	mv $(OUT_DIR)/SynchronousQueue_$*.out.tmp $(OUT_DIR)/SynchronousQueue_$*.out
	mv $(OUT_DIR)/SynchronousQueue_$*.dir.tmp $(OUT_DIR)/SynchronousQueue_$*.dir

# Example: make -f queues.mk $(OUT_DIR)/SynchronousQueue_S0.out
$(OUT_DIR)/SynchronousQueue_S%.out: $(SQUEUE_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=true -checkTermination=true \
  $(SQUEUE_ALL) $(QUEUE_SCHED_$*) >$(OUT_DIR)/SynchronousQueue_S$*.out


# SynchronousDualQueue

SDQUEUE = $(QUEUE_DIR)/SynchronousDualQueue.cvl
SDQUEUE_SRC = $(SDQUEUE) $(AI_SRC) $(AR_SRC) $(NPD_SRC)
SDQUEUE_ALL = $(QUEUE_SRC) $(SDQUEUE_SRC) $(SQUEUE_OR)
SDQUEUE_DEP = $(SDQUEUE_ALL) $(QUEUE_INC) $(AI_INC) $(AR_INC) $(NPD_INC)
SDQUEUE_OUT = $(addprefix $(OUT_DIR)/SynchronousDualQueue_,$(addsuffix .out,A B C D E))

# Example: make -f queues.mk $(OUT_DIR)/SynchronousDualQueue_1.out
$(SDQUEUE_OUT): $(OUT_DIR)/SynchronousDualQueue_%.out: $(COLLECT) $(SDQUEUE_DEP)
	rm -rf $(OUT_DIR)/SynchronousDualQueue_$*.dir.tmp
	-$(COLLECT) $(SQUEUE_BOUND_$*) -spec=sync \
  -checkMemoryLeak=false -tmpDir=$(OUT_DIR)/SynchronousDualQueue_$*.dir.tmp \
  $(SDQUEUE_SRC) >$(OUT_DIR)/SynchronousDualQueue_$*.out.tmp
	rm -rf $(OUT_DIR)/SynchronousDualQueue_$*.dir
	mv $(OUT_DIR)/SynchronousDualQueue_$*.out.tmp $(OUT_DIR)/SynchronousDualQueue_$*.out
	mv $(OUT_DIR)/SynchronousDualQueue_$*.dir.tmp $(OUT_DIR)/SynchronousDualQueue_$*.dir

SDQUEUEP_OUT = $(addprefix $(OUT_DIR)/SynchronousDualQueuePatched_,$(addsuffix .out,A B C D E))

$(SDQUEUEP_OUT): $(OUT_DIR)/SynchronousDualQueuePatched_%.out: $(COLLECT) $(SDQUEUE_DEP)
	rm -rf $(OUT_DIR)/SynchronousDualQueuePatched_$*.dir.tmp
	-$(COLLECT) $(SQUEUE_BOUND_$*) -spec=sync -D_PATCH \
  -checkMemoryLeak=false -tmpDir=$(OUT_DIR)/SynchronousDualQueuePatched_$*.dir.tmp \
  $(SDQUEUE_SRC) >$(OUT_DIR)/SynchronousDualQueuePatched_$*.out.tmp
	rm -rf $(OUT_DIR)/SynchronousDualQueuePatched_$*.dir
	mv $(OUT_DIR)/SynchronousDualQueuePatched_$*.out.tmp $(OUT_DIR)/SynchronousDualQueuePatched_$*.out
	mv $(OUT_DIR)/SynchronousDualQueuePatched_$*.dir.tmp $(OUT_DIR)/SynchronousDualQueuePatched_$*.dir

# using preemptionBound ...

SDQUEUE1 = $(QUEUE_DIR)/SynchronousDualQueueAlt.cvl
SDQUEUE1_SRC = $(SDQUEUE1) $(AI_SRC) $(AR_SRC)
SDQUEUE1_ALL = $(QUEUE_SRC) $(SDQUEUE1_SRC) $(SQUEUE_OR)
SDQUEUE1_DEP = $(SDQUEUE1_ALL) $(QUEUE_INC) $(AI_INC) $(AR_INC)
# Example: make -f queues.mk
$(OUT_DIR)/SynchronousDualQueueAlt_S%.out: $(SDQUEUE1_DEP) $(QUEUE_SCHED_$*)
	$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  -preemptionBound=4 \
  $(SDQUEUE1_ALL) $(QUEUE_SCHED_$*) >$(OUT_DIR)/SynchronousDualQueueAlt_S$*.out
