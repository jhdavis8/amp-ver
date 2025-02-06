# Common Makefile elements.
# Make sure ROOT is defined before including this file.
# ROOT should be a path to the root directory of the distribution.
CONFIGS = $(ROOT)/config
ifneq ("$(wildcard $(CONFIGS)/config.mk)","")
CONFIG = $(CONFIGS)/config.mk
else
CONFIG = $(CONFIGS)/config_default.mk
endif
include $(CONFIG)

# Important subdirectories
JSRC=$(ROOT)/java/src/ampver/av
SOURCES = \
    $(JSRC)/AMPVer.java \
    $(JSRC)/Step.java \
    $(JSRC)/Schedule.java \
    $(JSRC)/SetScheduleIterator.java \
    $(JSRC)/QueueScheduleIterator.java \
    $(JSRC)/PQScheduleIterator.java \
    $(JSRC)/AVUtil.java
COLLECT=$(ROOT)/bin/$(COLLECT_BIN)
UTIL = $(ROOT)/src/util
DRIVER = $(ROOT)/src/driver
INC = $(ROOT)/include

# Important files
SET_H = $(INC)/Set.h
QUEUE_H = $(INC)/Queue.h
PQUEUE_H = $(INC)/PQueue.h
AR_INC = $(INC)/AtomicReference.cvh
AR_SRC = $(UTIL)/AtomicReference.cvl
AMR_INC = $(INC)/AtomicMarkableReference.cvh
AMR_SRC = $(UTIL)/AtomicMarkableReference.cvl
AB_INC = $(INC)/AtomicBoolean.cvh
AB_SRC = $(UTIL)/AtomicBoolean.cvl
AI_INC = $(INC)/AtomicInteger.h
AI_SRC = $(UTIL)/AtomicInteger.cvl
BIN_INC = $(INC)/Bin.h
BIN_SRC = $(UTIL)/Bin.cvl
COND_INC = $(INC)/Condition.h
COND_SRC = $(UTIL)/Condition.cvl
COND2_INC = $(INC)/Condition_dl.h
COND2_SRC = $(UTIL)/Condition_dl.cvl
TID_INC = $(INC)/tid.h
TID_SRC = $(UTIL)/tid.cvl
HASH_INC = $(INC)/hash.cvh
HASH_SRC = $(UTIL)/hash.cvl
LOCK_INC = $(INC)/Lock.h
LOCK_SRC = $(UTIL)/ReentrantLock.cvl
FAIRLOCK_SRC = $(UTIL)/FairReentrantLock.cvl
ARRAYLIST_INC = $(INC)/ArrayList.h
ARRAYLIST_SRC = $(UTIL)/ArrayList.cvl
NPD_INC = $(INC)/NPDetector.cvh
NPD_SRC = $(UTIL)/NPDetector.cvl
DRIVER_INC = $(INC)/driver.h $(INC)/perm.h $(INC)/schedule.h $(INC)/types.h \
  $(INC)/tid.h $(INC)/collection.h $(INC)/oracle.h
DRIVER_SRC = $(DRIVER)/driver.cvl $(DRIVER)/perm.c \
  $(DRIVER)/schedule.cvl $(UTIL)/tid.cvl
DRIVERQ_SRC = $(DRIVER)/driver_q.cvl $(DRIVER)/perm.c \
  $(DRIVER)/schedule.cvl $(UTIL)/tid.cvl
