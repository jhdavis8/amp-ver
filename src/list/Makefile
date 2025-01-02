ROOT = ../..
include $(ROOT)/common.mk

all: CoarseList FineList OptimisticList LazyList LockFreeList

CoarseList: CoarseList.cvl $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_COARSE_LIST_MAIN -checkMemoryLeak=true \
  -checkTermination=true CoarseList.cvl $(HASH_SRC) $(LOCK_SRC) $(TID_SRC)

FineList: FineList.cvl $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_FINE_LIST_MAIN -checkMemoryLeak=true \
  -checkTermination=true FineList.cvl $(HASH_SRC) $(LOCK_SRC) $(TID_SRC)

OptimisticList: OptimisticList.cvl $(LOCK_INC) $(LOCK_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -D_OPTIMISTIC_LIST_MAIN OptimisticList.cvl $(HASH_SRC) $(LOCK_SRC) \
  $(TID_SRC)

LazyList: LazyList.cvl $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -D_LAZY_LIST_MAIN LazyList.cvl $(HASH_SRC) $(LOCK_SRC) $(TID_SRC)

LockFreeList: LockFreeList.cvl $(AMR_INC) $(AMR_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true \
  -D_LOCK_FREE_LIST_MAIN LockFreeList.cvl $(AMR_SRC) $(HASH_SRC) $(TID_SRC)

.PHONY: CoarseList FineList OptimisticList LazyList LockFreeList
