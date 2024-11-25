ROOT = .

#############################  Priority Queues  ############################

PQUEUE_LIMITS_1 = -kind=pqueue -genericVals -threadSym -nthread=1..2 \
     -nstep=1..2 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_2 = -kind=pqueue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_3 = -kind=pqueue -genericVals -threadSym -nthread=1..3 \
     -nstep=1..3 -npreAdd=1..3 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_4 = -kind=pqueue -genericVals -threadSym -nthread=3 \
     -nstep=4 -npreAdd=0 -distinctPriorities -addsDominate -ncore=$(NCORE)

PQUEUE_LIMITS_5 = -kind=pqueue -genericVals -threadSym -nthread=3 \
     -nstep=4 -npreAdd=1 -distinctPriorities -addsDominate -ncore=1 -dryrun

PQUEUE_COMMON_DEP = $(DRIVER_INC) $(DRIVER_NB_SRC) $(DRIVER_PQUEUE_NB) Makefile
PQUEUE_COMMON_SRC = $(DRIVER_NB_SRC) $(DRIVER_PQUEUE_NB)

PQUEUE_SCHED_1 = $(SCHEDULE_DIR)/sched_pqueue_1.cvl
PQUEUE_SCHED_2 = $(SCHEDULE_DIR)/sched_pqueue_2.cvl
PQUEUE_SCHED_3 = $(SCHEDULE_DIR)/sched_pqueue_3.cvl

pqueue_1 pqueue_2 pqueue_3 pqueue_4: pqueue_%: out/FineGrainedHeap_%.out \
	out/FineGrainedHeapFair_%.out out/FineGrainedHeapNoCycles_%.out \
	out/SkipQueue_%.out out/SkipQueuePatched_%.out

pqueue_schedules: out/FineGrainedHeap_S1 out/FineGrainedHeap_S2 out/FineGrainedHeap_S3 \
	out/FineGrainedHeapFair_S1 out/FineGrainedHeapFair_S2 out/FineGrainedHeapFair_S3 \
	out/FineGrainedHeapNoCycles_S1 out/FineGrainedHeapNoCycles_S2 out/FineGrainedHeapNoCycles_S3 \
	out/SkipQueue_S1 out/SkipQueue_S2 out/SkipQueue_S3 \
	out/SkipQueuePatched_S1 out/SkipQueuePatched_S2 out/SkipQueuePatched_S3

# FineGrainedHeap

FINEGRAINEDHEAP = $(PQUEUE_DIR)/FineGrainedHeap.cvl
FINEGRAINEDHEAP_DEP = $(PQUEUE_COMMON_DEP) $(FINEGRAINEDHEAP) $(LOCK_INC) $(LOCK_SRC)
FINEGRAINEDHEAP_SRC =  $(PQUEUE_COMMON_SRC) $(FINEGRAINEDHEAP) $(LOCK_SRC)
FINEGRAINEDHEAPFAIR_DEP = $(PQUEUE_COMMON_DEP) $(FINEGRAINEDHEAP) $(LOCK_INC) $(FAIRLOCK_SRC)
FINEGRAINEDHEAPFAIR_SRC =  $(PQUEUE_COMMON_SRC) $(FINEGRAINEDHEAP) $(FAIRLOCK_SRC)
FineGrainedHeap_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeap_,1 2 3 4))
FineGrainedHeapFair_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeapFair_,1 2 3 4))
FineGrainedHeapNoCycles_Outs = $(addsuffix .out,$(addprefix out/FineGrainedHeapNoCycles_,1 2 3 4))

$(FineGrainedHeap_Outs): out/FineGrainedHeap_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP)
	rm -rf $(TMP)/FineGrainedHeap_$*.dir.tmp
	rm -rf out/FineGrainedHeap_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -fair -checkTermination -tmpDir=$(TMP)/FineGrainedHeap_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(LOCK_SRC) \
          >$(TMP)/FineGrainedHeap_$*.out.tmp
	mv $(TMP)/FineGrainedHeap_$*.out.tmp out/FineGrainedHeap_$*.out
	mv $(TMP)/FineGrainedHeap_$*.dir.tmp out/FineGrainedHeap_$*.dir

