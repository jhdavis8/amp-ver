ROOT = ../..
include $(ROOT)/common.mk

all: SimpleLinear SimpleTree SkipQueue SkipQueuePatched FineGrainedHeap

SimpleLinear: SimpleLinear.cvl $(BIN_INC) $(BIN_SRC) \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -DRANGE=3 -checkTermination=true -D_SIMPLE_LINEAR \
  SimpleLinear.cvl $(BIN_SRC) $(ARRAYLIST_SRC) $(TID_SRC)

SimpleTree: SimpleTree.cvl $(BIN_INC) $(BIN_SRC) \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(TID_INC) $(TID_SRC) \
  $(AI_INC) $(AI_SRC)
	$(VERIFY) -DLOGRANGE=2 -checkTermination=true -checkMemoryLeak=true -D_SIMPLE_TREE \
  SimpleTree.cvl $(BIN_SRC) $(ARRAYLIST_SRC) $(TID_SRC) $(AI_SRC)

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

.PHONY: SimpleLinear SimpleTree SkipQueue SkipQueuePatched FineGrainedHeap
