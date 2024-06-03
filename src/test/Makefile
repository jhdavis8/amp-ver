ROOT = ../..
include $(ROOT)/common.mk

UTIL = $(SRC)/util

all: verify

verify: ConditionTest.cvl
	$(VERIFY) ConditionTest.cvl $(LOCK_SRC) $(UTIL)/Condition.cvl $(UTIL)/tid.cvl

.PHONY: all verify
