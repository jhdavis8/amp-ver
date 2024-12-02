ROOT = .

#################################  Queues  #################################

# 25 schedules
QUEUE_LIMITS_1  = -kind=queue -genericVals -threadSym -nthread=1..2 \
     -nstep=1..3 -npreAdd=0 -checkTermination -ncore=$(NCORE)

# 58 schedules
QUEUE_LIMITS_2 = -kind=queue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..3 -npreAdd=0..1 -checkTermination -ncore=$(NCORE)

# 249 schedules
QUEUE_LIMITS_3  = -kind=queue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..4 -npreAdd=0..2 -checkTermination -ncore=$(NCORE)

queue_1 queue_2 queue_3: queue_%: out/BoundedQueue_%.out \
  out/UnboundedQueue_%.out out/LockFreeQueue_%.out

queue_schedules: out/BoundedQueue_S1 out/BoundedQueue_S2 out/BoundedQueue_S3 \
	out/UnboundedQueue_S1 out/UnboundedQueue_S2 out/UnboundedQueue_S3 \
	out/LockFreeQueue_S1 out/LockFreeQueue_S2 out/LockFreeQueue_S3

QUEUE1 = $(SCHEDULE_DIR)/sched_queue_1.cvl
QUEUE_COMMON_DEP = $(DRIVER_INC) $(DRIVER_NB_SRC) $(DRIVER_QUEUE_NB) Makefile
QUEUE_B_COMMON_DEP = $(DRIVER_INC) $(DRIVER_B_SRC) $(DRIVER_QUEUE_B) Makefile
QUEUE_COMMON_SRC = $(DRIVER_NB_SRC) $(DRIVER_QUEUE_NB)
QUEUE_B_COMMON_SRC = $(DRIVER_B_SRC) $(DRIVER_QUEUE_B)

QUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_queue_1.cvl
QUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_queue_2.cvl
QUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_queue_3.cvl

# BoundedQueue

BOUNDEDQUEUE = $(QUEUE_DIR)/BoundedQueue.cvl
BOUNDEDQUEUE_DEP = $(QUEUE_B_COMMON_DEP) $(BOUNDEDQUEUE) \
   $(LOCK_INC) $(LOCK_SRC) $(AI_INC) $(AI_SRC) \
   $(COND2_INC) $(COND2_SRC) $(TID_INC) $(TID_SRC)
BOUNDEDQUEUE_SRC = $(QUEUE_B_COMMON_SRC) \
   $(BOUNDEDQUEUE) $(LOCK_SRC) $(AI_SRC) $(COND2_SRC) $(TID_SRC)
BoundedQueue_Outs = out/BoundedQueue_1.out out/BoundedQueue_2.out \
   out/BoundedQueue_3.out

$(BoundedQueue_Outs): out/BoundedQueue_%.out: $(MAIN_CLASS) $(BOUNDEDQUEUE_DEP)
	rm -rf $(TMP)/BoundedQueue_$*.dir.tmp
	rm -rf out/BoundedQueue_$*.dir
	-$(AMPVER) $(QUEUE_LIMITS_$*) -blocking=true -tmpDir=$(TMP)/BoundedQueue_$*.dir.tmp \
  -checkMemoryLeak=false $(BOUNDEDQUEUE) $(LOCK_SRC) $(AI_SRC) $(COND2_SRC) \
  >out/BoundedQueue_$*.out.tmp
	mv $(TMP)/BoundedQueue_$*.out.tmp out/BoundedQueue_$*.out
	mv $(TMP)/BoundedQueue_$*.dir.tmp out/BoundedQueue_$*.dir

out/BoundedQueue_S%: $(BOUNDEDQUEUE_DEP) $(QUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(BOUNDEDQUEUE_SRC) $(QUEUE_SCHED_$*) >out/BoundedQueue_S$*

# UnboundedQueue

UNBOUNDEDQUEUE = $(QUEUE_DIR)/UnboundedQueue.cvl
UNBOUNDEDQUEUE_DEP = $(QUEUE_COMMON_DEP) $(UNBOUNDEDQUEUE) \
                     $(LOCK_INC) $(LOCK_SRC)
UNBOUNDEDQUEUE_SRC = $(QUEUE_COMMON_SRC) $(UNBOUNDEDQUEUE) $(LOCK_SRC)
UnboundedQueue_Outs = out/UnboundedQueue_1.out out/UnboundedQueue_2.out \
                      out/UnboundedQueue_3.out

$(UnboundedQueue_Outs): out/UnboundedQueue_%.out: $(MAIN_CLASS) $(UNBOUNDEDQUEUE_DEP)
	rm -rf $(TMP)/UnboundedQueue_$*.dir.tmp
	rm -rf out/UnboundedQueue_$*.dir
	-$(AMPVER) $(QUEUE_LIMITS_$*) -tmpDir=$(TMP)/UnboundedQueue_$*.dir.tmp \
          -checkMemoryLeak=false $(UNBOUNDEDQUEUE) $(LOCK_SRC) \
          >out/UnboundedQueue_$*.out.tmp
	mv $(TMP)/UnboundedQueue_$*.out.tmp out/UnboundedQueue_$*.out
	mv $(TMP)/UnboundedQueue_$*.dir.tmp out/UnboundedQueue_$*.dir

out/UnboundedQueue_S%: $(UNBOUNDEDQUEUE_DEP) $(QUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(UNBOUNDEDQUEUE_SRC) $(QUEUE_SCHED_$*) >out/UnboundedQueue_S$*

# LockFreeQueue

LOCKFREEQUEUE = $(QUEUE_DIR)/LockFreeQueue.cvl
LOCKFREEQUEUE_DEP = $(QUEUE_COMMON_DEP) $(LOCKFREEQUEUE) $(AR_INC) $(AR_SRC)
LOCKFREEQUEUE_SRC = $(QUEUE_COMMON_SRC) $(LOCKFREEQUEUE) $(AR_SRC)
LockFreeQueue_Outs = out/LockFreeQueue_1.out out/LockFreeQueue_2.out \
                     out/LockFreeQueue_3.out

$(LockFreeQueue_Outs): out/LockFreeQueue_%.out: $(MAIN_CLASS) $(LOCKFREEQUEUE_DEP)
	rm -rf $(TMP)/LockFreeQueue_$*.dir.tmp
	rm -rf out/LockFreeQueue_$*.dir
	-$(AMPVER) $(QUEUE_LIMITS_$*) -tmpDir=$(TMP)/LockFreeQueue_$*.dir.tmp \
          -checkMemoryLeak=false $(LOCKFREEQUEUE) $(AR_SRC) \
          >$(TMP)/LockFreeQueue_$*.out.tmp
	mv $(TMP)/LockFreeQueue_$*.out.tmp out/LockFreeQueue_$*.out
	mv $(TMP)/LockFreeQueue_$*.dir.tmp out/LockFreeQueue_$*.dir

out/LockFreeQueue_S%: $(LOCKFREEQUEUE_DEP) $(QUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(LOCKFREEQUEUE_SRC) $(QUEUE_SCHED_$*) \
					>out/LockFreeQueue_S$*

# SynchronousDualQueue

SYNCDUALQUEUE = $(QUEUE_DIR)/SynchronousDualQueue.cvl
SYNCDUALQUEUE_DEP = $(QUEUE_COMMON_DEP) 
