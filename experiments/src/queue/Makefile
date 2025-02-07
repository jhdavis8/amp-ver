# Filename : Makefile (src/queue)
# Author   : Josh Davis, Stephen F. Siegel
# Created  : 2024-01-25
# Modified : 2025-01-17

# This Makefile will perform a simple test for each data structure.
# There are two versions of the SynchronousDualQueue.  The first one
# is simple but does not have any way to recover from a "stuck"
# execution (one which livelocks with each non-terminated thread
# looping forever without changing the state).  That version is
# appropriate for checking schedules which should result in a normal
# execution in which every thread terminates.  The second version is
# more general and will detect and break out when livelock is
# detected; this version is more expensive (has bigger state space)
# but can be used to check correct behavior on any schedule, including
# those that should get stuck.

ROOT = ../..
include $(ROOT)/common.mk

all: UnboundedQueue LockFreeQueue BoundedQueue SynchronousQueue \
  SynchronousDualQueue

UnboundedQueue: UnboundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_UNBOUNDED_QUEUE_MAIN -checkTermination=true \
  -checkMemoryLeak=true UnboundedQueue.cvl $(LOCK_SRC) $(TID_SRC)

LockFreeQueue: LockFreeQueue.cvl $(AR_INC) $(AR_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -D_LOCK_FREE_QUEUE_MAIN LockFreeQueue.cvl $(AR_SRC) $(TID_SRC)

BoundedQueue: BoundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
  $(COND2_INC) $(COND2_SRC) $(TID_INC) $(TID_SRC) $(AI_INC) $(AI_SRC)
	$(VERIFY) -checkMemoryLeak=true -checkTermination=true \
  -enablePrintf=false \
  -D_BOUNDED_QUEUE_MAIN BoundedQueue.cvl $(LOCK_SRC) $(COND2_SRC) \
  $(TID_SRC) $(AI_SRC)

SynchronousQueue: SynchronousQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
  $(COND2_INC) $(COND2_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkMemoryLeak=true -enablePrintf=false \
  -checkTermination=true -D_SYNC_QUEUE_MAIN SynchronousQueue.cvl \
  $(LOCK_SRC) $(COND2_SRC) $(TID_SRC)

SynchronousDualQueue: sdq1 sdq2

# SDQ1 should get stuck (either deadlock or non-progress cycle) in
# every case where the number of enqueues does not equal the number of
# dequeues

SDQ1_SRC = SynchronousDualQueue1.cvl $(AI_SRC) $(AR_SRC) $(TID_SRC)
SDQ1_DEP = $(SDQ1_SRC) $(AI_INC) $(AR_INC)  $(TID_H)
SDQ1_RUN = $(VERIFY) -fair -checkTermination=true \
  -checkMemoryLeak=false -D_SYNCHRONOUS_DUAL_QUEUE

sdq1: sdq1_balanced1 sdq1_enqs1 sdq1_enqs2 sdq1_edd sdq1_eed

# #enq=#deq=1, should always succeed
sdq1_balanced1: $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=absolute -fair -checkTermination=true \
  -DBALANCED1 $(SDQ1_SRC)
# #enq=#deq=2, should always succeed (but state space too big)
sdq1_balanced2: $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=absolute -fair -checkTermination=true \
  -DBALANCED2 $(SDQ1_SRC)
# the following should always get stuck and there is an assert(false)
# that should never be reached...
sdq1_enqs1:  $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=none -DENQS1 $(SDQ1_SRC)
sdq1_enqs2:  $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=none -DENQS2 $(SDQ1_SRC)
sdq1_edd:  $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=none -DEDD $(SDQ1_SRC)
sdq1_eed:  $(SDQ1_DEP)
	$(SDQ1_RUN) -checkDeadlock=none -DEED $(SDQ1_SRC)

# SDQ2 has a mechanism to detect and recover when it gets stuck, using
# a "non-progress detector"...

SDQ2_SRC = SynchronousDualQueue2.cvl $(AI_SRC) $(AR_SRC) $(TID_SRC) $(NPD_SRC)
SDQ2_DEP = $(SDQ2_SRC) $(AI_INC) $(AR_INC)  $(TID_H) $(NPD_INC)
SDQ2_RUN = $(VERIFY) -fair -checkDeadlock=absolute -checkTermination=true \
  -checkMemoryLeak=false -D_SYNCHRONOUS_DUAL_QUEUE

sdq2: sdq2_balanced1 sdq2_enqs1 sdq2_enqs2 sdq2_edd sdq2_eed

sdq2_balanced1: $(SDQ2_DEP)
	$(SDQ2_RUN) -DBALANCED1 $(SDQ2_SRC)
sdq2_balanced2: $(SDQ2_DEP)
	$(SDQ2_RUN) -DBALANCED2 $(SDQ2_SRC)
sdq2_enqs1:  $(SDQ2_DEP)
	$(SDQ2_RUN) -DENQS1 $(SDQ2_SRC)
sdq2_enqs2:  $(SDQ2_DEP)
	$(SDQ2_RUN) -DENQS2 $(SDQ2_SRC)
sdq2_edd:  $(SDQ2_DEP)
	$(SDQ2_RUN) -DEDD $(SDQ2_SRC)
sdq2_eed:  $(SDQ2_DEP)
	$(SDQ2_RUN) -DEED $(SDQ2_SRC)

.PHONY: UnboundedQueue LockFreeQueue SynchronousQueue SynchronousDualQueue \
  sdq1_balanced1 sdq1_balanced2 sdq1_enqs1 sdq1_enqs2 sdq1_edd sdq1_eed \
  sdq2_balanced1 sdq2_balanced2 sdq2_enqs1 sdq2_enqs2 sdq2_edd sdq2_eed
