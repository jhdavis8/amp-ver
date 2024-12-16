ROOT = ../..
include $(ROOT)/common.mk

all: UnboundedQueue LockFreeQueue

UnboundedQueue: UnboundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_UNBOUNDED_QUEUE_MAIN UnboundedQueue.cvl $(LOCK_SRC) $(TID_SRC)

LockFreeQueue: LockFreeQueue.cvl $(AR_INC) $(AR_SRC)
	$(VERIFY) -checkMemoryLeak=false -D_LOCK_FREE_QUEUE_MAIN \
          LockFreeQueue.cvl $(AR_SRC)

BoundedQueue: BoundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
		$(COND2_INC) $(COND2_SRC) $(TID_INC) $(TID_SRC) $(AI_INC) $(AI_SRC)
	$(VERIFY) -checkMemoryLeak=false -enablePrintf=false -D_BOUNDED_QUEUE_MAIN BoundedQueue.cvl $(LOCK_SRC) $(COND2_SRC) $(TID_SRC) $(AI_SRC)

SynchronousDualQueue: SynchronousDualQueue.cvl $(AI_INC) $(AI_SRC) \
   $(AR_INC) $(AR_SRC) $(TID_H) $(TID_SRC)
	$(VERIFY) -min -enablePrintf=false -checkMemoryLeak=false -D_SYNCHRONOUS_DUAL_QUEUE \
   SynchronousDualQueue.cvl $(AI_SRC) $(AR_SRC) $(TID_SRC)


.PHONY: UnboundedQueue LockFreeQueue
