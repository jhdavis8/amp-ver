# Filename : hashsets.mk
# Author   : Josh Davis
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for hash sets experiments.
ROOT = .
include $(ROOT)/common.mk


## Common definitions

HASHSETS = hashset_A hashset_B hashset_C hashset_D hashset_E

all: $(HASHSETS) hashset_schedules

hashset_C_ex: out/CoarseHashSet_C.out out/StripedHashSet_C.out \
  out/RefinableHashSet_C.out \
  out/LockFreeHashSet_C.out \
	out/LockFreeHashSetPatched_C.out

$(HASHSETS): hashset_%: out/CoarseHashSet_%.out out/StripedHashSet_%.out \
  out/RefinableHashSet_%.out out/StripedCuckooHashSet_%.out \
  out/RefinableCuckooHashSet_%.out out/LockFreeHashSet_%.out \
	out/LockFreeHashSetPatched_%.out

hashset_schedules: \
  $(addprefix out/CoarseHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/StripedHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/StripedCuckooHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LockFreeHashSet_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf out/CoarseHashSet*.* out/StripedHashSet*.* \
  out/StripedCuckooHashSet*.* out/LockFreeHashSet*.*

.PHONY: clean all myall $(HASHSETS) hashset_schedules

# New hashset bound settings
HASH_BOUND_A = -kind=set $(BOUND_A)
HASH_BOUND_B = -kind=set $(BOUND_B)
HASH_BOUND_C = -kind=set $(BOUND_C)
HASH_BOUND_D = -kind=set $(BOUND_D)
HASH_BOUND_E = -kind=set $(BOUND_E)

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
COARSE_OUT = $(addprefix out/CoarseHashSet_,$(addsuffix .out,A B C D E))

# Multiple schedule analyses
# Ex: make -f sets.mk out/CoarseHashSet_1.out
$(COARSE_OUT): out/CoarseHashSet_%.out: $(MAIN_CLASS) $(COARSE_DEP)
	rm -rf out/CoarseHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/CoarseHashSet_$*.dir.tmp $(COARSE_SRC) \
  >out/CoarseHashSet_$*.out.tmp
	rm -rf out/CoarseHashSet_$*.dir
	mv out/CoarseHashSet_$*.out.tmp out/CoarseHashSet_$*.out
	mv out/CoarseHashSet_$*.dir.tmp out/CoarseHashSet_$*.dir

# Single schedules.
# Ex: make -f sets.mk out/CoarseHashSet_S1.out
out/CoarseHashSet_S%.out: $(COARSE_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSE_ALL) $(SET_SCHED_$*) >out/CoarseHashSet_S$*.out


## CoarseHashSet quiescent consistency

COARSEQ_ALL =  $(SETQ_SRC) $(COARSE_SRC) $(NBSET_OR)
COARSEQ_DEP = $(COARSEQ_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
COARSEQ_OUT = $(addprefix out/CoarseHashSetQ_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/CoarseHashSetQ_1.out
$(COARSEQ_OUT): out/CoarseHashSetQ_%.out: $(MAIN_CLASS) $(COARSEQ_DEP)
	rm -rf out/CoarseHashSetQ_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking -property=quiescent \
  -tmpDir=out/CoarseHashSetQ_$*.dir.tmp $(COARSE_SRC) \
  >out/CoarseHashSetQ_$*.out.tmp
	rm -rf out/CoarseHashSetQ_$*.dir
	mv out/CoarseHashSetQ_$*.out.tmp out/CoarseHashSetQ_$*.out
	mv out/CoarseHashSetQ_$*.dir.tmp out/CoarseHashSetQ_$*.dir

# Single schedules.
# Ex: make -f sets.mk out/CoarseHashSetQ_S1.out
out/CoarseHashSetQ_S%.out: $(COARSEQ_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSEQ_ALL) $(SET_SCHED_$*) >out/CoarseHashSetQ_S$*.out


## StripedHashSet

STRIPED = $(SET_DIR)/StripedHashSet.cvl
STRIPED_SRC = $(STRIPED) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
STRIPED_ALL = $(SET_SRC) $(STRIPED_SRC) $(NBSET_OR)
STRIPED_DEP = $(STRIPED_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
STRIPED_OUT = $(addprefix out/StripedHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/StripedHashSet_1.out
$(STRIPED_OUT): out/StripedHashSet_%.out: $(MAIN_CLASS) $(STRIPED_DEP)
	rm -rf out/StripedHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/StripedHashSet_$*.dir.tmp $(STRIPED_SRC) \
  >out/StripedHashSet_$*.out.tmp
	rm -rf out/StripedHashSet_$*.dir
	mv out/StripedHashSet_$*.out.tmp out/StripedHashSet_$*.out
	mv out/StripedHashSet_$*.dir.tmp out/StripedHashSet_$*.dir

# Ex: make -f sets.mk out/StripedHashSet_S1.out
out/StripedHashSet_S%.out: $(STRIPED_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(STRIPED_ALL) $(SET_SCHED_$*) >out/StripedHashSet_S$*.out


## RefinableHashSet

REFINABLE = $(SET_DIR)/RefinableHashSet.cvl
REFINABLE_SRC = $(REFINABLE) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
REFINABLE_ALL = $(SET_SRC) $(REFINABLE_SRC) $(NBSET_OR)
REFINABLE_DEP = $(REFINABLE_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
REFINABLE_OUT = $(addprefix out/RefinableHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/RefinableHashSet_1.out
$(REFINABLE_OUT): out/RefinableHashSet_%.out: $(MAIN_CLASS) $(REFINABLE_DEP)
	rm -rf out/RefinableHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/RefinableHashSet_$*.dir.tmp $(REFINABLE_SRC) \
  >out/RefinableHashSet_$*.out.tmp
	rm -rf out/RefinableHashSet_$*.dir
	mv out/RefinableHashSet_$*.out.tmp out/RefinableHashSet_$*.out
	mv out/RefinableHashSet_$*.dir.tmp out/RefinableHashSet_$*.dir

# Ex: make -f sets.mk out/RefinableHashSet_S1.out
out/RefinableHashSet_S%.out: $(REFINABLE_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(REFINABLE_ALL) $(SET_SCHED_$*) >out/RefinableHashSet_S$*.out

## StripedCuckooHashSet

SCUCKOO = $(SET_DIR)/StripedCuckooHashSet.cvl
SCUCKOO_SRC = $(SCUCKOO) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
SCUCKOO_ALL = $(SET_SRC) $(SCUCKOO_SRC) $(NBSET_OR)
SCUCKOO_DEP = $(SCUCKOO_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
SCUCKOO_OUT = $(addprefix out/StripedCuckooHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/StripedCuckooHashSet_1.out
# some bugs are revealed: config 3 schedule_3366
$(SCUCKOO_OUT): out/StripedCuckooHashSet_%.out: $(MAIN_CLASS) $(SCUCKOO_DEP)
	rm -rf out/StripedCuckooHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/StripedCuckooHashSet_$*.dir.tmp $(SCUCKOO_SRC) \
  >out/StripedCuckooHashSet_$*.out.tmp
	rm -rf out/StripedCuckooHashSet_$*.dir
	mv out/StripedCuckooHashSet_$*.out.tmp out/StripedCuckooHashSet_$*.out
	mv out/StripedCuckooHashSet_$*.dir.tmp out/StripedCuckooHashSet_$*.dir

# Ex: make -f sets.mk out/StripedCuckooHashSet_S1.out
out/StripedCuckooHashSet_S%.out: $(SCUCKOO_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(SCUCKOO_ALL) $(SET_SCHED_$*) >out/StripedCuckooHashSet_S$*.out


## RefinableCuckooHashSet

RCUCKOO = $(SET_DIR)/RefinableCuckooHashSet.cvl
RCUCKOO_SRC = $(RCUCKOO) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
RCUCKOO_ALL = $(SET_SRC) $(RCUCKOO_SRC) $(NBSET_OR)
RCUCKOO_DEP = $(RCUCKOO_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
RCUCKOO_OUT = $(addprefix out/RefinableCuckooHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/RefinableCuckooHashSet_1.out
# some bugs are revealed: config 3 schedule_3366
$(RCUCKOO_OUT): out/RefinableCuckooHashSet_%.out: $(MAIN_CLASS) $(RCUCKOO_DEP)
	rm -rf out/RefinableCuckooHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/RefinableCuckooHashSet_$*.dir.tmp $(RCUCKOO_SRC) \
  >out/RefinableCuckooHashSet_$*.out.tmp
	rm -rf out/RefinableCuckooHashSet_$*.dir
	mv out/RefinableCuckooHashSet_$*.out.tmp out/RefinableCuckooHashSet_$*.out
	mv out/RefinableCuckooHashSet_$*.dir.tmp out/RefinableCuckooHashSet_$*.dir

# Ex: make -f sets.mk out/RefinableCuckooHashSet_S1.out
out/RefinableCuckooHashSet_S%.out: $(RCUCKOO_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(RCUCKOO_ALL) $(SET_SCHED_$*) >out/RefinableCuckooHashSet_S$*.out


## LockFreeHashSet

LOCKFREE = $(SET_DIR)/LockFreeHashSet.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREE_ALL = $(SET_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREE_OUT = $(addprefix out/LockFreeHashSet_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/LockFreeHashSet_1.out
$(LOCKFREE_OUT): out/LockFreeHashSet_%.out: $(MAIN_CLASS) $(LOCKFREE_DEP)
	rm -rf out/LockFreeHashSet_$*.dir.tmp
	-$(AMPVER) -fair -checkMemoryLeak=false $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/LockFreeHashSet_$*.dir.tmp $(LOCKFREE_SRC) \
  >out/LockFreeHashSet_$*.out.tmp
	rm -rf out/LockFreeHashSet_$*.dir
	mv out/LockFreeHashSet_$*.out.tmp out/LockFreeHashSet_$*.out
	mv out/LockFreeHashSet_$*.dir.tmp out/LockFreeHashSet_$*.dir

# Ex: make -f sets.mk out/LockFreeHashSet_S1.out
out/LockFreeHashSet_S%.out: $(LOCKFREE_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(SET_SCHED_$*) >out/LockFreeHashSet_S$*.out


## LockFreeHashSetPatched

LOCKFREEP = $(SET_DIR)/LockFreeHashSetPatched.cvl
LOCKFREEP_SRC = $(LOCKFREEP) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREEP_ALL = $(SET_SRC) $(LOCKFREEP_SRC) $(NBSET_OR)
LOCKFREEP_DEP = $(LOCKFREEP_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREEP_OUT = $(addprefix out/LockFreeHashSetPatched_,$(addsuffix .out,A B C D E))

# Ex: make -f sets.mk out/LockFreeHashSetPatched_1.out
$(LOCKFREEP_OUT): out/LockFreeHashSetPatched_%.out: $(MAIN_CLASS) $(LOCKFREEP_DEP)
	rm -rf out/LockFreeHashSetPatched_$*.dir.tmp
	-$(AMPVER) -fair -checkMemoryLeak=false $(HASH_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/LockFreeHashSetPatched_$*.dir.tmp $(LOCKFREEP_SRC) \
  >out/LockFreeHashSetPatched_$*.out.tmp
	rm -rf out/LockFreeHashSetPatched_$*.dir
	mv out/LockFreeHashSetPatched_$*.out.tmp out/LockFreeHashSetPatched_$*.out
	mv out/LockFreeHashSetPatched_$*.dir.tmp out/LockFreeHashSetPatched_$*.dir

# Ex: make -f sets.mk out/LockFreeHashSetPatched_S1.out
out/LockFreeHashSetPatched_S%.out: $(LOCKFREEP_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREEP_ALL) $(SET_SCHED_$*) >out/LockFreeHashSetPatched_S$*.out
