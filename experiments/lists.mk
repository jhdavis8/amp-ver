# Filename : sets.mk
# Author   : Josh Davis
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for lists experiments.  Lists are used to implement the
# set interface.

ROOT = ..
include $(ROOT)/experiments/common.mk


## Common definitions

LISTS = list_A list_B list_C list_D list_E

all: $(LISTS) list_schedules

$(LISTS): list_%: $(OUT_DIR)/CoarseList_%.out \
  $(OUT_DIR)/FineList_%.out $(OUT_DIR)/OptimisticList_%.out $(OUT_DIR)/LazyList_%.out \
  $(OUT_DIR)/LockFreeList_%.out $(OUT_DIR)/LockFreeListOriginal_%.out

list_schedules: \
  $(addprefix $(OUT_DIR)/CoarseList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/FineList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/OptimisticList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/LazyList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/LockFreeList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix $(OUT_DIR)/LockFreeListOriginal_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf $(OUT_DIR)/*List*.*

.PHONY: clean all myall $(LISTS) list_schedules

DRY ?= FALSE
DRYFLAG =
ifneq ($(DRY),FALSE)
	DRYFLAG = -dryrun
endif

# New list bound settings
LIST_BOUND_A = -kind=set $(BOUND_A) $(DRYFLAG)
LIST_BOUND_B = -kind=set $(BOUND_B) $(DRYFLAG)
LIST_BOUND_C = -kind=set $(BOUND_C) $(DRYFLAG)
LIST_BOUND_D = -kind=set $(BOUND_D) $(DRYFLAG) -tidy
LIST_BOUND_E = -kind=set $(BOUND_E) $(DRYFLAG) -tidy

LIST_INC = $(DRIVER_INC) $(LIST_H) lists.mk
LIST_SRC = $(DRIVER_SRC) $(SET_COL)
LIST_DEP = $(LIST_INC) $(LIST_SRC)
LIST_SCHED_1 = $(SCHEDULE_DIR)/sched_set_1.cvl
LIST_SCHED_2 = $(SCHEDULE_DIR)/sched_set_2.cvl
LIST_SCHED_3 = $(SCHEDULE_DIR)/sched_set_3.cvl


## CoarseList
# Assumes hash codes map distinct to distinct, so can fail is nd hashkind is set

COARSE = $(LIST_DIR)/CoarseList.cvl
COARSE_SRC = $(COARSE) $(HASH_SRC) $(LOCK_SRC)
COARSE_ALL = $(LIST_SRC) $(COARSE_SRC) $(NBSET_OR)
COARSE_DEP = $(COARSE_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INC)
COARSE_OUT = $(addprefix $(OUT_DIR)/CoarseList_,$(addsuffix .out,A B C D E))

# Multiple schedule analyses
# Ex: make -f lists.mk $(OUT_DIR)/CoarseList_1.out
$(COARSE_OUT): $(OUT_DIR)/CoarseList_%.out: $(COLLECT) $(COARSE_DEP)
	rm -rf $(OUT_DIR)/CoarseList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/CoarseList_$*.dir.tmp $(COARSE_SRC) \
  >$(OUT_DIR)/CoarseList_$*.out.tmp
	rm -rf $(OUT_DIR)/CoarseList_$*.dir
	mv $(OUT_DIR)/CoarseList_$*.out.tmp $(OUT_DIR)/CoarseList_$*.out
	mv $(OUT_DIR)/CoarseList_$*.dir.tmp $(OUT_DIR)/CoarseList_$*.dir

# Single schedules.
# Ex: make -f lists.mk $(OUT_DIR)/CoarseList_S1.out
$(OUT_DIR)/CoarseList_S%.out: $(COARSE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSE_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/CoarseList_S$*.out


## FineList

FINE = $(LIST_DIR)/FineList.cvl
FINE_SRC = $(FINE) $(HASH_SRC) $(LOCK_SRC)
FINE_ALL = $(LIST_SRC) $(FINE_SRC) $(NBSET_OR)
FINE_DEP = $(FINE_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INC)
FINE_OUT = $(addprefix $(OUT_DIR)/FineList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk $(OUT_DIR)/FineList_1.out
$(FINE_OUT): $(OUT_DIR)/FineList_%.out: $(COLLECT) $(FINE_DEP)
	rm -rf $(OUT_DIR)/FineList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -tmpDir=$(OUT_DIR)/FineList_$*.dir.tmp $(FINE_SRC) \
  >$(OUT_DIR)/FineList_$*.out.tmp
	rm -rf $(OUT_DIR)/FineList_$*.dir
	mv $(OUT_DIR)/FineList_$*.out.tmp $(OUT_DIR)/FineList_$*.out
	mv $(OUT_DIR)/FineList_$*.dir.tmp $(OUT_DIR)/FineList_$*.dir

# Ex: make -f lists.mk $(OUT_DIR)/FineList_S1.out
$(OUT_DIR)/FineList_S%.out: $(FINE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(FINE_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/FineList_S$*.out


## OptimisticList

OPT = $(LIST_DIR)/OptimisticList.cvl
OPT_SRC = $(OPT) $(HASH_SRC) $(LOCK_SRC)
OPT_ALL = $(LIST_SRC) $(OPT_SRC) $(NBSET_OR)
OPT_DEP = $(OPT_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INC)
OPT_OUT = $(addprefix $(OUT_DIR)/OptimisticList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk $(OUT_DIR)/OptimisticList_1.out
$(OPT_OUT): $(OUT_DIR)/OptimisticList_%.out: $(COLLECT) $(OPT_DEP)
	rm -rf $(OUT_DIR)/OptimisticList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/OptimisticList_$*.dir.tmp $(OPT_SRC) \
  >$(OUT_DIR)/OptimisticList_$*.out.tmp
	rm -rf $(OUT_DIR)/OptimisticList_$*.dir
	mv $(OUT_DIR)/OptimisticList_$*.out.tmp $(OUT_DIR)/OptimisticList_$*.out
	mv $(OUT_DIR)/OptimisticList_$*.dir.tmp $(OUT_DIR)/OptimisticList_$*.dir

# Ex: make -f lists.mk $(OUT_DIR)/OptimisiticList_S1.out
$(OUT_DIR)/OptimisticList_S%.out: $(OPT_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(OPT_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/OptimisticList_S$*.out


## LazyList

LAZY = $(LIST_DIR)/LazyList.cvl
LAZY_SRC = $(LAZY) $(HASH_SRC) $(LOCK_SRC)
LAZY_ALL = $(LIST_SRC) $(LAZY_SRC) $(NBSET_OR)
LAZY_DEP = $(LAZY_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INT)
LAZY_OUT = $(addprefix $(OUT_DIR)/LazyList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk $(OUT_DIR)/LazyList_1.out
$(LAZY_OUT): $(OUT_DIR)/LazyList_%.out: $(COLLECT) $(LAZY_DEP)
	rm -rf $(OUT_DIR)/LazyList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/LazyList_$*.dir.tmp $(LAZY_SRC) \
  >$(OUT_DIR)/LazyList_$*.out.tmp
	rm -rf $(OUT_DIR)/LazyList_$*.dir
	mv $(OUT_DIR)/LazyList_$*.out.tmp $(OUT_DIR)/LazyList_$*.out
	mv $(OUT_DIR)/LazyList_$*.dir.tmp $(OUT_DIR)/LazyList_$*.dir

# Ex: make -f lists.mk $(OUT_DIR)/LazyList_S1.out
$(OUT_DIR)/LazyList_S%.out: $(LAZY_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(LAZY_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/LazyList_S$*.out


## LockFreeList (Nonblocking list)

LOCKFREE = $(LIST_DIR)/LockFreeList.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC)
LOCKFREE_ALL = $(LIST_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(LIST_INC) $(HASH_INC) $(AMR_INC)
LOCKFREE_OUT = $(addprefix $(OUT_DIR)/LockFreeList_,$(addsuffix .out,A B C D E))
LOCKFREEORG_OUT = $(addprefix $(OUT_DIR)/LockFreeListOriginal_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk $(OUT_DIR)/LockFreeList_1.out
$(LOCKFREE_OUT): $(OUT_DIR)/LockFreeList_%.out: $(COLLECT) $(LOCKFREE_DEP)
	rm -rf $(OUT_DIR)/LockFreeList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=$(OUT_DIR)/LockFreeList_$*.dir.tmp $(LOCKFREE_SRC) \
  >$(OUT_DIR)/LockFreeList_$*.out.tmp
	rm -rf $(OUT_DIR)/LockFreeList_$*.dir
	mv $(OUT_DIR)/LockFreeList_$*.out.tmp $(OUT_DIR)/LockFreeList_$*.out
	mv $(OUT_DIR)/LockFreeList_$*.dir.tmp $(OUT_DIR)/LockFreeList_$*.dir

# Ex: make -f lists.mk $(OUT_DIR)/LockFreeListOriginal_1.out
$(LOCKFREEORG_OUT): $(OUT_DIR)/LockFreeListOriginal_%.out: $(COLLECT) $(LOCKFREE_DEP)
	rm -rf $(OUT_DIR)/LockFreeListOriginal_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -checkMemoryLeak=false -DORIGINAL \
  -tmpDir=$(OUT_DIR)/LockFreeListOriginal_$*.dir.tmp $(LOCKFREE_SRC) \
  >$(OUT_DIR)/LockFreeListOriginal_$*.out.tmp
	rm -rf $(OUT_DIR)/LockFreeListOriginal_$*.dir
	mv $(OUT_DIR)/LockFreeListOriginal_$*.out.tmp $(OUT_DIR)/LockFreeListOriginal_$*.out
	mv $(OUT_DIR)/LockFreeListOriginal_$*.dir.tmp $(OUT_DIR)/LockFreeListOriginal_$*.dir

# Ex: make -f lists.mk $(OUT_DIR)/LockFreeList_S1.out
$(OUT_DIR)/LockFreeList_S%.out: $(LOCKFREE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/LockFreeList_S$*.out

# Ex: make -f lists.mk $(OUT_DIR)/LockFreeListOriginal_S1.out
$(OUT_DIR)/LockFreeListOriginal_S%.out: $(LOCKFREET_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -DORIGINAL $(LOCKFREE_ALL) $(LIST_SCHED_$*) >$(OUT_DIR)/LockFreeListOriginal_S$*.out