$(FineGrainedHeapNoCycles_Outs): out/FineGrainedHeapNoCycles_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP)
	rm -rf $(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp
	rm -rf out/FineGrainedHeapNoCycles_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -tmpDir=$(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(LOCK_SRC) \
          >$(TMP)/FineGrainedHeapNoCycles_$*.out.tmp
	mv $(TMP)/FineGrainedHeapNoCycles_$*.out.tmp out/FineGrainedHeapNoCycles_$*.out
	mv $(TMP)/FineGrainedHeapNoCycles_$*.dir.tmp out/FineGrainedHeapNoCycles_$*.dir

$(FineGrainedHeapFair_Outs): out/FineGrainedHeapFair_%.out: $(MAIN_CLASS) $(FINEGRAINEDHEAP_DEP) $(FAIRLOCK_SRC)
	rm -rf $(TMP)/FineGrainedHeapFair_$*.dir.tmp
	rm -rf out/FineGrainedHeapFair_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -fair -checkTermination -tmpDir=$(TMP)/FineGrainedHeapFair_$*.dir.tmp \
          $(FINEGRAINEDHEAP) $(FAIRLOCK_SRC) \
          >$(TMP)/FineGrainedHeapFair_$*.out.tmp
	mv $(TMP)/FineGrainedHeapFair_$*.out.tmp out/FineGrainedHeapFair_$*.out
	mv $(TMP)/FineGrainedHeapFair_$*.dir.tmp out/FineGrainedHeapFair_$*.dir

out/FineGrainedHeap_S%: $(FINEGRAINEDHEAP_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(FINEGRAINEDHEAP_SRC) $(PQUEUE_SCHED_$*) \
          >out/FineGrainedHeap_S$*

out/FineGrainedHeapNoCycles_S%: $(FINEGRAINEDHEAP_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false $(FINEGRAINEDHEAP_SRC) $(PQUEUE_SCHED_$*) \
          >out/FineGrainedHeapNoCycles_S$*

out/FineGrainedHeapFair_S%: $(FINEGRAINEDHEAPFAIR_DEP) $(PQUEUE_SCHED_$*)
	$(VERIFY) -checkMemoryLeak=false -checkTermination=true -fair $(FINEGRAINEDHEAPFAIR_SRC) $(PQUEUE_SCHED_$*) \
					>out/FineGrainedHeapFair_S$*

# SkipQueue

SKIPQUEUE = $(PQUEUE_DIR)/SkipQueue.cvl
SKIPQUEUE_DEP = $(PQUEUE_COMMON_DEP) $(SKIPQUEUE) $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC)
SKIPQUEUE_SRC =  $(PQUEUE_COMMON_SRC) $(SKIPQUEUE) $(AMR_SRC) $(AB_SRC)
SkipQueue_Outs = $(addsuffix .out,$(addprefix out/SkipQueue_,1 2 3 4))
SkipQueuePatched_Outs = $(addsuffix .out,$(addprefix out/SkipQueuePatched_,1 2 3 4 5))

$(SkipQueue_Outs): out/SkipQueue_%.out: $(MAIN_CLASS) $(SKIPQUEUE_DEP)
	rm -rf $(TMP)/SkipQueue_$*.dir.tmp
	rm -rf out/SkipQueue_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -checkTermination -linear=false -checkMemoryLeak=false \
          -tmpDir=$(TMP)/SkipQueue_$*.dir.tmp \
          $(SKIPQUEUE) $(AMR_SRC) $(AB_SRC) \
          >$(TMP)/SkipQueue_$*.out.tmp
	mv $(TMP)/SkipQueue_$*.out.tmp out/SkipQueue_$*.out
	mv $(TMP)/SkipQueue_$*.dir.tmp out/SkipQueue_$*.dir

SKIPQUEUEPATCHED = $(PQUEUE_DIR)/SkipQueuePatched.cvl
SKIPQUEUEPATCHED_DEP = $(PQUEUE_COMMON_DEP) $(SKIPQUEUEPATCHED) $(AMR_INC) $(AMR_SRC) $(AB_INC) $(AB_SRC)
SKIPQUEUEPATCHED_SRC =  $(PQUEUE_COMMON_SRC) $(SKIPQUEUEPATCHED) $(AMR_SRC) $(AB_SRC)

$(SkipQueuePatched_Outs): out/SkipQueuePatched_%.out: $(MAIN_CLASS) $(SKIPQUEUEPATCHED_DEP)
	rm -rf $(TMP)/SkipQueuePatched_$*.dir.tmp
	rm -rf out/SkipQueuePatched_$*.dir
	-$(AMPVER) $(PQUEUE_LIMITS_$*) -checkTermination -linear=false -checkMemoryLeak=false \
	        -tmpDir=$(TMP)/SkipQueuePatched_$*.dir.tmp \
          $(SKIPQUEUEPATCHED) $(AMR_SRC) $(AB_SRC) \
          >$(TMP)/SkipQueuePatched_$*.out.tmp
	mv $(TMP)/SkipQueuePatched_$*.out.tmp out/SkipQueuePatched_$*.out
	mv $(TMP)/SkipQueuePatched_$*.dir.tmp out/SkipQueuePatched_$*.dir

out/SkipQueue_S%: $(SKIPQUEUE_DEP) $(PQUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR $(SKIPQUEUE_SRC) $(PQUEUE_SCHED_$*) \
					>out/SkipQueue_S$*

out/SkipQueuePatched_S%: $(SKIPQUEUEPATCHED_DEP) $(PQUEUE_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true -DNLINEAR $(SKIPQUEUEPATCHED_SRC) $(PQUEUE_SCHED_$*) \
					>out/SkipQueuePatched_S$*
