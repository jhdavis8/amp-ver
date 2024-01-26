# ------------------------------------------------------------------------------------
# AMPVer:  A CIVL Model-Checking Verification Framework for Concurrent Data Structures
#
# This is the Makefile for AMPVer.
#
# This file includes rules to run all the experiments in the paper.
#
# The core experiments are divided into four categories: (hash) sets, lists, queues,
# and priority queues. Each category has multiple sets of limits, which are the
# parameters for the experiments passed to the AMPVer tool. The limits are defined in
# the variables HASHSET_LIMITS_n, LIST_LIMITS_n, QUEUE_LIMITS_n, and PQUEUE_LIMITS_n,
# where n is the number of the limit set. For example, HASHSET_LIMITS_1 is the limit
# set for the first and smallest core set experiment. To run all of the core
# experiments for a particular category and size, make the corresponding target.
#
# Below is a list of the targets for each category:
#
#  Sets: hashset_1 hashset_2 hashset_3 hashset_4
#  Lists: list_1 list_2 list_3 list_4
#  Queues: queue_1 queue_2 queue_3
#  Priority Queues: pqueue_1 pqueue_2 pqueue_3 pqueue_4
#
# For an example, to verify all lists using the second set of limits, one would run:
#
#  `make list_2`
#
# The output of each experiment is stored in the out/ directory. The summary output
# for each data structure is stored in a file named out/DS_n.out, where DS is the name
# of the data structure and n is the limit set. The outputs for each schedule are
# stored in separate files in under a directory named out/DS_n.dir, following the same
# naming convention. For example, the output for the CoarseHashSet data structure
# using the first set of limits is stored in out/CoarseHashSet_1.out, and the output
# for the first schedule is stored in out/CoarseHashSet_1.dir/schedule_1.out, along
# with the CIVL schedule configuration file as schedule_1.cvl. To run just one data
# structure and limit set combination, one can run the corresponding target. For
# example, to run just the CoarseHashSet data structure using the first set of limits,
# one would run:
#
#  `make out/CoarseHashSet_1.out`
#
# Some data structures have additional variants that can also be verified. The variant
# names are appended to the data structure name. The available variants are listed and
# described below. These variants are included in the core experiment targets
# described above.
#
# FineGrainedHeap: FineGrainedHeapFair, FineGrainedHeapNoCycles
#  - Fair: uses a fair ReentrantLock instead of the original ReentrantLock. Also
#    passes the -fair flag to AMPVer, which indicates thread scheduling must be
#    fair.
#  - NoCycles: removes the -checkTermination flag from AMPVer, which means AMPVer
#    will not check for cycle violations.
#
# SkipQueue: SkipQueuePatched
#  - Patched: uses a patched version of the SkipQueue data structure that fixes the
#    cycle bug in FindAndMarkMin as described in the paper.
#
# In addition to the core experiments above, the Makefile also includes targets for
# running particular individual schedules of interest. These targets are described
# below. Currently, the only schedules of interest are for priority queues.
#
# PQUEUE_SCHED_1: a schedule that reveals the non-linearizable behavior in
#   SkipQueuePatched.
# PQUEUE_SCHED_2: a schedule that reveals the cycle violation in SkipQueue.
# PQUEUE_SCHED_3: same as PQUEUE_SCHED_2, but one fewer pre-add and one fewer thread.
# PQUEUE_SCHED_4: a schedule of similar size to the above that reveals no defect in
#   SkipQueue or SkipQueuePatched.
#
# Individual schedules can be run using a target of the form out/DS_Sn, where DS is
# the name of the data structure, including any variants, and n is the number of the
# schedule. Note the use of the letter S before the schedule number to indicate that
# it is a schedule rule. The output of the schedule is stored in out/DS_Sn. For
# example, to run the first schedule for SkipQueuePatched, one would run:
#
#  `make out/SkipQueuePatched_S1`.
#
# All schedules for all priority queues can be run using the target pqueue_schedules:
#
#  `make pqueue_schedules`
#
# ------------------------------------------------------------------------------------


ROOT = .
include $(ROOT)/common.mk

