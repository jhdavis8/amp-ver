# ------------------------------------------------------------------------------------
# AMPVer: A CIVL Model-Checking Verification Framework for Concurrent Data
# Structures
#
# This is the Makefile for AMPVer.
# ------------------------------------------------------------------------------

ROOT = .
include $(ROOT)/common.mk

all: test

test:
	$(MAKE) -C $(DRIVER_DIR)
	$(MAKE) -C $(QUEUE_DIR)
	$(MAKE) -C $(SET_DIR)
	$(MAKE) -C $(LIST_DIR)
	$(MAKE) -C $(PQUEUE_DIR)

.PHONY: all test
