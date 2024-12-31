ROOT = ../..
include $(ROOT)/common.mk

all: SkipQueue SkipQueuePatched FineGrainedHeap

# non-termination (cycle) detected...
SkipQueue: SkipQueue.cvl $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkTermination=true -D_SKIP_QUEUE_MAIN \
  -checkMemoryLeak=false SkipQueue.cvl $(AMR_SRC) $(AB_SRC) $(TID_SRC)

SkipQueuePatched: SkipQueue.cvl $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -checkTermination=true -D_PATCH_SKIPQUEUE \
  -D_SKIP_QUEUE_MAIN -checkMemoryLeak=false SkipQueue.cvl \
  $(AMR_SRC) $(AB_SRC) $(TID_SRC)

FineGrainedHeap: FineGrainedHeap.cvl $(LOCK_INC) $(FAIRLOCK_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -fair -checkTermination=true -D_FINE_GRAINED_HEAP_MAIN \
  FineGrainedHeap.cvl $(FAIRLOCK_SRC) $(TID_SRC)

.PHONY: SkipQueue SkipQueuePatched FineGrainedHeap
