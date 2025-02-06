# ------------------------------------------------------------------------------------
# COLLECT: A CIVL Model-Checking Verification Framework for Concurrent Data
# Structures
#
# This is the Makefile for COLLECT experiments.
# ------------------------------------------------------------------------------

ROOT = ..
include common.mk

all:
	$(MAKE) -f lists.mk list_A
	$(MAKE) -f lists.mk list_B
	$(MAKE) -f lists.mk list_C
	$(MAKE) -f lists.mk list_D
	$(MAKE) -f queues.mk queue_A
	$(MAKE) -f queues.mk queue_B
	$(MAKE) -f queues.mk queue_C
	$(MAKE) -f queues.mk queue_D
	$(MAKE) -f pqueues.mk pqueue_A
	$(MAKE) -f pqueues.mk pqueue_B
	$(MAKE) -f pqueues.mk pqueue_C
	$(MAKE) -f pqueues.mk pqueue_D
	$(MAKE) -f hashsets.mk hashset_A
	$(MAKE) -f hashsets.mk hashset_B
	$(MAKE) -f hashsets.mk hashset_C
	$(MAKE) -f hashsets.mk hashset_D

test:
	$(MAKE) -C $(DRIVER)
	$(MAKE) -C $(QUEUE_DIR)
	$(MAKE) -C $(SET_DIR)
	$(MAKE) -C $(LIST_DIR)
	$(MAKE) -C $(PQUEUE_DIR)

config_A:
	$(MAKE) -f lists.mk list_A
	$(MAKE) -f queues.mk queue_A
	$(MAKE) -f pqueues.mk pqueue_A
	$(MAKE) -f hashsets.mk hashset_A

config_B:
	$(MAKE) -f lists.mk list_B
	$(MAKE) -f queues.mk queue_B
	$(MAKE) -f pqueues.mk pqueue_B
	$(MAKE) -f hashsets.mk hashset_B

config_C:
	$(MAKE) -f lists.mk list_C
	$(MAKE) -f queues.mk queue_C
	$(MAKE) -f pqueues.mk pqueue_C
	$(MAKE) -f hashsets.mk hashset_C

config_D:
	$(MAKE) -f lists.mk list_D
	$(MAKE) -f queues.mk queue_D
	$(MAKE) -f pqueues.mk pqueue_D
	$(MAKE) -f hashsets.mk hashset_D

config_E:
	$(MAKE) -f lists.mk list_E
	$(MAKE) -f queues.mk queue_E
	$(MAKE) -f pqueues.mk pqueue_E
	$(MAKE) -f hashsets.mk hashset_E

bugs:
	$(MAKE) -f lists.mk bugs
	$(MAKE) -f queues.mk bugs
	$(MAKE) -f pqueues.mk bugs
	$(MAKE) -f hashsets.mk bugs

.PHONY: all test config_A config_B config_C config_D config_E bugs
