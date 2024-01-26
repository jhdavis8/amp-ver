ROOT = ..
include $(ROOT)/common.mk
JSRC=$(JROOT)/src/ampver/av
SOURCES = $(JROOT)/src/ampver/module-info.java \
    $(JSRC)/AMPVer.java \
    $(JSRC)/Step.java \
    $(JSRC)/Schedule.java \
    $(JSRC)/SetScheduleIterator.java \
    $(JSRC)/QueueScheduleIterator.java \
    $(JSRC)/PQScheduleIterator.java \
    $(JSRC)/AVUtil.java

all: $(MAIN_CLASS)

$(MAIN_CLASS): $(SOURCES)
	$(JAVAC) -d $(JROOT)/bin/ampver -p $(CIVL_ROOT)/mods/dev.civl.mc/bin $(SOURCES)

test0: $(MAIN_CLASS)
	$(JAVA) -ea -p $(MOD_PATH) -m ampver/av.AVUtil

test_set_iter: $(MAIN_CLASS)
	$(JAVA) -p $(MOD_PATH) -m ampver/av.SetScheduleIterator

test_pq_iter: $(MAIN_CLASS)
	$(JAVA) -p $(MOD_PATH) -m ampver/av.PQScheduleIterator

test_queue_iter: $(MAIN_CLASS)
	$(JAVA) -p $(MOD_PATH) -m ampver/av.QueueScheduleIterator

test2: $(MAIN_CLASS)
	rm -rf SDIR2.tmp
	time $(JAVA) -p $(MOD_PATH) -m ampver/av.AMPVer -root=$(ROOT) \
          -ncore=4 \
          -kind=pqueue \
          -checkMemoryLeak=false \
          -nthread=1..2 \
          -nstep=1..3 \
          -npreAdd=0 \
          -tmpDir=SDIR2.tmp \
          $(ROOT)/src/pqueue/SkipQueue.cvl \
          $(ROOT)/src/util/AtomicMarkableReference.cvl

# 1096 schedules
test3: $(MAIN_CLASS)
	rm -rf SDIR3.tmp
	time $(JAVA) -Xmx15g -p $(MOD_PATH) -m ampver/av.AMPVer -root=$(ROOT) \
          -ncore=1 \
          -kind=pqueue \
          -checkMemoryLeak=false \
          -nthread=3 \
          -nstep=4 \
          -npreAdd=1 \
          -linear=false \
          -tmpDir=SDIR3.tmp \
          -genericVals -distinctPriorities -addsDominate -threadSym \
          $(ROOT)/src/pqueue/SkipQueue.cvl \
          $(ROOT)/src/util/AtomicMarkableReference.cvl

test4: $(MAIN_CLASS)
	rm -rf SDIR4.tmp
	time $(JAVA) -p $(MOD_PATH) -m ampver/av.AMPVer -root=$(ROOT) \
          -kind=set \
          -hashKind=ident \
          -valueBound=3 \
          -nthread=2 \
          -nstep=2..3 \
          -npreAdd=0 \
          -tmpDir=SDIR4.tmp \
          -threadSym \
          $(ROOT)/src/hashset/CoarseHashSet.cvl \
          $(ROOT)/src/util/ArrayList.cvl \
          $(ROOT)/src/util/ReentrantLock.cvl \
          $(ROOT)/src/util/hash.cvl

# -hashKind=nd -hashDomainBound=3 -hashRangeBound=2

test5: $(MAIN_CLASS)
	rm -rf SDIR5.tmp
	$(JAVA) -p $(MOD_PATH) -m ampver/av.AMPVer -root=$(ROOT) \
          -kind=queue \
          -nthread_lo=2 -nthread_hi=2 \
          -nstep_lo=2 -nstep_hi=3 \
          -npreAdd_lo=0 -npreAdd_hi=1 \
          -tmpDir=SDIR5.tmp \
          -genericVals -addsDominate -threadSym \
          $(ROOT)/src/queue/UnboundedQueue.cvl \
          $(ROOT)/src/util/ReentrantLock.cvl


clean::
	rm -rf $(JROOT)/bin/*

.PHONY: all test0 test_set_iter test_pq_iter test_queue_iter \
  test2 test3 test4 test5 clean