all: $(MAIN_CLASS)

SOURCES = $(JROOT)/src/ampver/module-info.java \
    $(JSRC)/AMPVer.java \
    $(JSRC)/Step.java \
    $(JSRC)/Schedule.java \
    $(JSRC)/SetScheduleIterator.java \
    $(JSRC)/QueueScheduleIterator.java \
    $(JSRC)/PQScheduleIterator.java \
    $(JSRC)/AVUtil.java

$(MAIN_CLASS): $(SOURCES)
	$(JAVAC) -d $(JROOT)/bin/ampver \
          -p $(CIVL_ROOT)/mods/dev.civl.mc/bin $(SOURCES)


##################################  Sets  ##################################

HASHSET_LIMITS_1  = -kind=set -hashKind=ident -valueBound=2 -nthread=1..2 \
     -nstep=1..2 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_1ND = -kind=set -hashKind=nd -hashRangeBound=2 -hashDomainBound=2 -valueBound=2 \
     -nthread=1..2 -nstep=1..2 -npreAdd=0 -threadSym -checkTermination \
     -ncore=$(NCORE)

HASHSET_LIMITS_1.5ND = -kind=set -hashKind=nd -hashRangeBound=2 -hashDomainBound=3 -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)\

HASHSET_LIMITS_2  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_2ND = -kind=set -hashKind=nd -hashRangeBound=4 -hashDomainBound=3 -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)\

HASHSET_LIMITS_3  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=1..3 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_4  = -kind=set -hashKind=ident -valueBound=3 -nthread=3 \
     -nstep=4 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASH_COMMON_DEP = $(DRIVER_INC) $(DRIVER_SRC) $(DRIVER_SET) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC) $(ARRAYLIST_INC) $(ARRAYLIST_SRC) Makefile
HASH_COMMON_SRC = $(DRIVER_SRC) $(DRIVER_SET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)

SET1 = $(SCHEDULE_DIR)/sched_set_1.cvl
SET2 = $(SCHEDULE_DIR)/sched_set_2.cvl

hashset_1 hashset_2 hashset_3 hashset_4 hashset_1ND hashset_1.5ND hashset_2ND: hashset_%: out/CoarseHashSet_%.out \
  out/StripedHashSet_%.out out/StripedCuckooHashSet_%.out

# CoarseHashSet

