# This Makefile illustrates some typical use cases of collect.
# Try "make CoarseList" or "make BoundedQueue" or "make SimpleTree"
# to see it in action.

ROOT=..
include $(ROOT)/common.mk

all: CoarseList BoundedQueue SimpleTree

# 124 schedules verified...
CoarseList: CoarseList.cvl
	$(COLLECT) -kind=set -spec=nonblocking -property=linear \
  -tmpDir=out/CoarseList -valueBound=2 -nthread=1..2 -nstep=1..2 -threadSym CoarseList.cvl \
  $(UTIL)/ReentrantLock.cvl $(UTIL)/hash.cvl

# 29 schedules verify...
BoundedQueue: BoundedQueue.cvl
	$(COLLECT) -kind=queue -spec=bounded -property=linear \
  -tmpDir=out/BoundedQueue -valueBound=2 -nthread=1..3 -nstep=1..3 -threadSym \
  -npreAdd=0 -checkMemoryLeak=false \
  -capacity=2 BoundedQueue.cvl $(UTIL)/ReentrantLock.cvl $(UTIL)/AtomicInteger.cvl \
  $(UTIL)/Condition_dl.cvl

# violation detected...
SimpleTree: SimpleTree.cvl
	$(COLLECT) -kind=pqueue -spec=nonblocking -property=quiescent \
  -tmpDir=out/SimpleTree -nthread=2 -npreAdd=1 -nstep=3 -distinctPriorities \
  -DLOGRANGE=2 SimpleTree.cvl \
  $(UTIL)/AtomicInteger.cvl $(UTIL)/ArrayList.cvl $(UTIL)/Bin.cvl

clean:
	rm -rf out/* CIVLREP AVREP* *~

.PHONY: CoarseList SimpleTree BoundedQueue clean
