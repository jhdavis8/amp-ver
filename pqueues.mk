# Filename : pqueues.mk
# Author   : Josh Davis
# Created  :
# Modified : 2024-12-23
# Makefile for priority queues experiments.
ROOT = .
include $(ROOT)/common.mk


## Common definitions

PQUEUES = pqueue_1 pqueue_2 pqueue_3 pqueue_4

all: $(PQUEUES) pqueue_schedules

$(PQUEUES): pqueue_%: out/FineGrainedHeap_%.out \
  out/FineGrainedHeapFair_%.out out/FineGrainedHeapNoCycles_%.out \
  out/SkipQueue_%.out out/SkipQueuePatched_%.out

pqueue_schedules: \
  $(addprefix out/FineGrainedHeap_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/FineGrainedHeapFair_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/FineGrainedHeapNoCycles_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/SkipQueue_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/SkipQueuePatched_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf out/FineGrainedHeap*.* out/SkipQueue*.*

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

PQUEUE_INC = $(DRIVER_INC) $(PQUEUE_H) pqueues.mk
PQUEUE_SRC = $(DRIVER_SRC) $(PQUEUE_COL)
PQUEUE_DEP = $(PQUEUE_INC) $(PQUEUE_SRC)
PQUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_pqueue_1.cvl
PQUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_pqueue_2.cvl
PQUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_pqueue_3.cvl


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
FGH_OUT = $(addprefix out/FineGrainedHeap_,$(addsuffix .out,1 2 3 4))

# Ex: make -f pqueues.mk out/FineGrainedHeap_1.out
$(FGH_OUT): out/FineGrainedHeap_%.out: $(MAIN_CLASS) $(FGH_DEP)
	rm -rf out/FineGrainedHeap_$*.dir.tmp
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -spec=nonblocking \
  -checkTermination=true \
  -tmpDir=out/FineGrainedHeap_$*.dir.tmp $(FGH_SRC) \
  >out/FineGrainedHeap_$*.out.tmp
	rm -rf out/FineGrainedHeap_$*.dir
	mv out/FineGrainedHeap_$*.out.tmp out/FineGrainedHeap_$*.out
	mv out/FineGrainedHeap_$*.dir.tmp out/FineGrainedHeap_$*.dir

# Ex: make -f pqeueues.mk out/FineGrainedHeap_S1.out
out/FineGrainedHeap_S%.out: $(FGH_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(FGH_ALL) $(PQUEUE_SCHED_$*) >out/FineGrainedHeap_S$*.out


# Version 2
# Same as above, but not checking for cycles in sate space.

FGHNC_OUT = $(addprefix out/FineGrainedHeapNoCycles_,$(addsuffix .out,1 2 3 4))

# Ex: make -f pqueues.mk out/FineGrainedHeapNoCycles_1.out
$(FGHNC_OUT): out/FineGrainedHeapNoCycles_%.out: $(MAIN_CLASS) $(FGH_DEP)
	rm -rf out/FineGrainedHeapNoCycles_$*.dir.tmp
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -spec=nonblocking \
  -checkTermination=false \
  -tmpDir=out/FineGrainedHeapNoCycles_$*.dir.tmp $(FGH_SRC) \
  >out/FineGrainedHeapNoCycles_$*.out.tmp
	rm -rf out/FineGrainedHeapNoCycles_$*.dir
	mv out/FineGrainedHeapNoCycles_$*.out.tmp out/FineGrainedHeapNoCycles_$*.out
	mv out/FineGrainedHeapNoCycles_$*.dir.tmp out/FineGrainedHeapNoCycles_$*.dir

# Ex: make -f pqueues.mk out/FineGrainedHeapNoCycles_S1.out
out/FineGrainedHeapNoCycles_S%.out: $(FGH_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=false \
  $(FGH_ALL) $(PQUEUE_SCHED_$*) >out/FineGrainedHeap_S$*.out



# Version 3
# Using fairness and fair locks.  Note -fair in AMPVer causes use of fairness
# and fair locks.

FGHFL_SRC = $(FGH) $(FAIRLOCK_SRC)
FGHFL_ALL = $(PQUEUE_SRC) $(FGHFL_SRC) $(NBPQUEUE_OR)
FGHFL_DEP = $(FGHFL_ALL) $(PQUEUE_INC) $(LOCK_INC)
FGHFL_OUT = $(addprefix out/FineGrainedHeapFair_,$(addsuffix .out,1 2 3 4))

# Ex: make -f pqueues.mk out/FineGrainedHeapFair_1.out
$(FGHFL_OUT): out/FineGrainedHeapFair_%.out: $(MAIN_CLASS) $(FGHFL_DEP)
	rm -rf out/FineGrainedHeapFair_$*.dir.tmp
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -fair -spec=nonblocking \
  -checkTermination=true \
  -tmpDir=out/FineGrainedHeapFair_$*.dir.tmp $(FGHFL_SRC) \
  >out/FineGrainedHeapFair_$*.out.tmp
	rm -rf out/FineGrainedHeapFair_$*.dir
	mv out/FineGrainedHeapFair_$*.out.tmp out/FineGrainedHeapFair_$*.out
	mv out/FineGrainedHeapFair_$*.dir.tmp out/FineGrainedHeapFair_$*.dir

# Ex: make -f pqueues.mk out/FineGrainedHeapFair_S1.out
out/FineGrainedHeapFair_S%.out: $(FGHFL_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -fair \
  $(FGHFL_ALL) $(PQUEUE_SCHED_$*) >out/FineGrainedHeapFair_S$*.out


## SkipQueue

# Version 1: original, with defect

SKIPQ = $(PQUEUE_DIR)/SkipQueue.cvl
SKIPQ_SRC = $(SKIPQ) $(AMR_SRC) $(AB_SRC)
SKIPQ_ALL = $(PQUEUE_SRC) $(SKIPQ_SRC) $(NBPQUEUE_OR)
SKIPQ_DEP = $(SKIPQ_ALL) $(PQUEUE_INC) $(AMR_INC) $(AB_INC)
SKIPQ_OUT = $(addprefix out/SkipQueue_,$(addsuffix .out,1 2 3 4))

# Ex: make -f pqueues.mk out/SkipQueue_1.out
$(SKIPQ_OUT): out/SkipQueue_%.out: $(MAIN_CLASS) $(SKIPQ_DEP)
	rm -rf out/SkipQueue_$*.dir.tmp
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -spec=nonblocking \
  -checkTermination -linear=false -checkMemoryLeak=false \
  -tmpDir=out/SkipQueue_$*.dir.tmp $(SKIPQ_SRC) \
  >out/SkipQueue_$*.out.tmp
	rm -rf out/SkipQueue_$*.dir
	mv out/SkipQueue_$*.out.tmp out/SkipQueue_$*.out
	mv out/SkipQueue_$*.dir.tmp out/SkipQueue_$*.dir

# Ex: make -f pqueues.mk out/SkipQueue_S1.out
out/SkipQueue_S%.out: $(SKIPQ_DEP) $(PQUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR \
  $(SKIPQ_ALL) $(PQUEUE_SCHED_$*) >out/SkipQueue_S$*.out


# Version 2: patched, correcting the defect

SKIPQP = $(PQUEUE_DIR)/SkipQueuePatched.cvl
SKIPQP_SRC = $(SKIPQP) $(AMR_SRC) $(AB_SRC)
SKIPQP_ALL = $(PQUEUE_SRC) $(SKIPQP_SRC) $(NBPQUEUE_OR)
SKIPQP_DEP = $(SKIPQP_ALL) $(PQUEUE_INC) $(AMR_INC) $(AB_INC)
SKIPQP_OUT = $(addprefix out/SkipQueuePatched_,$(addsuffix .out,1 2 3 4 5))

# Ex: make -f pqueues.mk out/SkipQueuePatched_1.out
$(SKIPQP_OUT): out/SkipQueuePatched_%.out: $(MAIN_CLASS) $(SKIPQP_DEP)
	rm -rf out/SkipQueuePatched_$*.dir.tmp
	$(AMPVER) $(PQUEUE_LIMITS_$*) -spec=nonblocking \
  -checkTermination -linear=false -checkMemoryLeak=false \
  -tmpDir=out/SkipQueuePatched_$*.dir.tmp $(SKIPQP_SRC) \
  >out/SkipQueuePatched_$*.out.tmp
	rm -rf out/SkipQueuePatched_$*.dir
	mv out/SkipQueuePatched_$*.out.tmp out/SkipQueuePatched_$*.out
	mv out/SkipQueuePatched_$*.dir.tmp out/SkipQueuePatched_$*.dir

# Ex: make -f pqueues.mk out/SkipQueuePatched_S1.out
out/SkipQueuePatched_S%.out: $(SKIPQP_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR \
  $(SKIPQP_ALL) $(PQUEUE_SCHED_$*) >out/SkipQueuePatched_S$*.out
