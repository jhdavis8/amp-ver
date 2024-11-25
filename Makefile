# ------------------------------------------------------------------------------------
# AMPVer: A CIVL Model-Checking Verification Framework for Concurrent Data
# Structures
#
# This is the Makefile for AMPVer.
# ------------------------------------------------------------------------------

ROOT = .
include $(ROOT)/common.mk
include $(ROOT)/sets.mk
include $(ROOT)/lists.mk
include $(ROOT)/queues.mk
include $(ROOT)/pqueues.mk

#############################  Test and all rules  #############################

# quick test: 4 cores, 13 schedules
test: $(MAIN_CLASS) $(UNBOUNDEDQUEUE_DEP)
	rm -rf out/Test_1.tmp
	-$(AMPVER) \
          -kind=queue \
          -nthread=1..2 \
          -nstep=1..2 \
          -npreAdd=0..1 \
          -genericVals -threadSym \
          $(SRC)/queue/UnboundedQueue.cvl \
          $(SRC)/util/ReentrantLock.cvl \
          -ncore=$(NCORE) \
          -tmpDir=out/Test_1.tmp \
          >out/Test_1.out.tmp 2>out/Test_1.out.tmp
	mv out/Test_1.out.tmp out/Test_1.out

all_schedules: hashset_schedules list_schedules queue_schedules pqueue_schedules

all_S1: out/CoarseHashSet_S1 out/CoarseList_S1 out/UnboundedQueue_S1 \
	out/LockFreeQueue_S1 out/FineGrainedHeap_S1 out/FineGrainedHeapFair_S1 \
	out/FineGrainedHeapNoCycles_S1 out/SkipQueue_S1 out/SkipQueuePatched_S1

all_S2: out/CoarseHashSet_S2 out/CoarseList_S2 out/UnboundedQueue_S2 \
	out/LockFreeQueue_S2 out/FineGrainedHeap_S2 out/FineGrainedHeapFair_S2 \
	out/FineGrainedHeapNoCycles_S2 out/SkipQueue_S2 out/SkipQueuePatched_S2

all_S3: out/CoarseHashSet_S3 out/CoarseList_S3 out/UnboundedQueue_S3 \
	out/LockFreeQueue_S3 out/FineGrainedHeap_S3 out/FineGrainedHeapFair_S3 \
	out/FineGrainedHeapNoCycles_S3 out/SkipQueue_S3 out/SkipQueuePatched_S3

.PHONY: all test CoarseList2 UnboundedQueue1 SkipQueue1 SkipQueue2 FineGrainedHeap1 \
  list_0 list_1 list_2
