ROOT = ../..
include $(ROOT)/common.mk

all: UnboundedQueue LockFreeQueue

UnboundedQueue: UnboundedQueue.cvl $(LOCK_INC) $(LOCK_SRC)
	$(VERIFY) -D_UNBOUNDED_QUEUE_MAIN UnboundedQueue.cvl $(LOCK_SRC)

LockFreeQueue: LockFreeQueue.cvl $(AR_INC) $(AR_SRC)
	$(VERIFY) -checkMemoryLeak=false -D_LOCK_FREE_QUEUE_MAIN \
          LockFreeQueue.cvl $(AR_SRC)


.PHONY: UnboundedQueue LockFreeQueue
