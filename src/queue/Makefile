ROOT = ../..
include $(ROOT)/common.mk

all: UnboundedQueue LockFreeQueue

UnboundedQueue: UnboundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -D_UNBOUNDED_QUEUE_MAIN UnboundedQueue.cvl $(LOCK_SRC) $(TID_SRC)

LockFreeQueue: LockFreeQueue.cvl $(AR_INC) $(AR_SRC)
	$(VERIFY) -checkMemoryLeak=false -D_LOCK_FREE_QUEUE_MAIN \
          LockFreeQueue.cvl $(AR_SRC)

BoundedQueue: BoundedQueue.cvl $(LOCK_INC) $(LOCK_SRC) \
		$(COND_INC) $(COND_SRC) $(TID_INC) $(TID_SRC) $(AI_INC) $(AI_SRC)
	$(VERIFY) -enablePrintf=false -D_BOUNDED_QUEUE_MAIN BoundedQueue.cvl $(LOCK_SRC) $(COND_SRC) $(TID_SRC) $(AI_SRC)


.PHONY: UnboundedQueue LockFreeQueue
