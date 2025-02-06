# Filename : sets.mk
# Author   : Josh Davis
# Created  : 2024-11-25
# Modified : 2025-01-17
# Makefile for lists experiments.  Lists are used to implement the
# set interface.

ROOT = ..
include $(ROOT)/common.mk


## Common definitions

LISTS = list_A list_B list_C list_D list_E

all: $(LISTS) list_schedules

$(LISTS): list_%: out/CoarseList_%.out \
  out/FineList_%.out out/OptimisticList_%.out out/LazyList_%.out \
  out/LockFreeList_%.out out/LockFreeListOriginal_%.out

list_schedules: \
  $(addprefix out/CoarseList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/FineList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/OptimisticList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LazyList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LockFreeList_S,$(addsuffix .out,1 2 3)) \
  $(addprefix out/LockFreeListOriginal_S,$(addsuffix .out,1 2 3))

clean:
	rm -rf out/*List*.*

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
COARSE_OUT = $(addprefix out/CoarseList_,$(addsuffix .out,A B C D E))

# Multiple schedule analyses
# Ex: make -f lists.mk out/CoarseList_1.out
$(COARSE_OUT): out/CoarseList_%.out: $(COLLECT) $(COARSE_DEP)
	rm -rf out/CoarseList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/CoarseList_$*.dir.tmp $(COARSE_SRC) \
  >out/CoarseList_$*.out.tmp
	rm -rf out/CoarseList_$*.dir
	mv out/CoarseList_$*.out.tmp out/CoarseList_$*.out
	mv out/CoarseList_$*.dir.tmp out/CoarseList_$*.dir

# Single schedules.
# Ex: make -f lists.mk out/CoarseList_S1.out
out/CoarseList_S%.out: $(COARSE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(COARSE_ALL) $(LIST_SCHED_$*) >out/CoarseList_S$*.out


## FineList

FINE = $(LIST_DIR)/FineList.cvl
FINE_SRC = $(FINE) $(HASH_SRC) $(LOCK_SRC)
FINE_ALL = $(LIST_SRC) $(FINE_SRC) $(NBSET_OR)
FINE_DEP = $(FINE_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INC)
FINE_OUT = $(addprefix out/FineList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk out/FineList_1.out
$(FINE_OUT): out/FineList_%.out: $(COLLECT) $(FINE_DEP)
	rm -rf out/FineList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -tmpDir=out/FineList_$*.dir.tmp $(FINE_SRC) \
  >out/FineList_$*.out.tmp
	rm -rf out/FineList_$*.dir
	mv out/FineList_$*.out.tmp out/FineList_$*.out
	mv out/FineList_$*.dir.tmp out/FineList_$*.dir

# Ex: make -f lists.mk out/FineList_S1.out
out/FineList_S%.out: $(FINE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(FINE_ALL) $(LIST_SCHED_$*) >out/FineList_S$*.out


## OptimisticList

OPT = $(LIST_DIR)/OptimisticList.cvl
OPT_SRC = $(OPT) $(HASH_SRC) $(LOCK_SRC)
OPT_ALL = $(LIST_SRC) $(OPT_SRC) $(NBSET_OR)
OPT_DEP = $(OPT_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INC)
OPT_OUT = $(addprefix out/OptimisticList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk out/OptimisticList_1.out
$(OPT_OUT): out/OptimisticList_%.out: $(COLLECT) $(OPT_DEP)
	rm -rf out/OptimisticList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=out/OptimisticList_$*.dir.tmp $(OPT_SRC) \
  >out/OptimisticList_$*.out.tmp
	rm -rf out/OptimisticList_$*.dir
	mv out/OptimisticList_$*.out.tmp out/OptimisticList_$*.out
	mv out/OptimisticList_$*.dir.tmp out/OptimisticList_$*.dir

# Ex: make -f lists.mk out/OptimisiticList_S1.out
out/OptimisticList_S%.out: $(OPT_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(OPT_ALL) $(LIST_SCHED_$*) >out/OptimisticList_S$*.out


## LazyList

LAZY = $(LIST_DIR)/LazyList.cvl
LAZY_SRC = $(LAZY) $(HASH_SRC) $(LOCK_SRC)
LAZY_ALL = $(LIST_SRC) $(LAZY_SRC) $(NBSET_OR)
LAZY_DEP = $(LAZY_ALL) $(LIST_INC) $(HASH_INC) $(LOCK_INT)
LAZY_OUT = $(addprefix out/LazyList_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk out/LazyList_1.out
$(LAZY_OUT): out/LazyList_%.out: $(COLLECT) $(LAZY_DEP)
	rm -rf out/LazyList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=out/LazyList_$*.dir.tmp $(LAZY_SRC) \
  >out/LazyList_$*.out.tmp
	rm -rf out/LazyList_$*.dir
	mv out/LazyList_$*.out.tmp out/LazyList_$*.out
	mv out/LazyList_$*.dir.tmp out/LazyList_$*.dir

# Ex: make -f lists.mk out/LazyList_S1.out
out/LazyList_S%.out: $(LAZY_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(LAZY_ALL) $(LIST_SCHED_$*) >out/LazyList_S$*.out


## LockFreeList (Nonblocking list)

LOCKFREE = $(LIST_DIR)/LockFreeList.cvl
LOCKFREE_SRC = $(LOCKFREE) $(HASH_SRC) $(AMR_SRC)
LOCKFREE_ALL = $(LIST_SRC) $(LOCKFREE_SRC) $(NBSET_OR)
LOCKFREE_DEP = $(LOCKFREE_ALL) $(LIST_INC) $(HASH_INC) $(AMR_INC)
LOCKFREE_OUT = $(addprefix out/LockFreeList_,$(addsuffix .out,A B C D E))
LOCKFREEORG_OUT = $(addprefix out/LockFreeListOriginal_,$(addsuffix .out,A B C D E))

# Ex: make -f lists.mk out/LockFreeList_1.out
$(LOCKFREE_OUT): out/LockFreeList_%.out: $(COLLECT) $(LOCKFREE_DEP)
	rm -rf out/LockFreeList_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking -checkMemoryLeak=false \
  -tmpDir=out/LockFreeList_$*.dir.tmp $(LOCKFREE_SRC) \
  >out/LockFreeList_$*.out.tmp
	rm -rf out/LockFreeList_$*.dir
	mv out/LockFreeList_$*.out.tmp out/LockFreeList_$*.out
	mv out/LockFreeList_$*.dir.tmp out/LockFreeList_$*.dir

# Ex: make -f lists.mk out/LockFreeListOriginal_1.out
$(LOCKFREEORG_OUT): out/LockFreeListOriginal_%.out: $(COLLECT) $(LOCKFREE_DEP)
	rm -rf out/LockFreeListOriginal_$*.dir.tmp
	-$(COLLECT) $(LIST_BOUND_$*) -spec=nonblocking \
  -checkMemoryLeak=false -DORIGINAL \
  -tmpDir=out/LockFreeListOriginal_$*.dir.tmp $(LOCKFREE_SRC) \
  >out/LockFreeListOriginal_$*.out.tmp
	rm -rf out/LockFreeListOriginal_$*.dir
	mv out/LockFreeListOriginal_$*.out.tmp out/LockFreeListOriginal_$*.out
	mv out/LockFreeListOriginal_$*.dir.tmp out/LockFreeListOriginal_$*.dir

# Ex: make -f lists.mk out/LockFreeList_S1.out
out/LockFreeList_S%.out: $(LOCKFREE_DEP) $(LIST_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  $(LOCKFREE_ALL) $(LIST_SCHED_$*) >out/LockFreeList_S$*.out

# Ex: make -f lists.mk out/LockFreeListOriginal_S1.out
out/LockFreeListOriginal_S%.out: $(LOCKFREET_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -DORIGINAL $(LOCKFREE_ALL) $(LIST_SCHED_$*) >out/LockFreeListOriginal_S$*.out
