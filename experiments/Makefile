# ------------------------------------------------------------------------------------
# AMPVer: A CIVL Model-Checking Verification Framework for Concurrent Data
# Structures
#
# This is the Makefile for AMPVer.
# ------------------------------------------------------------------------------

ROOT = ..
include common.mk

all: test

test:
	$(MAKE) -C $(DRIVER)
	$(MAKE) -C $(QUEUE_DIR)
	$(MAKE) -C $(SET_DIR)
	$(MAKE) -C $(LIST_DIR)
	$(MAKE) -C $(PQUEUE_DIR)

configA:
	$(MAKE) -f lists.mk list_A
	$(MAKE) -f queues.mk queue_A
	$(MAKE) -f pqueues.mk pqueue_A
	$(MAKE) -f hashsets.mk hashset_A

bugs:
	$(MAKE) -f lists.mk bugs
	$(MAKE) -f queues.mk bugs
	$(MAKE) -f pqueues.mk bugs
	$(MAKE) -f hashsets.mk bugs

.PHONY: all test configA
