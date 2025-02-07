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
