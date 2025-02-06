# Filename : pqueues.mk
# Author   : Josh Davis, Stephen F. Siegel
# Created  : 2024-11-25
# Modified : 2025-01-16
# Makefile for priority queues experiments.

ROOT = ..
include $(ROOT)/experiments/common.mk


## Common definitions

PQUEUES = pqueue_A pqueue_B pqueue_C pqueue_D pqueue_E

all: $(PQUEUES) pqueue_schedules

$(PQUEUES): pqueue_%: $(OUT_DIR)/SimpleLinear_%.out \
  $(OUT_DIR)/SimpleTree_%.out \
  $(OUT_DIR)/FineGrainedHeap_%.out \
  $(OUT_DIR)/FineGrainedHeapFair_%.out \
  $(OUT_DIR)/FineGrainedHeapNoCycles_%.out \
  $(OUT_DIR)/SkipQueueOriginal_%.out \
  $(OUT_DIR)/SkipQueueSC_%.out \
  $(OUT_DIR)/SkipQueueQC_%.out

pqueue_schedules: \
  $(addprefix $(OUT_DIR)/FineGrainedHeap_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/FineGrainedHeapFair_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/FineGrainedHeapNoCycles_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/SkipQueueOriginal_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/SkipQueueSC_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/SkipQueueQC_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf $(OUT_DIR)/FineGrainedHeap*.* $(OUT_DIR)/SkipQueue*.*


# For SimpleLinear, RANGE must be specified.  This must be at least 1
# more than the maximum score that will be encountered. For all other
# structures, RANGE is ignored.

# For SimpleTree, LOGRANGE must be specified.  Then range is computed
# to be 2^LOGRANGE.  RANGE is ignored.  For all other structures,
# LOGRANGE is ignored.

DRY ?= FALSE
DRYFLAG =
ifneq ($(DRY),FALSE)
	DRYFLAG = -dryrun
endif

PREEMPTION_BOUND ?= FALSE
PBFLAG =
ifneq ($(PREEMPTION_BOUND),FALSE)
	PBFLAG = -preemptionBound=2
endif

# New priority queue bound settings
PQUEUE_BOUND_A = -kind=pqueue -genericVals -distinctPriorities -addsDominate \
  $(BOUND_A) -DRANGE=2 -DLOGRANGE=1 $(DRYFLAG) $(PBFLAG)
PQUEUE_BOUND_B = -kind=pqueue -genericVals -distinctPriorities -addsDominate \
	$(BOUND_B) -DRANGE=3 -DLOGRANGE=2 $(DRYFLAG) $(PBFLAG)
PQUEUE_BOUND_C = -kind=pqueue -genericVals -distinctPriorities -addsDominate \
	$(BOUND_C) -DRANGE=3 -DLOGRANGE=2 $(DRYFLAG) $(PBFLAG)
PQUEUE_BOUND_D = -kind=pqueue -genericVals -distinctPriorities -addsDominate \
	$(BOUND_D) -DRANGE=4 -DLOGRANGE=2 $(DRYFLAG) $(PBFLAG)
PQUEUE_BOUND_E = -kind=pqueue -genericVals -distinctPriorities -addsDominate \
	$(BOUND_E) -DRANGE=5 -DLOGRANGE=3 $(DRYFLAG)
# E is always preemption bounded to 2

PQUEUE_INC = $(DRIVER_INC) $(PQUEUE_H) pqueues.mk
PQUEUE_SRC = $(DRIVER_SRC) $(PQUEUE_COL)
PQUEUE_DEP = $(PQUEUE_INC) $(PQUEUE_SRC)
PQUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_pqueue_1.cvl
PQUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_pqueue_2.cvl
PQUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_pqueue_3.cvl

# for quiescent consistency...
PQUEUEQ_SRC = $(DRIVERQ_SRC) $(PQUEUE_COL)
PQUEUEQ_DEP = $(PQUEUE_INC) $(PQUEUEQ_SRC)


## SimpleLinear.  Everything passes.

SL = $(PQUEUE_DIR)/SimpleLinear.cvl
SL_SRC = $(SL) $(ARRAYLIST_SRC) $(BIN_SRC)
SL_ALL = $(PQUEUEQ_SRC) $(SL_SRC) $(NBPQUEUE_OR)
SL_DEP = $(SL_ALL) $(PQUEUE_INC) $(ARRAYLIST_INC) $(BIN_INC)
SL_OUT = $(addprefix $(OUT_DIR)/SimpleLinear_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/SimpleLinear_1.out
$(SL_OUT): $(OUT_DIR)/SimpleLinear_%.out: $(COLLECT) $(SL_DEP)
	rm -rf $(OUT_DIR)/SimpleLinear_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -property=quiescent \
  -spec=nonblocking -checkTermination=true \
  -tmpDir=$(OUT_DIR)/SimpleLinear_$*.dir.tmp $(SL_SRC) \
  >$(OUT_DIR)/SimpleLinear_$*.out.tmp
	rm -rf $(OUT_DIR)/SimpleLinear_$*.dir
	mv $(OUT_DIR)/SimpleLinear_$*.out.tmp $(OUT_DIR)/SimpleLinear_$*.out
	mv $(OUT_DIR)/SimpleLinear_$*.dir.tmp $(OUT_DIR)/SimpleLinear_$*.dir

# Ex: make -f pqeueues.mk $(OUT_DIR)/SimpleLinear_S1.out
$(OUT_DIR)/SimpleLinear_S%.out: $(SL_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkTermination=true \
  $(SL_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/SimpleLinear_S$*.out


## SimpleTree.   There is a bug revealed in group 3 schedule 1830:
# Schedule[kind=PQUEUE, nthread=2, npreAdd=1, nstep=3]:
#   Preadds : [ ADD(0,1) ]
#   Thread 0: [ REMOVE REMOVE ]
#   Thread 1: [ ADD(1,0) ]

ST = $(PQUEUE_DIR)/SimpleTree.cvl
ST_SRC = $(ST) $(AI_SRC) $(ARRAYLIST_SRC) $(BIN_SRC)
ST_ALL = $(PQUEUEQ_SRC) $(ST_SRC) $(NBPQUEUE_OR)
ST_DEP = $(ST_ALL) $(PQUEUE_INC) $(AI_INC) $(ARRAYLIST_INC) $(BIN_INC)
ST_OUT = $(addprefix $(OUT_DIR)/SimpleTree_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/SimpleTree_1.out
$(ST_OUT): $(OUT_DIR)/SimpleTree_%.out: $(COLLECT) $(ST_DEP)
	rm -rf $(OUT_DIR)/SimpleTree_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -property=quiescent \
  -spec=nonblocking -checkTermination=true \
  -tmpDir=$(OUT_DIR)/SimpleTree_$*.dir.tmp $(ST_SRC) \
  >$(OUT_DIR)/SimpleTree_$*.out.tmp
	rm -rf $(OUT_DIR)/SimpleTree_$*.dir
	mv $(OUT_DIR)/SimpleTree_$*.out.tmp $(OUT_DIR)/SimpleTree_$*.out
	mv $(OUT_DIR)/SimpleTree_$*.dir.tmp $(OUT_DIR)/SimpleTree_$*.dir

# Ex: make -f pqeueues.mk $(OUT_DIR)/SimpleTree_S1.out
$(OUT_DIR)/SimpleTree_S%.out: $(ST_DEP) $(PQUEUE_SCHED_$*)
	-$(VERIFY) -checkTermination=true \
  $(ST_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/SimpleTree_S$*.out


## FineGrainedHeap

# We did 3 versions: (1) checking termination with no fairness constraint
# (what is point?), (2) not checking termination (or no checking for cycles),
# (3) using FairLocks and -fair?

# Version 1
# Regular locks, checking for cycles in state space.

FGH = $(PQUEUE_DIR)/FineGrainedHeap.cvl
FGH_SRC = $(FGH) $(LOCK_SRC)
FGH_ALL = $(PQUEUE_SRC) $(FGH_SRC) $(NBPQUEUE_OR)
FGH_DEP = $(FGH_ALL) $(PQUEUE_INC) $(LOCK_INC)
FGH_OUT = $(addprefix $(OUT_DIR)/FineGrainedHeap_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/FineGrainedHeap_1.out
$(FGH_OUT): $(OUT_DIR)/FineGrainedHeap_%.out: $(COLLECT) $(FGH_DEP)
	rm -rf $(OUT_DIR)/FineGrainedHeap_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -spec=nonblocking \
  -checkTermination=true \
  -tmpDir=$(OUT_DIR)/FineGrainedHeap_$*.dir.tmp $(FGH_SRC) \
  >$(OUT_DIR)/FineGrainedHeap_$*.out.tmp
	rm -rf $(OUT_DIR)/FineGrainedHeap_$*.dir
	mv $(OUT_DIR)/FineGrainedHeap_$*.out.tmp $(OUT_DIR)/FineGrainedHeap_$*.out
	mv $(OUT_DIR)/FineGrainedHeap_$*.dir.tmp $(OUT_DIR)/FineGrainedHeap_$*.dir

# Ex: make -f pqeueues.mk $(OUT_DIR)/FineGrainedHeap_S1.out
$(OUT_DIR)/FineGrainedHeap_S%.out: $(FGH_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(FGH_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/FineGrainedHeap_S$*.out


# Version 2
# Same as above, but not checking for cycles in sate space.

FGHNC_OUT = $(addprefix $(OUT_DIR)/FineGrainedHeapNoCycles_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/FineGrainedHeapNoCycles_1.out
$(FGHNC_OUT): $(OUT_DIR)/FineGrainedHeapNoCycles_%.out: $(COLLECT) $(FGH_DEP)
	rm -rf $(OUT_DIR)/FineGrainedHeapNoCycles_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -spec=nonblocking \
  -checkTermination=false \
  -tmpDir=$(OUT_DIR)/FineGrainedHeapNoCycles_$*.dir.tmp $(FGH_SRC) \
  >$(OUT_DIR)/FineGrainedHeapNoCycles_$*.out.tmp
	rm -rf $(OUT_DIR)/FineGrainedHeapNoCycles_$*.dir
	mv $(OUT_DIR)/FineGrainedHeapNoCycles_$*.out.tmp $(OUT_DIR)/FineGrainedHeapNoCycles_$*.out
	mv $(OUT_DIR)/FineGrainedHeapNoCycles_$*.dir.tmp $(OUT_DIR)/FineGrainedHeapNoCycles_$*.dir

# Ex: make -f pqueues.mk $(OUT_DIR)/FineGrainedHeapNoCycles_S1.out
$(OUT_DIR)/FineGrainedHeapNoCycles_S%.out: $(FGH_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=false \
  $(FGH_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/FineGrainedHeap_S$*.out


# Version 3
# Using fairness and fair locks.  Note -fair in AMPVer causes use of fairness
# and fair locks.

FGHFL_SRC = $(FGH) $(FAIRLOCK_SRC)
FGHFL_ALL = $(PQUEUE_SRC) $(FGHFL_SRC) $(NBPQUEUE_OR)
FGHFL_DEP = $(FGHFL_ALL) $(PQUEUE_INC) $(LOCK_INC)
FGHFL_OUT = $(addprefix $(OUT_DIR)/FineGrainedHeapFair_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/FineGrainedHeapFair_1.out
$(FGHFL_OUT): $(OUT_DIR)/FineGrainedHeapFair_%.out: $(COLLECT) $(FGHFL_DEP)
	rm -rf $(OUT_DIR)/FineGrainedHeapFair_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -fair -spec=nonblocking \
  -checkTermination=true \
  -tmpDir=$(OUT_DIR)/FineGrainedHeapFair_$*.dir.tmp $(FGHFL_SRC) \
  >$(OUT_DIR)/FineGrainedHeapFair_$*.out.tmp
	rm -rf $(OUT_DIR)/FineGrainedHeapFair_$*.dir
	mv $(OUT_DIR)/FineGrainedHeapFair_$*.out.tmp $(OUT_DIR)/FineGrainedHeapFair_$*.out
	mv $(OUT_DIR)/FineGrainedHeapFair_$*.dir.tmp $(OUT_DIR)/FineGrainedHeapFair_$*.dir

# Ex: make -f pqueues.mk $(OUT_DIR)/FineGrainedHeapFair_S1.out
$(OUT_DIR)/FineGrainedHeapFair_S%.out: $(FGHFL_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -fair \
  $(FGHFL_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/FineGrainedHeapFair_S$*.out


## SkipQueue

# Version 1: original, with defect.  There is a cycle in the state space,
# i.e., nontermination.  Found with a schedule ...
# begin schedule[id=1702 kind=PQUEUE]
#   presteps  = {ADD(0,1), ADD(1,0)}
#   thread[0] = {REMOVE()}
#   thread[1] = {REMOVE()}
# end schedule

SKIPQ = $(PQUEUE_DIR)/SkipQueue.cvl
SKIPQ_SRC = $(SKIPQ) $(AMR_SRC) $(AB_SRC)
SKIPQ_ALL = $(PQUEUE_SRC) $(SKIPQ_SRC) $(NBPQUEUE_OR)
SKIPQ_DEP = $(SKIPQ_ALL) $(PQUEUE_INC) $(AMR_INC) $(AB_INC)
SKIPQ_OUT = $(addprefix $(OUT_DIR)/SkipQueueOriginal_,$(addsuffix .out,A B C D E))

# Check quiescent consistency (the property is really irrelevant).
# Ex: make -f pqueues.mk $(OUT_DIR)/SkipQueueOriginal_3.out
# should reveal nontermination
$(SKIPQ_OUT): $(OUT_DIR)/SkipQueueOriginal_%.out: $(COLLECT) $(SKIPQ_DEP)
	rm -rf $(OUT_DIR)/SkipQueueOriginal_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) -spec=nonblocking -D_ORIGINAL_SKIPQUEUE \
  -checkTermination -property=quiescent -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/SkipQueueOriginal_$*.dir.tmp $(SKIPQ_SRC) \
  >$(OUT_DIR)/SkipQueueOriginal_$*.out.tmp
	rm -rf $(OUT_DIR)/SkipQueueOriginal_$*.dir
	mv $(OUT_DIR)/SkipQueueOriginal_$*.out.tmp $(OUT_DIR)/SkipQueueOriginal_$*.out
	mv $(OUT_DIR)/SkipQueueOriginal_$*.dir.tmp $(OUT_DIR)/SkipQueueOriginal_$*.dir

# Check sequential consistency
# Ex: make -f pqueues.mk $(OUT_DIR)/SkipQueueOriginal_S1.out
$(OUT_DIR)/SkipQueueOriginal_S%.out: $(SKIPQ_DEP) $(PQUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR \
  -D_ORIGINAL_SKIPQUEUE \
  $(SKIPQ_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/SkipQueueOriginal_S$*.out


# Version 2: the corrected version.  The correction appears in the
# errata.  This should satisfy quiescent consistency, but not
# sequential consistency or linearizability.  A violation to SC is
# found using schedule sched_pqueue_1.cvl: 3 threads, a pre-add
# (add(0,1)), thread 0 does 2 adds (add(1,0) and add(2,2)), threads 1
# and 2 each do one remove.

SKIPQ2SC_OUT = $(addprefix $(OUT_DIR)/SkipQueueSC_,$(addsuffix .out,A B C D E))

# Ex: make -f pqueues.mk $(OUT_DIR)/SkipQueueSC_1.out
$(SKIPQ2SC_OUT): $(OUT_DIR)/SkipQueueSC_%.out: $(COLLECT) $(SKIPQ_DEP)
	rm -rf $(OUT_DIR)/SkipQueueSC_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) \
  -spec=nonblocking -checkTermination -property=sc \
  -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/SkipQueueSC_$*.dir.tmp $(SKIPQ_SRC) \
  >$(OUT_DIR)/SkipQueueSC_$*.out.tmp
	rm -rf $(OUT_DIR)/SkipQueueSC_$*.dir
	mv $(OUT_DIR)/SkipQueueSC_$*.out.tmp $(OUT_DIR)/SkipQueueSC_$*.out
	mv $(OUT_DIR)/SkipQueueSC_$*.dir.tmp $(OUT_DIR)/SkipQueueSC_$*.dir

# make -f pqueues.mk $(OUT_DIR)/SkipQueueSC_S1.out
# should reveal SC violation, but may take a long time and a lot of
# memory (e.g., 2587s, 15GB on a MacBook Pro)
$(OUT_DIR)/SkipQueueSC_S%.out: $(SKIPQ_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -DNLINEAR -preemptionBound=2 \
  $(SKIPQ_ALL) $(PQUEUE_SCHED_$*) >$(OUT_DIR)/SkipQueueSC_S$*.out

# Same as above, but checking quiescent consistency.  All of these
# should pass (or run out of memory)...

SKIPQ2QC_OUT = $(addprefix $(OUT_DIR)/SkipQueueQC_,$(addsuffix .out,A B C D E))
SKIPQQ_ALL = $(PQUEUEQ_SRC) $(SKIPQ_SRC) $(NBPQUEUE_OR)
SKIPQQ_DEP = $(SKIPQQ_ALL) $(PQUEUE_INC) $(AMR_INC) $(AB_INC)

# Ex: make -f pqueues.mk $(OUT_DIR)/SkipQueueQC_1.out
$(SKIPQ2QC_OUT): $(OUT_DIR)/SkipQueueQC_%.out: $(COLLECT) $(SKIPQQ_DEP)
	rm -rf $(OUT_DIR)/SkipQueueQC_$*.dir.tmp
	-$(COLLECT) $(PQUEUE_BOUND_$*) \
  -spec=nonblocking -checkTermination -property=quiescent \
  -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/SkipQueueQC_$*.dir.tmp $(SKIPQ_SRC) \
  >$(OUT_DIR)/SkipQueueQC_$*.out.tmp
	rm -rf $(OUT_DIR)/SkipQueueQC_$*.dir
	mv $(OUT_DIR)/SkipQueueQC_$*.out.tmp $(OUT_DIR)/SkipQueueQC_$*.out
	mv $(OUT_DIR)/SkipQueueQC_$*.dir.tmp $(OUT_DIR)/SkipQueueQC_$*.dir

# Ex: make -f pqueues.mk $(OUT_DIR)/SkipQueueQC_S1.out
$(OUT_DIR)/SkipQueueQC_S%.out: $(SKIPQQ_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(SKIPQQ_ALL) $(PQUEUE_SCHED_$*) \
  >$(OUT_DIR)/SkipQueueQC_S$*.out
