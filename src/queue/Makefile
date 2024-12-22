ROOT = ../..
include $(ROOT)/common.mk

all: UnboundedQueue LockFreeQueue

UnboundedQueue: UnboundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_UNBOUNDED_QUEUE_MAIN UnboundedQueue.cvl $(LOCK_SRC) $(TID_SRC)

LockFreeQueue: LockFreeQueue.cvl $(AR_INC) $(AR_SRC)
	$(VERIFY) -checkMemoryLeak=false -D_LOCK_FREE_QUEUE_MAIN \
          LockFreeQueue.cvl $(AR_SRC)

BoundedQueue: BoundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
		$(COND2_INC) $(COND2_SRC) $(TID_INC) $(TID_SRC) $(AI_INC) $(AI_SRC)
	$(VERIFY) -checkMemoryLeak=false -enablePrintf=false -D_BOUNDED_QUEUE_MAIN BoundedQueue.cvl $(LOCK_SRC) $(COND2_SRC) $(TID_SRC) $(AI_SRC)

# SDQ1 should get stuck (either deadlock or non-progress cycle) in
# every case where the number of enqueues does not equal the number of
# dequeues

SDQ1_SRC = SynchronousDualQueue1.cvl $(AI_SRC) $(AR_SRC) $(TID_SRC)
SDQ1_DEP = $(SDQ1_SRC) $(AI_INC) $(AR_INC)  $(TID_H)
SDQ1_RUN = $(VERIFY) -fair  -checkTermination=true \
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

SDQ2_SRC = SynchronousDualQueue2.cvl $(AI_SRC) $(AR_SRC) $(TID_SRC) \
  NPDetector.cvl
SDQ2_DEP = $(SDQ2_SRC) $(AI_INC) $(AR_INC)  $(TID_H) NPDetector.cvh
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

.PHONY: UnboundedQueue LockFreeQueue \
  sdq1_balanced1 sdq1_balanced2 sdq1_enqs1 sdq1_enqs2 sdq1_edd sdq1_eed \
  sdq2_balanced1 sdq2_balanced2 sdq2_enqs1 sdq2_enqs2 sdq2_edd sdq2_eed
