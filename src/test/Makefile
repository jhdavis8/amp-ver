# Filename : Makefile (test)
# Author   : Stephen F. Siegel
# Created  : 2024-06-03
# Modified : 2025-01-17

# Runs a few tests of utility modules.

ROOT = ../..
include $(ROOT)/common.mk

UTIL = $(SRC)/util

all: cond tid

cond: ConditionTest.cvl
	$(VERIFY) -checkTermination ConditionTest.cvl \
  $(LOCK_SRC) $(UTIL)/Condition.cvl $(UTIL)/tid.cvl

tid: tidTest.cvl
	$(VERIFY) -checkTermination tidTest.cvl $(UTIL)/tid.cvl

.PHONY: all cond tid
