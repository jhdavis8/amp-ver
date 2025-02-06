# Filename : hashsets.mk
# Author   : Josh Davis
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for hash sets experiments.

ROOT = ..
include $(ROOT)/experiments/common.mk


## Common definitions

HASHSETS = hashset_A hashset_B hashset_C hashset_D hashset_E

all: $(HASHSETS) hashset_schedules

hashset_C_ex: $(OUT_DIR)/CoarseHashSet_C.out $(OUT_DIR)/StripedHashSet_C.out \
  $(OUT_DIR)/RefinableHashSet_C.out \
  $(OUT_DIR)/LockFreeHashSet_C.out \
	$(OUT_DIR)/LockFreeHashSetPatched_C.out

$(HASHSETS): hashset_%: $(OUT_DIR)/CoarseHashSet_%.out $(OUT_DIR)/StripedHashSet_%.out \
  $(OUT_DIR)/RefinableHashSet_%.out $(OUT_DIR)/StripedCuckooHashSet_%.out \
  $(OUT_DIR)/RefinableCuckooHashSet_%.out $(OUT_DIR)/LockFreeHashSet_%.out \
	$(OUT_DIR)/LockFreeHashSetPatched_%.out

hashset_schedules: \
  $(addprefix $(OUT_DIR)/CoarseHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/StripedHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/StripedCuckooHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/LockFreeHashSet_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf $(OUT_DIR)/CoarseHashSet*.* $(OUT_DIR)/StripedHashSet*.* \
  $(OUT_DIR)/StripedCuckooHashSet*.* $(OUT_DIR)/LockFreeHashSet*.*

.PHONY: clean all myall $(HASHSETS) hashset_schedules

DRY ?= FALSE
DRYFLAG =
ifneq ($(DRY),FALSE)
	DRYFLAG = -dryrun
endif

# New hashset bound settings
HASH_BOUND_A = -kind=set $(BOUND_A) $(DRYFLAG)
HASH_BOUND_B = -kind=set $(BOUND_B) $(DRYFLAG)
HASH_BOUND_C = -kind=set $(BOUND_C) $(DRYFLAG)
HASH_BOUND_D = -kind=set $(BOUND_D) $(DRYFLAG) -tidy
HASH_BOUND_E = -kind=set $(BOUND_E) $(DRYFLAG) -tidy

SET_INC = $(DRIVER_INC) $(SET_H)
SET_SRC = $(DRIVER_SRC) $(SET_COL)
SET_DEP = $(SET_INC) $(SET_SRC)
SET_SCHED_1 = $(SCHEDULE_DIR)/sched_set_1.cvl
SET_SCHED_2 = $(SCHEDULE_DIR)/sched_set_2.cvl
SET_SCHED_3 = $(SCHEDULE_DIR)/sched_set_3.cvl

# for quiescent consistency...
SETQ_SRC = $(DRIVERQ_SRC) $(SET_COL)
SETQ_DEP = $(SET_INC) $(SETQ_SRC)


## CoarseHashSet

COARSE = $(SET_DIR)/CoarseHashSet.cvl
COARSE_SRC = $(COARSE) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
COARSE_ALL = $(SET_SRC) $(COARSE_SRC) $(NBSET_OR)
COARSE_DEP = $(COARSE_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
COARSE_OUT = $(addprefix $(OUT_DIR)/CoarseHashSet_,$(addsuffix .out,A B C D E))

# Multiple schedule analyses
# Ex: make -f sets.mk $(OUT_DIR)/CoarseHashSet_1.out
$(COARSE_OUT): $(OUT_DIR)/CoarseHashSet_%.out: $(COLLECT) $(COARSE_DEP)
	rm -rf $(OUT_DIR)/CoarseHashSet_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/CoarseHashSet_$*.dir.tmp $(COARSE_SRC) \
  >$(OUT_DIR)/CoarseHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/CoarseHashSet_$*.dir
	mv $(OUT_DIR)/CoarseHashSet_$*.out.tmp $(OUT_DIR)/CoarseHashSet_$*.out
	mv $(OUT_DIR)/CoarseHashSet_$*.dir.tmp $(OUT_DIR)/CoarseHashSet_$*.dir

# Single schedules.
# Ex: make -f sets.mk $(OUT_DIR)/CoarseHashSet_S1.out
$(OUT_DIR)/CoarseHashSet_S%.out: $(COARSE_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSE_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/CoarseHashSet_S$*.out


## CoarseHashSet quiescent consistency

COARSEQ_ALL =  $(SETQ_SRC) $(COARSE_SRC) $(NBSET_OR)
COARSEQ_DEP = $(COARSEQ_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
COARSEQ_OUT = $(addprefix $(OUT_DIR)/CoarseHashSetQ_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/CoarseHashSetQ_1.out
$(COARSEQ_OUT): $(OUT_DIR)/CoarseHashSetQ_%.out: $(COLLECT) $(COARSEQ_DEP)
	rm -rf $(OUT_DIR)/CoarseHashSetQ_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking -property=quiescent \
  -tmpDir=$(OUT_DIR)/CoarseHashSetQ_$*.dir.tmp $(COARSE_SRC) \
  >$(OUT_DIR)/CoarseHashSetQ_$*.out.tmp
	rm -rf $(OUT_DIR)/CoarseHashSetQ_$*.dir
	mv $(OUT_DIR)/CoarseHashSetQ_$*.out.tmp $(OUT_DIR)/CoarseHashSetQ_$*.out
	mv $(OUT_DIR)/CoarseHashSetQ_$*.dir.tmp $(OUT_DIR)/CoarseHashSetQ_$*.dir

# Single schedules.
# Ex: make -f sets.mk $(OUT_DIR)/CoarseHashSetQ_S1.out
$(OUT_DIR)/CoarseHashSetQ_S%.out: $(COARSEQ_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSEQ_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/CoarseHashSetQ_S$*.out


## StripedHashSet

STRIPED = $(SET_DIR)/StripedHashSet.cvl
STRIPED_SRC = $(STRIPED) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
STRIPED_ALL = $(SET_SRC) $(STRIPED_SRC) $(NBSET_OR)
STRIPED_DEP = $(STRIPED_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
STRIPED_OUT = $(addprefix $(OUT_DIR)/StripedHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/StripedHashSet_1.out
$(STRIPED_OUT): $(OUT_DIR)/StripedHashSet_%.out: $(COLLECT) $(STRIPED_DEP)
	rm -rf $(OUT_DIR)/StripedHashSet_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/StripedHashSet_$*.dir.tmp $(STRIPED_SRC) \
  >$(OUT_DIR)/StripedHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/StripedHashSet_$*.dir
	mv $(OUT_DIR)/StripedHashSet_$*.out.tmp $(OUT_DIR)/StripedHashSet_$*.out
	mv $(OUT_DIR)/StripedHashSet_$*.dir.tmp $(OUT_DIR)/StripedHashSet_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/StripedHashSet_S1.out
$(OUT_DIR)/StripedHashSet_S%.out: $(STRIPED_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(STRIPED_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/StripedHashSet_S$*.out


## RefinableHashSet

REFINABLE = $(SET_DIR)/RefinableHashSet.cvl
REFINABLE_SRC = $(REFINABLE) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) $(AMR_SRC)
REFINABLE_ALL = $(SET_SRC) $(REFINABLE_SRC) $(NBSET_OR)
REFINABLE_DEP = $(REFINABLE_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC) $(AMR_INC)
REFINABLE_OUT = $(addprefix $(OUT_DIR)/RefinableHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/RefinableHashSet_1.out
$(REFINABLE_OUT): $(OUT_DIR)/RefinableHashSet_%.out: $(COLLECT) $(REFINABLE_DEP)
	rm -rf $(OUT_DIR)/RefinableHashSet_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking -D_LOCK_TEST \
  -tmpDir=$(OUT_DIR)/RefinableHashSet_$*.dir.tmp $(REFINABLE_SRC) \
  -checkMemoryLeak=false >$(OUT_DIR)/RefinableHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/RefinableHashSet_$*.dir
	mv $(OUT_DIR)/RefinableHashSet_$*.out.tmp $(OUT_DIR)/RefinableHashSet_$*.out
	mv $(OUT_DIR)/RefinableHashSet_$*.dir.tmp $(OUT_DIR)/RefinableHashSet_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/RefinableHashSet_S1.out
$(OUT_DIR)/RefinableHashSet_S%.out: $(REFINABLE_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -D_LOCK_TEST \
  $(REFINABLE_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/RefinableHashSet_S$*.out

## StripedCuckooHashSet

SCUCKOO = $(SET_DIR)/StripedCuckooHashSet.cvl
SCUCKOO_SRC = $(SCUCKOO) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
SCUCKOO_ALL = $(SET_SRC) $(SCUCKOO_SRC) $(NBSET_OR)
SCUCKOO_DEP = $(SCUCKOO_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
SCUCKOO_OUT = $(addprefix $(OUT_DIR)/StripedCuckooHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/StripedCuckooHashSet_1.out
# some bugs are revealed: config 3 schedule_3366
$(SCUCKOO_OUT): $(OUT_DIR)/StripedCuckooHashSet_%.out: $(COLLECT) $(SCUCKOO_DEP)
	rm -rf $(OUT_DIR)/StripedCuckooHashSet_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/StripedCuckooHashSet_$*.dir.tmp $(SCUCKOO_SRC) \
  >$(OUT_DIR)/StripedCuckooHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/StripedCuckooHashSet_$*.dir
	mv $(OUT_DIR)/StripedCuckooHashSet_$*.out.tmp $(OUT_DIR)/StripedCuckooHashSet_$*.out
	mv $(OUT_DIR)/StripedCuckooHashSet_$*.dir.tmp $(OUT_DIR)/StripedCuckooHashSet_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/StripedCuckooHashSet_S1.out
$(OUT_DIR)/StripedCuckooHashSet_S%.out: $(SCUCKOO_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(SCUCKOO_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/StripedCuckooHashSet_S$*.out


## RefinableCuckooHashSet

RCUCKOO = $(SET_DIR)/RefinableCuckooHashSet.cvl
RCUCKOO_SRC = $(RCUCKOO) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) $(AMR_SRC)
RCUCKOO_ALL = $(SET_SRC) $(RCUCKOO_SRC) $(NBSET_OR)
RCUCKOO_DEP = $(RCUCKOO_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC) $(AMR_INC)
RCUCKOO_OUT = $(addprefix $(OUT_DIR)/RefinableCuckooHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/RefinableCuckooHashSet_1.out
# some bugs are revealed: config 3 schedule_3366
$(RCUCKOO_OUT): $(OUT_DIR)/RefinableCuckooHashSet_%.out: $(COLLECT) $(RCUCKOO_DEP)
	rm -rf $(OUT_DIR)/RefinableCuckooHashSet_$*.dir.tmp
	-$(COLLECT) $(HASH_BOUND_$*) -spec=nonblocking -D_LOCK_TEST \
  -tmpDir=$(OUT_DIR)/RefinableCuckooHashSet_$*.dir.tmp $(RCUCKOO_SRC) \
  -checkMemoryLeak=false >$(OUT_DIR)/RefinableCuckooHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/RefinableCuckooHashSet_$*.dir
	mv $(OUT_DIR)/RefinableCuckooHashSet_$*.out.tmp $(OUT_DIR)/RefinableCuckooHashSet_$*.out
	mv $(OUT_DIR)/RefinableCuckooHashSet_$*.dir.tmp $(OUT_DIR)/RefinableCuckooHashSet_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/RefinableCuckooHashSet_S1.out
$(OUT_DIR)/RefinableCuckooHashSet_S%.out: $(RCUCKOO_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -D_LOCK_TEST \
  $(RCUCKOO_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/RefinableCuckooHashSet_S$*.out


## LockFreeHashSet

LOCKFREE = $(SET_DIR)/LockFreeHashSet.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREE_ALL = $(SET_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREE_OUT = $(addprefix $(OUT_DIR)/LockFreeHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/LockFreeHashSet_1.out
$(LOCKFREE_OUT): $(OUT_DIR)/LockFreeHashSet_%.out: $(COLLECT) $(LOCKFREE_DEP)
	rm -rf $(OUT_DIR)/LockFreeHashSet_$*.dir.tmp
	-$(COLLECT) -fair -checkMemoryLeak=false $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/LockFreeHashSet_$*.dir.tmp $(LOCKFREE_SRC) \
  >$(OUT_DIR)/LockFreeHashSet_$*.out.tmp
	rm -rf $(OUT_DIR)/LockFreeHashSet_$*.dir
	mv $(OUT_DIR)/LockFreeHashSet_$*.out.tmp $(OUT_DIR)/LockFreeHashSet_$*.out
	mv $(OUT_DIR)/LockFreeHashSet_$*.dir.tmp $(OUT_DIR)/LockFreeHashSet_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/LockFreeHashSet_S1.out
$(OUT_DIR)/LockFreeHashSet_S%.out: $(LOCKFREE_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/LockFreeHashSet_S$*.out


## LockFreeHashSetPatched

LOCKFREEP = $(SET_DIR)/LockFreeHashSetPatched.cvl
LOCKFREEP_SRC = $(LOCKFREEP) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREEP_ALL = $(SET_SRC) $(LOCKFREEP_SRC) $(NBSET_OR)
LOCKFREEP_DEP = $(LOCKFREEP_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREEP_OUT = $(addprefix $(OUT_DIR)/LockFreeHashSetPatched_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk $(OUT_DIR)/LockFreeHashSetPatched_1.out
$(LOCKFREEP_OUT): $(OUT_DIR)/LockFreeHashSetPatched_%.out: $(COLLECT) $(LOCKFREEP_DEP)
	rm -rf $(OUT_DIR)/LockFreeHashSetPatched_$*.dir.tmp
	-$(COLLECT) -fair -checkMemoryLeak=false $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/LockFreeHashSetPatched_$*.dir.tmp $(LOCKFREEP_SRC) \
  >$(OUT_DIR)/LockFreeHashSetPatched_$*.out.tmp
	rm -rf $(OUT_DIR)/LockFreeHashSetPatched_$*.dir
	mv $(OUT_DIR)/LockFreeHashSetPatched_$*.out.tmp $(OUT_DIR)/LockFreeHashSetPatched_$*.out
	mv $(OUT_DIR)/LockFreeHashSetPatched_$*.dir.tmp $(OUT_DIR)/LockFreeHashSetPatched_$*.dir

# Ex: make -f sets.mk $(OUT_DIR)/LockFreeHashSetPatched_S1.out
$(OUT_DIR)/LockFreeHashSetPatched_S%.out: $(LOCKFREEP_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREEP_ALL) $(SET_SCHED_$*) >$(OUT_DIR)/LockFreeHashSetPatched_S$*.out
