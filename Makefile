# ------------------------------------------------------------------------------------
# AMPVer: A CIVL Model-Checking Verification Framework for Concurrent Data
# Structures
#
# This is the Makefile for AMPVer.
#
# This file includes rules to run all the experiments in the paper.
#
# The core experiments are divided into four categories: (hash) sets, lists,
# queues, and priority queues. Each category has multiple sets of limits, which
# are the parameters for the experiments passed to the AMPVer tool. The limits
# are defined in the variables HASHSET_LIMITS_n, LIST_LIMITS_n, QUEUE_LIMITS_n,
# and PQUEUE_LIMITS_n, where n is the number of the limit set. For example,
# HASHSET_LIMITS_1 is the limit set for the first and smallest core set
# experiment. To run all of the core experiments for a particular category and
# size, make the corresponding target.
#
# Below is a list of the targets for each category:
#
#  Sets: hashset_1 hashset_2 hashset_3 hashset_4
#  Lists: list_1 list_2 list_3 list_4
#  Queues: queue_1 queue_2 queue_3
#  Priority Queues: pqueue_1 pqueue_2 pqueue_3 pqueue_4
#
# For an example, to verify all lists using the second set of limits, one would
# run:
#
#  `make list_2`
#
# The output of each experiment is stored in the out/ directory. The summary
# output for each data structure is stored in a file named out/DS_n.out, where
# DS is the name of the data structure and n is the limit set. The outputs for
# each schedule are stored in separate files in under a directory named
# out/DS_n.dir, following the same naming convention. For example, the output
# for the CoarseHashSet data structure using the first set of limits is stored
# in out/CoarseHashSet_1.out, and the output for the first schedule is stored in
# out/CoarseHashSet_1.dir/schedule_1.out, along with the CIVL schedule
# configuration file as schedule_1.cvl. To run just one data structure and limit
# set combination, one can run the corresponding target. For example, to run
# just the CoarseHashSet data structure using the first set of limits, one would
# run:
#
#  `make out/CoarseHashSet_1.out`
#
# Some data structures have additional variants that can also be verified. The
# variant names are appended to the data structure name. The available variants
# are listed and described below. These variants are included in the core
# experiment targets described above.
#
# LockFreeList: LockFreeListOriginal
#  - Original: uses the original version of the LockFreeList data structure as
#    presented in the 1st edition of the book, which contains a bug in the
#    remove method corrected in later editions and the errata.
#
# FineGrainedHeap: FineGrainedHeapFair, FineGrainedHeapNoCycles
#  - Fair: uses a fair ReentrantLock instead of the original ReentrantLock. Also
#    passes the -fair flag to AMPVer, which indicates thread scheduling must be
#    fair.
#  - NoCycles: removes the -checkTermination flag from AMPVer, which means
#    AMPVer will not check for cycle violations.
#
# SkipQueue: SkipQueuePatched
#  - Patched: uses a patched version of the SkipQueue data structure that fixes
#    the cycle bug in FindAndMarkMin as described in the paper.
#
# In addition to the core experiments above, the Makefile also includes targets
# for running particular individual schedules of interest. These targets are
# described below. Currently, the only schedules of interest are for priority
# queues.
#
# PQUEUE_SCHED_1: a schedule that reveals the non-linearizable behavior in
#   SkipQueuePatched.
# PQUEUE_SCHED_2: a schedule that reveals the cycle violation in SkipQueue.
# PQUEUE_SCHED_3: same as PQUEUE_SCHED_2, but one fewer pre-add and one fewer
#   thread.
# PQUEUE_SCHED_4: a schedule of similar size to the above that reveals no
#   defect in SkipQueue or SkipQueuePatched.
#
# Individual schedules can be run using a target of the form out/DS_Sn, where DS
# is the name of the data structure, including any variants, and n is the number
# of the schedule. Note the use of the letter S before the schedule number to
# indicate that it is a schedule rule. The output of the schedule is stored in
# out/DS_Sn. For example, to run the first schedule for SkipQueuePatched, one
# would run:
#
#  `make out/SkipQueuePatched_S1`.
#
# All schedules for all priority queues can be run using the target
# pqueue_schedules:
#
#  `make pqueue_schedules`
#
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
