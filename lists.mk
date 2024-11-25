ROOT = .

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

LIST_COMMON_DEP = $(DRIVER_INC) $(DRIVER_NB_SRC) $(DRIVER_SET_NB) Makefile
LIST_COMMON_SRC = $(DRIVER_NB_SRC) $(DRIVER_SET_NB)

LIST_SCHED_1 = $(SCHEDULE_DIR)/sched_set_1.cvl
LIST_SCHED_2 = $(SCHEDULE_DIR)/sched_set_2.cvl
LIST_SCHED_3 = $(SCHEDULE_DIR)/sched_set_3.cvl

list_1 list_2 list_3 list_4: list_%: out/CoarseList_%.out \
  out/FineList_%.out out/OptimisticList_%.out out/LazyList_%.out \
  out/LockFreeList_%.out out/LockFreeListOriginal_%.out

list_schedules: out/CoarseList_S1 out/CoarseList_S2 out/CoarseList_S3 \
	out/FineList_S1 out/FineList_S2 out/FineList_S3 \
	out/OptimisticList_S1 out/OptimisticList_S2 out/OptimisticList_S3 \
	out/LazyList_S1 out/LazyList_S2 out/LazyList_S3 \
	out/LockFreeList_S1 out/LockFreeList_S2 out/LockFreeList_S3 \
	out/LockFreeListOriginal_S1 out/LockFreeListOriginal_S2 out/LockFreeListOriginal_S3

# CoarseList

COARSELIST = $(LIST_DIR)/CoarseList.cvl
COARSELIST_DEP = $(LIST_COMMON_DEP) $(COARSELIST) $(HASH_INC) $(HASH_SRC) \
     $(LOCK_INC) $(LOCK_SRC)
COARSELIST_SRC = $(LIST_COMMON_SRC) $(COARSELIST) $(HASH_SRC) $(LOCK_SRC)
CoarseList_Outs = $(addsuffix .out,$(addprefix out/CoarseList_,1 2 3 4))

$(CoarseList_Outs): out/CoarseList_%.out: $(MAIN_CLASS) $(COARSELIST_DEP)
	rm -rf $(TMP)/CoarseList_$*.dir.tmp
	rm -rf out/CoarseList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/CoarseList_$*.dir.tmp \
          $(COARSELIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/CoarseList_$*.out.tmp
	mv $(TMP)/CoarseList_$*.out.tmp out/CoarseList_$*.out
	mv $(TMP)/CoarseList_$*.dir.tmp out/CoarseList_$*.dir

out/CoarseList_S%: $(COARSELIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(COARSELIST_SRC) $(LIST_SCHED_$*) \
					>out/CoarseList_S$*

# FineList

FINELIST = $(LIST_DIR)/FineList.cvl
FINELIST_DEP =  $(LIST_COMMON_DEP) $(FINELIST) $(HASH_INC) $(HASH_SRC) \
     $(LOCK_INC) $(LOCK_SRC)
FINELIST_SRC = $(LIST_COMMON_SRC) $(FINELIST) $(HASH_SRC) $(LOCK_SRC)
FineList_Outs = $(addsuffix .out,$(addprefix out/FineList_,1 2 3 4))

$(FineList_Outs): out/FineList_%.out: $(MAIN_CLASS) $(FINELIST_DEP)
	rm -rf $(TMP)/FineList_$*.dir.tmp
	rm -rf out/FineList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/FineList_$*.dir.tmp \
          $(FINELIST) $(HASH_SRC) $(LOCK_SRC) \
          >$(TMP)/FineList_$*.out.tmp
	mv $(TMP)/FineList_$*.out.tmp out/FineList_$*.out
	mv $(TMP)/FineList_$*.dir.tmp out/FineList_$*.dir

out/FineList_S%: $(FINELIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(FINELIST_SRC) $(LIST_SCHED_$*) \
					>out/FineList_S$*

# OptimisticList

OPTIMISTICLIST = $(LIST_DIR)/OptimisticList.cvl
OPTIMISTICLIST_DEP = $(LIST_COMMON_DEP) $(OPTIMISTICLIST) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC)
OPTIMISTICLIST_SRC = $(LIST_COMMON_SRC) $(OPTIMISTICLIST) $(HASH_SRC) $(LOCK_SRC)
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

out/OptimisticList_S%: $(OPTIMISTICLIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(OPTIMISTICLIST_SRC) $(LIST_SCHED_$*) \
					>out/OptimisticList_S$*

# LazyList

LAZYLIST = $(LIST_DIR)/LazyList.cvl
LAZYLIST_DEP = $(LIST_COMMON_DEP) $(LAZYLIST) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC)
LAZYLIST_SRC = $(LIST_COMMON_SRC) $(LAZYLIST) $(HASH_SRC) $(LOCK_SRC)
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

out/LazyList_S%: $(LAZYLIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(LAZYLIST_SRC) $(LIST_SCHED_$*) \
					>out/LazyList_S$*

# LockFreeList (Nonblocking list)

LOCKFREELIST = $(LIST_DIR)/LockFreeList.cvl
LOCKFREELIST_DEP = $(LIST_COMMON_DEP) $(LOCKFREELIST) \
     $(HASH_INC) $(HASH_SRC) $(AMR_INC) $(AMR_SRC)
LOCKFREELIST_SRC = $(LIST_COMMON_SRC) $(LOCKFREELIST) $(HASH_SRC) $(AMR_SRC)
LockFreeList_Outs = $(addsuffix .out,$(addprefix out/LockFreeList_,1 2 3 4))
LockFreeListOriginal_Outs = $(addsuffix .out,$(addprefix out/LockFreeListOriginal_,1 2 3 4))

$(LockFreeList_Outs): out/LockFreeList_%.out: $(MAIN_CLASS) $(LOCKFREELIST_DEP)
	rm -rf $(TMP)/LockFreeList_$*.dir.tmp
	rm -rf out/LockFreeList_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/LockFreeList_$*.dir.tmp \
          -checkMemoryLeak=false \
          $(LOCKFREELIST) $(HASH_SRC) $(AMR_SRC) \
          >$(TMP)/LockFreeList_$*.out.tmp
	mv $(TMP)/LockFreeList_$*.out.tmp out/LockFreeList_$*.out
	mv $(TMP)/LockFreeList_$*.dir.tmp out/LockFreeList_$*.dir

$(LockFreeListOriginal_Outs): out/LockFreeListOriginal_%.out: $(MAIN_CLASS) $(LOCKFREELIST_DEP)
	rm -rf $(TMP)/LockFreeListOriginal_$*.dir.tmp
	rm -rf out/LockFreeListOriginal_$*.dir
	-$(AMPVER) $(LIST_LIMITS_$*) -tmpDir=$(TMP)/LockFreeListOriginal_$*.dir.tmp \
          -checkMemoryLeak=false -DORIGINAL \
          $(LOCKFREELIST) $(HASH_SRC) $(AMR_SRC) \
          >$(TMP)/LockFreeListOriginal_$*.out.tmp
	mv $(TMP)/LockFreeListOriginal_$*.out.tmp out/LockFreeListOriginal_$*.out
	mv $(TMP)/LockFreeListOriginal_$*.dir.tmp out/LockFreeListOriginal_$*.dir

out/LockFreeList_S%: $(LOCKFREELIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(LOCKFREELIST_SRC) $(LIST_SCHED_$*) \
					>out/LockFreeList_S$*

out/LockFreeListOriginal_S%: $(LOCKFREELIST_DEP) $(LIST_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DORIGINAL $(LOCKFREELIST_SRC) $(LIST_SCHED_$*) \
					>out/LockFreeListOriginal_S$*