COARSEHASHSET = $(SET_DIR)/CoarseHashSet.cvl
COARSEHASHSET_DEP = $(HASH_COMMON_DEP) $(COARSEHASHSET)
COARSEHASHSET_SRC =  $(HASH_COMMON_SRC) $(COARSEHASHSET)
CoarseHashSet_Outs = $(addsuffix .out,$(addprefix out/CoarseHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(CoarseHashSet_Outs): out/CoarseHashSet_%.out: $(MAIN_CLASS) $(COARSEHASHSET_DEP)
	rm -rf $(TMP)/CoarseHashSet_$*.dir.tmp
	rm -rf out/CoarseHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/CoarseHashSet_$*.dir.tmp \
          $(COARSEHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/CoarseHashSet_$*.out.tmp
	mv $(TMP)/CoarseHashSet_$*.out.tmp out/CoarseHashSet_$*.out
	mv $(TMP)/CoarseHashSet_$*.dir.tmp out/CoarseHashSet_$*.dir

# StripedHashSet

STRIPEDHASHSET = $(SET_DIR)/StripedHashSet.cvl
STRIPEDHASHSET_DEP = $(HASH_COMMON_DEP) $(STRIPEDHASHSET)
STRIPEDHASHSET_SRC =  $(HASH_COMMON_SRC) $(STRIPEDHASHSET)
StripedHashSet_Outs = $(addsuffix .out,$(addprefix out/StripedHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(StripedHashSet_Outs): out/StripedHashSet_%.out: $(MAIN_CLASS) $(STRIPEDHASHSET_DEP)
	rm -rf $(TMP)/StripedHashSet_$*.dir.tmp
	rm -rf out/StripedHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/StripedHashSet_$*.dir.tmp \
          $(STRIPEDHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/StripedHashSet_$*.out.tmp
	mv $(TMP)/StripedHashSet_$*.out.tmp out/StripedHashSet_$*.out
	mv $(TMP)/StripedHashSet_$*.dir.tmp out/StripedHashSet_$*.dir

# StripedCuckooHashSet

STRIPEDCUCKOOHASHSET = $(SET_DIR)/StripedCuckooHashSet.cvl
STRIPEDCUCKOOHASHSET_DEP = $(HASH_COMMON_DEP) $(STRIPEDCUCKOOHASHSET)
STRIPEDCUCKOOHASHSET_SRC =  $(HASH_COMMON_SRC) $(STRIPEDCUCKOOHASHSET)
StripedCuckooHashSet_Outs = $(addsuffix .out,$(addprefix out/StripedCuckooHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(StripedCuckooHashSet_Outs): out/StripedCuckooHashSet_%.out: $(MAIN_CLASS) $(STRIPEDCUCKOOHASHSET_DEP)
	rm -rf $(TMP)/StripedCuckooHashSet_$*.dir.tmp
	rm -rf out/StripedCuckooHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/StripedCuckooHashSet_$*.dir.tmp \
          $(STRIPEDCUCKOOHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/StripedCuckooHashSet_$*.out.tmp
	mv $(TMP)/StripedCuckooHashSet_$*.out.tmp out/StripedCuckooHashSet_$*.out
	mv $(TMP)/StripedCuckooHashSet_$*.dir.tmp out/StripedCuckooHashSet_$*.dir

out/StripedCuckooHashSet_S%: $(STRIPEDCUCKOOHASHSET_DEP) $(SET$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DHASH_ND -inputVAL_B=3 \
          -inputHASH_B=2 $(STRIPEDCUCKOOHASHSET_SRC) $(SET$*) \
					>out/StripedCuckooHashSet_S$*

# other sets...

##################################  Lists  #################################

# 63 schedules
LIST_LIMITS_1  = -kind=set -hashKind=ident -valueBound=2 -nthread=1..2 \
     -nstep=1..2 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

# 1758 schedules
LIST_LIMITS_2 = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

# 5274 schedules: approx 15 minutes on Mac
LIST_LIMITS_3  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=1..3 -threadSym -checkTermination -ncore=$(NCORE)

# 3645 schedules: estimate 5 hours on Mac
LIST_LIMITS_4  = -kind=set -hashKind=ident -valueBound=3 -nthread=3 \
     -nstep=4 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

# Not used...

# 21,846 schedules
#LIST_LIMITS_3  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
#     -nstep=1..4 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

# # 1365 schedules
# LIST_LIMITS_4  = -kind=set -hashKind=ident -valueBound=4 -nthread=4 \
#      -nstep=4 -npreAdd=0 -threadSym -checkTermination -ncore=2
# # about 3 minutes each with 2 cores, or 34 hours

LIST_COMMON_DEP = $(DRIVER_INC) $(DRIVER_SRC) $(DRIVER_SET) Makefile
LIST_COMMON_SRC = $(DRIVER_SRC) $(DRIVER_SET)

list_1 list_2 list_3 list_4: list_%: out/CoarseList_%.out \
  out/FineList_%.out out/OptimisticList_%.out out/LazyList_%.out \
  out/LockFreeList_%.out

# CoarseList

COARSELIST = $(LIST_DIR)/CoarseList.cvl
COARSELIST_DEP = $(LIST_COMMON_DEP) $(COARSELIST) $(HASH_INC) $(HASH_SRC) \
     $(LOCK_INC) $(LOCK_SRC)
COARSELIST_SRC = $(LIST_COMMON_SRC) $(COARSELIST) $(HASH_SRC) $(LOCK_SRC)
CoarseList_Outs = $(addsuffix .out,$(addprefix out/CoarseList_,1 2 3 4))

# fails because requires hashCode is injective...
CoarseList1: $(COARSELIST_DEP) $(SET1)
	$(VERIFY) -checkMemoryLeak=false -DHASH_ND -inputVAL_B=3 \
          -inputHASH_B=3 $(COARSELIST_SRC) $(SET1)
CoarseList2: $(COARSELIST_DEP) $(SET1)
	$(VERIFY) -checkMemoryLeak=false $(COARSELIST_SRC) $(SET1)

$(CoarseList_Outs): out/CoarseList_%.out: $(MAIN_CLASS) $(COARSELIST_DEP)
	rm -rf $(TMP)/CoarseList_$*.dir.tmp
	rm -rf out/CoarseList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/CoarseList_$*.dir.tmp \
          $(COARSELIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/CoarseList_$*.out.tmp
	mv $(TMP)/CoarseList_$*.out.tmp out/CoarseList_$*.out
	mv $(TMP)/CoarseList_$*.dir.tmp out/CoarseList_$*.dir

# FineList 

FINELIST = $(LIST_DIR)/FineList.cvl
FINELIST_DEP =  $(LIST_COMMON_DEP) $(FINELIST) $(HASH_INC) $(HASH_SRC) \
     $(LOCK_INC) $(LOCK_SRC)
FineList_Outs = $(addsuffix .out,$(addprefix out/FineList_,1 2 3 4))

$(FineList_Outs): out/FineList_%.out: $(MAIN_CLASS) $(FINELIST_DEP)
	rm -rf $(TMP)/FineList_$*.dir.tmp
	rm -rf out/FineList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/FineList_$*.dir.tmp \
          $(FINELIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/FineList_$*.out.tmp
	mv $(TMP)/FineList_$*.out.tmp out/FineList_$*.out
	mv $(TMP)/FineList_$*.dir.tmp out/FineList_$*.dir

# OptimisticList

OPTIMISTICLIST = $(LIST_DIR)/OptimisticList.cvl
OPTIMISTICLIST_DEP = $(LIST_COMMON_DEP) $(OPTIMISTICLIST) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC)
OptimisticList_Outs = $(addsuffix .out,$(addprefix out/OptimisticList_,1 2 3 4))

$(OptimisticList_Outs): out/OptimisticList_%.out: $(MAIN_CLASS) $(OPTIMISTICLIST_DEP)
	rm -rf $(TMP)/OptimisticList_$*.dir.tmp
	rm -rf out/OptimisticList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/OptimisticList_$*.dir.tmp \
          -checkMemoryLeak=false \
          $(OPTIMISTICLIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/OptimisticList_$*.out.tmp
	mv $(TMP)/OptimisticList_$*.out.tmp out/OptimisticList_$*.out
	mv $(TMP)/OptimisticList_$*.dir.tmp out/OptimisticList_$*.dir

# LazyList

LAZYLIST = $(LIST_DIR)/LazyList.cvl
LAZYLIST_DEP = $(LIST_COMMON_DEP) $(LAZYLIST) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC)
LazyList_Outs = $(addsuffix .out,$(addprefix out/LazyList_,1 2 3 4))

$(LazyList_Outs): out/LazyList_%.out: $(MAIN_CLASS) $(LAZYLIST_DEP)
	rm -rf $(TMP)/LazyList_$*.dir.tmp
	rm -rf out/LazyList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -checkMemoryLeak=false \
          -tmpDir=$(TMP)/LazyList_$*.dir.tmp \
          $(LAZYLIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/LazyList_$*.out.tmp
	mv $(TMP)/LazyList_$*.out.tmp out/LazyList_$*.out
	mv $(TMP)/LazyList_$*.dir.tmp out/LazyList_$*.dir

# LockFreeList (Nonblocking list)

LOCKFREELIST = $(LIST_DIR)/LockFreeList.cvl
LOCKFREELIST_DEP = $(LIST_COMMON_DEP) $(LOCKFREELIST) \
     $(HASH_INC) $(HASH_SRC) $(AMR_INC) $(AMR_SRC)
LockFreeList_Outs = $(addsuffix .out,$(addprefix out/LockFreeList_,1 2 3 4))

$(LockFreeList_Outs): out/LockFreeList_%.out: $(MAIN_CLASS) $(LOCKFREELIST_DEP)
	rm -rf $(TMP)/LockFreeList_$*.dir.tmp
	rm -rf out/LockFreeList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/LockFreeList_$*.dir.tmp \
          -checkMemoryLeak=false \
          $(LOCKFREELIST) $(HASH_SRC) $(AMR_SRC) \
          >$(TMP)/LockFreeList_$*.out.tmp
	mv $(TMP)/LockFreeList_$*.out.tmp out/LockFreeList_$*.out
	mv $(TMP)/LockFreeList_$*.dir.tmp out/LockFreeList_$*.dir


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

queue_1 queue_2 queue_3: queue_%: out/UnboundedQueue_%.out \
  out/LockFreeQueue_%.out

QUEUE1 = $(SCHEDULE_DIR)/sched_queue_1.cvl
QUEUE_COMMON_DEP = $(DRIVER_INC) $(DRIVER_SRC) $(DRIVER_QUEUE) Makefile
QUEUE_COMMON_SRC = $(DRIVER_SRC) $(DRIVER_QUEUE)

# UnboundedQueue

UNBOUNDEDQUEUE = $(QUEUE_DIR)/UnboundedQueue.cvl
UNBOUNDEDQUEUE_DEP = $(QUEUE_COMMON_DEP) $(UNBOUNDEDQUEUE) \
                     $(LOCK_INC) $(LOCK_SRC)
UNBOUNDEDQUEUE_SRC = $(QUEUE_COMMON_SRC) $(UNBOUNDEDQUEUE) $(LOCK_SRC)
UnboundedQueue_Outs = out/UnboundedQueue_1.out out/UnboundedQueue_2.out \
                      out/UnboundedQueue_3.out

# a small specific schedule test...
UnboundedQueue1: $(UNBOUNDEDQUEUE_DEP) $(QUEUE1)
	$(VERIFY) $(UNBOUNDEDQUEUE_SRC) $(QUEUE1)

$(UnboundedQueue_Outs): out/UnboundedQueue_%.out: $(MAIN_CLASS) $(UNBOUNDEDQUEUE_DEP)
	rm -rf $(TMP)/UnboundedQueue_$*.dir.tmp
	rm -rf out/UnboundedQueue_$*.dir
	-$(AMPVER) $(QUEUE_LIMITS_$*) -tmpDir=$(TMP)/UnboundedQueue_$*.dir.tmp \
          -checkMemoryLeak=false $(UNBOUNDEDQUEUE) $(LOCK_SRC) \
          >out/UnboundedQueue_$*.out.tmp
	mv $(TMP)/UnboundedQueue_$*.out.tmp out/UnboundedQueue_$*.out
	mv $(TMP)/UnboundedQueue_$*.dir.tmp out/UnboundedQueue_$*.dir


# LockFreeQueue

LOCKFREEQUEUE = $(QUEUE_DIR)/LockFreeQueue.cvl
LOCKFREEQUEUE_DEP = $(QUEUE_COMMON_DEP) $(LOCKFREEQUEUE) $(AR_INC) $(AR_SRC)
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


# Other queues...




#############################  Priority Queues  ############################

PQUEUE_LIMITS_1 = -kind=pqueue -genericVals -threadSym -nthread=1..2 \
     -nstep=1..2 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_2 = -kind=pqueue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_3 = -kind=pqueue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..3 -npreAdd=1..3 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_4 = -kind=pqueue -genericVals -threadSym -nthread=3 \
     -nstep=4 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_5 = -kind=pqueue -genericVals -threadSym -nthread=3 \
     -nstep=4 -npreAdd=1 -distinctPriorities -addsDominate -ncore=1 -dryrun

PQUEUE_COMMON_DEP = $(DRIVER_INC) $(DRIVER_SRC) $(DRIVER_PQUEUE) Makefile
PQUEUE_COMMON_SRC = $(DRIVER_SRC) $(DRIVER_PQUEUE)

PQUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_pqueue_1.cvl
PQUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_pqueue_2.cvl
PQUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_pqueue_3.cvl
PQUEUE_SCHED_4 = $(SCHEDULE_DIR)/sched_pqueue_4.cvl

pqueue_1 pqueue_2 pqueue_3 pqueue_4: pqueue_%: out/FineGrainedHeap_%.out \
	out/FineGrainedHeapFair_%.out out/FineGrainedHeapNoCycles_%.out \
	out/SkipQueue_%.out out/SkipQueuePatched_%.out

pqueue_schedules: out/FineGrainedHeap_S1 out/FineGrainedHeap_S2 out/FineGrainedHeap_S3 out/FineGrainedHeap_S4 \
	out/FineGrainedHeapFair_S1 out/FineGrainedHeapFair_S2 out/FineGrainedHeapFair_S3 out/FineGrainedHeapFair_S4 \
	out/FineGrainedHeapNoCycles_S1 out/FineGrainedHeapNoCycles_S2 out/FineGrainedHeapNoCycles_S3 out/FineGrainedHeapNoCycles_S4 \
	out/SkipQueue_S1 out/SkipQueue_S2 out/SkipQueue_S3 out/SkipQueue_S4 \
	out/SkipQueuePatched_S1 out/SkipQueuePatched_S2 out/SkipQueuePatched_S3 out/SkipQueuePatched_S4

# FineGrainedHeap

FINEGRAINEDHEAP = $(PQUEUE_DIR)/FineGrainedHeap.cvl
FINEGRAINEDHEAP_DEP = $(PQUEUE_COMMON_DEP) $(FINEGRAINEDHEAP) $(LOCK_INC) $(LOCK_SRC)
FINEGRAINEDHEAP_SRC =  $(PQUEUE_COMMON_SRC) $(FINEGRAINEDHEAP) $(LOCK_SRC)
FINEGRAINEDHEAPFAIR_DEP = $(PQUEUE_COMMON_DEP) $(FINEGRAINEDHEAP) $(LOCK_INC) $(FAIRLOCK_SRC)
FINEGRAINEDHEAPFAIR_SRC =  $(PQUEUE_COMMON_SRC) $(FINEGRAINEDHEAP) $(FAIRLOCK_SRC)
FineGrainedHeap_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeap_,1 2 3 4))
FineGrainedHeapFair_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeapFair_,1 2 3 4))
FineGrainedHeapNoCycles_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeapNoCycles_,1 2 3 4))

$(FineGrainedHeap_Outs): out/FineGrainedHeap_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP)
	rm -rf $(TMP)/FineGrainedHeap_$*.dir.tmp
	rm -rf out/FineGrainedHeap_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -fair -checkTermination -tmpDir=$(TMP)/FineGrainedHeap_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(LOCK_SRC) \
          >$(TMP)/FineGrainedHeap_$*.out.tmp
	mv $(TMP)/FineGrainedHeap_$*.out.tmp out/FineGrainedHeap_$*.out
	mv $(TMP)/FineGrainedHeap_$*.dir.tmp out/FineGrainedHeap_$*.dir

$(FineGrainedHeapNoCycles_Outs): out/FineGrainedHeapNoCycles_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP)
	rm -rf $(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp
	rm -rf out/FineGrainedHeapNoCycles_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -tmpDir=$(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(LOCK_SRC) \
          >$(TMP)/FineGrainedHeapNoCycles_$*.out.tmp
	mv $(TMP)/FineGrainedHeapNoCycles_$*.out.tmp out/FineGrainedHeapNoCycles_$*.out
	mv $(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp out/FineGrainedHeapNoCycles_$*.dir

$(FineGrainedHeapFair_Outs): out/FineGrainedHeapFair_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP) $(FAIRLOCK_SRC)
	rm -rf $(TMP)/FineGrainedHeapFair_$*.dir.tmp
	rm -rf out/FineGrainedHeapFair_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -fair -checkTermination -tmpDir=$(TMP)/FineGrainedHeapFair_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(FAIRLOCK_SRC) \
          >$(TMP)/FineGrainedHeapFair_$*.out.tmp
	mv $(TMP)/FineGrainedHeapFair_$*.out.tmp out/FineGrainedHeapFair_$*.out
	mv $(TMP)/FineGrainedHeapFair_$*.dir.tmp out/FineGrainedHeapFair_$*.dir

out/FineGrainedHeap_S%: $(FINEGRAINEDHEAP_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(FINEGRAINEDHEAP_SRC) $(PQUEUE_SCHED_$*) \
          >out/FineGrainedHeap_S$*

out/FineGrainedHeapNoCycles_S%: $(FINEGRAINEDHEAP_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false $(FINEGRAINEDHEAP_SRC) $(PQUEUE_SCHED_$*) \
          >out/FineGrainedHeapNoCycles_S$*

out/FineGrainedHeapFair_S%: $(FINEGRAINEDHEAPFAIR_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -fair $(FINEGRAINEDHEAPFAIR_SRC) $(PQUEUE_SCHED_$*) \
					>out/FineGrainedHeapFair_S$*

# SkipQueue

SKIPQUEUE = $(PQUEUE_DIR)/SkipQueue.cvl
SKIPQUEUE_DEP = $(PQUEUE_COMMON_DEP) $(SKIPQUEUE) $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC)
SKIPQUEUE_SRC =  $(PQUEUE_COMMON_SRC) $(SKIPQUEUE) $(AMR_SRC) $(AB_SRC)
SkipQueue_Outs = $(addsuffix .out,$(addprefix out/SkipQueue_,1 2 3 4))
SkipQueuePatched_Outs = $(addsuffix .out,$(addprefix out/SkipQueuePatched_,1 2 3 4 5))

$(SkipQueue_Outs): out/SkipQueue_%.out: $(MAIN_CLASS) $(SKIPQUEUE_DEP)
	rm -rf $(TMP)/SkipQueue_$*.dir.tmp
	rm -rf out/SkipQueue_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -checkTermination -linear=false -checkMemoryLeak=false \
          -tmpDir=$(TMP)/SkipQueue_$*.dir.tmp \
          $(SKIPQUEUE) $(AMR_SRC) $(AB_SRC) \
          >$(TMP)/SkipQueue_$*.out.tmp
	mv $(TMP)/SkipQueue_$*.out.tmp out/SkipQueue_$*.out
	mv $(TMP)/SkipQueue_$*.dir.tmp out/SkipQueue_$*.dir

SKIPQUEUEPATCHED = $(PQUEUE_DIR)/SkipQueuePatched.cvl
SKIPQUEUEPATCHED_DEP = $(PQUEUE_COMMON_DEP) $(SKIPQUEUEPATCHED) $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC)
SKIPQUEUEPATCHED_SRC =  $(PQUEUE_COMMON_SRC) $(SKIPQUEUEPATCHED) $(AMR_SRC) $(AB_SRC)

$(SkipQueuePatched_Outs): out/SkipQueuePatched_%.out: $(MAIN_CLASS) $(SKIPQUEUEPATCHED_DEP)
	rm -rf $(TMP)/SkipQueuePatched_$*.dir.tmp
	rm -rf out/SkipQueuePatched_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -checkTermination -linear=false -checkMemoryLeak=false \
	        -tmpDir=$(TMP)/SkipQueuePatched_$*.dir.tmp \
          $(SKIPQUEUEPATCHED) $(AMR_SRC) $(AB_SRC) \
          >$(TMP)/SkipQueuePatched_$*.out.tmp
	mv $(TMP)/SkipQueuePatched_$*.out.tmp out/SkipQueuePatched_$*.out
	mv $(TMP)/SkipQueuePatched_$*.dir.tmp out/SkipQueuePatched_$*.dir

out/SkipQueue_S%: $(SKIPQUEUE_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR $(SKIPQUEUE_SRC) $(PQUEUE_SCHED_$*) \
					>out/SkipQueue_S$*

out/SkipQueuePatched_S%: $(SKIPQUEUEPATCHED_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR $(SKIPQUEUEPATCHED_SRC) $(PQUEUE_SCHED_$*) \
					>out/SkipQueuePatched_S$*

# other priority queues...



##################################  Other  #################################

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

.PHONY: all test CoarseList2 UnboundedQueue1 SkipQueue1 SkipQueue2 FineGrainedHeap1 \
  list_0 list_1 list_2
