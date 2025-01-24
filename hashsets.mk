# Filename : hashsets.mk
# Author   : Josh Davis
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for hash sets experiments.
ROOT = .
include $(ROOT)/common.mk


## Common definitions

HASHSETS = hashset_1 hashset_2 hashset_3 hashset_4 hashset_1ND \
  hashset_1.5ND hashset_2ND

all: $(HASHSETS) hashset_schedules

$(HASHSETS): hashset_%: out/CoarseHashSet_%.out out/StripedHashSet_%.out \
  out/StripedCuckooHashSet_%.out out/LockFreeHashSet_%.out

hashset_schedules: \
  $(addprefix out/CoarseHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/StripedHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/StripedCuckooHashSet_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LockFreeHashSet_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf out/CoarseHashSet*.* out/StripedHashSet*.* \
  out/StripedCuckooHashSet*.* out/LockFreeHashSet*.*

.PHONY: clean all myall $(HASHSETS) hashset_schedules

# 63 schedules
HASH_LIMITS_1 = -kind=set -hashKind=ident -valueBound=2 -nthread=1..2 \
  -nstep=1..2 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASH_LIMITS_1ND = -kind=set -hashKind=nd -hashRangeBound=2 \
  -hashDomainBound=2 -valueBound=2 -nthread=1..2 -nstep=1..2 -npreAdd=0 \
  -threadSym -checkTermination -ncore=$(NCORE)

HASH_LIMITS_1.5ND = -kind=set -hashKind=nd -hashRangeBound=2 \
  -hashDomainBound=3 -valueBound=3 -nthread=1..3 -nstep=1..3 -npreAdd=0 \
  -threadSym -checkTermination -ncore=$(NCORE)

# 1758 schedules
HASH_LIMITS_2 = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
  -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASH_LIMITS_2ND = -kind=set -hashKind=nd -hashRangeBound=4 \
  -hashDomainBound=3 -valueBound=3 -nthread=1..3 -nstep=1..3 -npreAdd=0 \
  -threadSym -checkTermination -ncore=$(NCORE)

# 5274 schedules
HASH_LIMITS_3 = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
  -nstep=1..3 -npreAdd=1..3 -threadSym -checkTermination -ncore=$(NCORE)

HASH_LIMITS_4 = -kind=set -hashKind=ident -valueBound=3 -nthread=3 \
  -nstep=4 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

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
COARSE_OUT = $(addprefix out/CoarseHashSet_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Multiple schedule analyses
# Ex: make -f sets.mk out/CoarseHashSet_1.out
$(COARSE_OUT): out/CoarseHashSet_%.out: $(MAIN_CLASS) $(COARSE_DEP)
	rm -rf out/CoarseHashSet_$*.dir.tmp
	$(AMPVER) $(HASH_LIMITS_$*) -spec=nonblocking \
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
COARSEQ_OUT = $(addprefix out/CoarseHashSetQ_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Ex: make -f sets.mk out/CoarseHashSetQ_1.out
$(COARSEQ_OUT): out/CoarseHashSetQ_%.out: $(MAIN_CLASS) $(COARSEQ_DEP)
	rm -rf out/CoarseHashSetQ_$*.dir.tmp
	$(AMPVER) $(HASH_LIMITS_$*) -spec=nonblocking -property=quiescent \
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
STRIPED_OUT = $(addprefix out/StripedHashSet_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Ex: make -f sets.mk out/StripedHashSet_1.out
$(STRIPED_OUT): out/StripedHashSet_%.out: $(MAIN_CLASS) $(STRIPED_DEP)
	rm -rf out/StripedHashSet_$*.dir.tmp
	$(AMPVER) $(HASH_LIMITS_$*) -spec=nonblocking \
  -tmpDir=out/StripedHashSet_$*.dir.tmp $(STRIPED_SRC) \
  >out/StripedHashSet_$*.out.tmp
	rm -rf out/StripedHashSet_$*.dir
	mv out/StripedHashSet_$*.out.tmp out/StripedHashSet_$*.out
	mv out/StripedHashSet_$*.dir.tmp out/StripedHashSet_$*.dir

# Ex: make -f sets.mk out/StripedHashSet_S1.out
out/StripedHashSet_S%.out: $(STRIPED_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(STRIPED_ALL) $(SET_SCHED_$*) >out/StripedHashSet_S$*.out


## StripedCuckooHashSet

SCUCKOO = $(SET_DIR)/StripedCuckooHashSet.cvl
SCUCKOO_SRC = $(SCUCKOO) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)
SCUCKOO_ALL = $(SET_SRC) $(SCUCKOO_SRC) $(NBSET_OR)
SCUCKOO_DEP = $(SCUCKOO_ALL) $(SET_INC) $(HASH_INC) $(LOCK_INC) $(ARRAYLIST_INC)
SCUCKOO_OUT = $(addprefix out/StripedCuckooHashSet_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Ex: make -f sets.mk out/StripedCuckooHashSet_1.out
# some bugs are revealed: config 3 schedule_3366
$(SCUCKOO_OUT): out/StripedCuckooHashSet_%.out: $(MAIN_CLASS) $(SCUCKOO_DEP)
	rm -rf out/StripedCuckooHashSet_$*.dir.tmp
	-$(AMPVER) $(HASH_LIMITS_$*) -spec=nonblocking \
  -tmpDir=out/StripedCuckooHashSet_$*.dir.tmp $(SCUCKOO_SRC) \
  >out/StripedCuckooHashSet_$*.out.tmp
	rm -rf out/StripedCuckooHashSet_$*.dir
	mv out/StripedCuckooHashSet_$*.out.tmp out/StripedCuckooHashSet_$*.out
	mv out/StripedCuckooHashSet_$*.dir.tmp out/StripedCuckooHashSet_$*.dir

# Ex: make -f sets.mk out/StripedCuckooHashSet_S1.out
out/StripedCuckooHashSet_S%.out: $(SCUCKOO_DEP) $(SET_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(SCUCKOO_ALL) $(SET_SCHED_$*) >out/StripedCuckooHashSet_S$*.out

## LockFreeHashSet

LOCKFREE = $(SET_DIR)/LockFreeHashSet.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREE_ALL = $(SET_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREE_OUT = $(addprefix out/LockFreeHashSet_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Ex: make -f sets.mk out/LockFreeHashSet_1.out
$(LOCKFREE_OUT): out/LockFreeHashSet_%.out: $(MAIN_CLASS) $(LOCKFREE_DEP)
	rm -rf out/LockFreeHashSet_$*.dir.tmp
	-$(AMPVER) -fair -checkTermination -checkMemoryLeak=false $(HASH_LIMITS_$*) \
  -spec=nonblocking -tmpDir=out/LockFreeHashSet_$*.dir.tmp $(LOCKFREE_SRC) \
  >out/LockFreeHashSet_$*.out.tmp
	rm -rf out/LockFreeHashSet_$*.dir
	mv out/LockFreeHashSet_$*.out.tmp out/LockFreeHashSet_$*.out
	mv out/LockFreeHashSet_$*.dir.tmp out/LockFreeHashSet_$*.dir

# Ex: make -f sets.mk out/LockFreeHashSet_S1.out
out/LockFreeHashSet_S%.out: $(LOCKFREE_DEP) $(SET_SCHED_$*)
	$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(SET_SCHED_$*) >out/LockFreeHashSet_S$*.out

## LockFreeHashSetPatched

LOCKFREE = $(SET_DIR)/LockFreeHashSetPatched.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC) $(AI_SRC)
LOCKFREE_ALL = $(SET_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(SET_INC) $(HASH_INC) $(AMR_INC) $(AI_INC)
LOCKFREE_OUT = $(addprefix out/LockFreeHashSetPatched_,$(addsuffix .out,1 1ND 1.5ND 2 2ND 3 4))

# Ex: make -f sets.mk out/LockFreeHashSetPatched_1.out
$(LOCKFREE_OUT): out/LockFreeHashSetPatched_%.out: $(MAIN_CLASS) $(LOCKFREE_DEP)
	rm -rf out/LockFreeHashSetPatched_$*.dir.tmp
	-$(AMPVER) -fair -checkTermination -checkMemoryLeak=false $(HASH_LIMITS_$*) \
  -spec=nonblocking -tmpDir=out/LockFreeHashSetPatched_$*.dir.tmp $(LOCKFREE_SRC) \
  >out/LockFreeHashSetPatched_$*.out.tmp
	rm -rf out/LockFreeHashSetPatched_$*.dir
	mv out/LockFreeHashSetPatched_$*.out.tmp out/LockFreeHashSetPatched_$*.out
	mv out/LockFreeHashSetPatched_$*.dir.tmp out/LockFreeHashSetPatched_$*.dir

# Ex: make -f sets.mk out/LockFreeHashSetPatched_S1.out
out/LockFreeHashSetPatched_S%.out: $(LOCKFREE_DEP) $(SET_SCHED_$*)
	$(VERIFY) -fair -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(SET_SCHED_$*) >out/LockFreeHashSetPatched_S$*.out
