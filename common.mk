# Common definitions.  ROOT should be defined before loading this file.
# This file should not need to be modified.   Local modifications should
# go in config/config.mk.

# If there is a file named config.mk in directory config, load it.
# Otherwise, load config_default.mk...
CONFIGS = $(ROOT)/config
ifneq ("$(wildcard $(CONFIGS)/config.mk)","")
CONFIG = $(CONFIGS)/config.mk
else
CONFIG = $(CONFIGS)/config_default.mk
endif
include $(CONFIG)

# Important subdirectories
SRC = $(ROOT)/src
INC = $(ROOT)/include
DRIVER_DIR = $(SRC)/driver
SET_DIR = $(SRC)/hashset
LIST_DIR = $(SRC)/list
QUEUE_DIR = $(SRC)/queue
PQUEUE_DIR = $(SRC)/pqueue
SCHEDULE_DIR = $(SRC)/schedule

# Important files
SET_H = $(INC)/Set.h
QUEUE_H = $(INC)/Queue.h
PQUEUE_H = $(INC)/PQueue.h
AR_INC = $(INC)/AtomicReference.cvh
AR_SRC = $(SRC)/util/AtomicReference.cvl
AMR_INC = $(INC)/AtomicMarkableReference.cvh
AMR_SRC = $(SRC)/util/AtomicMarkableReference.cvl
AB_INC = $(INC)/AtomicBoolean.cvh
AB_SRC = $(SRC)/util/AtomicBoolean.cvl
AI_INC = $(INC)/AtomicInteger.h
AI_SRC = $(SRC)/util/AtomicInteger.cvl
BIN_INC = $(INC)/Bin.h
BIN_SRC = $(SRC)/util/Bin.cvl
COND_INC = $(INC)/Condition.h
COND_SRC = $(SRC)/util/Condition.cvl
COND2_INC = $(INC)/Condition_dl.h
COND2_SRC = $(SRC)/util/Condition_dl.cvl
TID_INC = $(INC)/tid.h
TID_SRC = $(SRC)/util/tid.cvl
HASH_INC = $(INC)/hash.cvh
HASH_SRC = $(SRC)/util/hash.cvl
LOCK_INC = $(INC)/Lock.h
LOCK_SRC = $(SRC)/util/ReentrantLock.cvl
FAIRLOCK_SRC = $(SRC)/util/FairReentrantLock.cvl
ARRAYLIST_INC = $(INC)/ArrayList.h
ARRAYLIST_SRC = $(SRC)/util/ArrayList.cvl
NPD_INC = $(INC)/NPDetector.cvh
NPD_SRC = $(SRC)/util/NPDetector.cvl
DRIVER_INC = $(INC)/driver.h $(INC)/perm.h $(INC)/schedule.h $(INC)/types.h \
  $(INC)/tid.h $(INC)/collection.h $(INC)/oracle.h
DRIVER_SRC = $(DRIVER_DIR)/driver.cvl $(DRIVER_DIR)/perm.c \
  $(DRIVER_DIR)/schedule.cvl $(SRC)/util/tid.cvl
DRIVERQ_SRC = $(DRIVER_DIR)/driver_q.cvl $(DRIVER_DIR)/perm.c \
  $(DRIVER_DIR)/schedule.cvl $(SRC)/util/tid.cvl

# Collection kinds: wrap any kind of collection into one interface
SET_COL = $(DRIVER_DIR)/set_collection.cvl
QUEUE_COL = $(DRIVER_DIR)/queue_collection.cvl
PQUEUE_COL = $(DRIVER_DIR)/pqueue_collection.cvl

# Oracles: specify expected behavior
NBSET_OR = $(DRIVER_DIR)/nonblocking_set_oracle.cvl
NBQUEUE_OR = $(DRIVER_DIR)/nonblocking_queue_oracle.cvl
BQUEUE_OR = $(DRIVER_DIR)/bounded_queue_oracle.cvl
SQUEUE_OR = $(DRIVER_DIR)/sync_queue_oracle.cvl
NBPQUEUE_OR = $(DRIVER_DIR)/nonblocking_pqueue_oracle.cvl

# Verification commands
VERIFY = $(CIVL) verify -userIncludePath=$(INC)
JROOT = $(ROOT)/java
JSRC=$(JROOT)/src/ampver/av
MOD_PATH = $(JROOT)/bin:$(CIVL_ROOT)/mods/dev.civl.mc/bin:$(CIVL_ROOT)/mods/dev.civl.abc/bin:$(CIVL_ROOT)/mods/dev.civl.sarl/bin:$(CIVL_ROOT)/mods/dev.civl.gmc/bin:$(VSL_DEPS)/mods/antlr3:$(VSL_DEPS)/mods/antlr4
MAIN_CLASS = $(JROOT)/bin/ampver/av/AMPVer.class
AMPVER = $(JAVA) -p $(MOD_PATH) -m ampver/av.AMPVer -root=$(ROOT)
SOURCES = $(JROOT)/src/ampver/module-info.java \
  $(JSRC)/AMPVer.java \
  $(JSRC)/Step.java \
  $(JSRC)/Schedule.java \
  $(JSRC)/SetScheduleIterator.java \
  $(JSRC)/QueueScheduleIterator.java \
  $(JSRC)/PQScheduleIterator.java \
  $(JSRC)/AVUtil.java

# New global bound settings
BOUND_A = -hashKind=ident -valueBound=2 -nthread=1..2 -nstep=1..2 -npreAdd=0 \
  -checkTermination -ncore=$(NCORE)
BOUND_B = -hashKind=ident -valueBound=3 -nthread=1..2 -nstep=1..2 -npreAdd=0..1 \
  -checkTermination -ncore=$(NCORE)
BOUND_C = -hashKind=nd -valueBound=3 -nthread=1..2 -nstep=1..2 -npreAdd=0..1 \
  -checkTermination -ncore=$(NCORE) -hashRangeBound=2 -hashDomainBound=3
BOUND_D = -hashKind=ident -valueBound=4 -nthread=1..3 -nstep=1..3 -npreAdd=0..1 \
  -checkTermination -ncore=$(NCORE)
BOUND_E = -hashKind=ident -valueBound=5 -nthread=1..3 -nstep=1..4 -npreAdd=0..1 \
  -checkTermination -ncore=$(NCORE) -preemptionBound=2

myall: all

$(MAIN_CLASS): $(SOURCES)
	$(JAVAC) -d $(JROOT)/bin/ampver\
  -p $(CIVL_ROOT)/mods/dev.civl.mc/bin $(SOURCES)
