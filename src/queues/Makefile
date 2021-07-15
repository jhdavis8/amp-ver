# To running test driver with a particular data structure:
#   make structure_name
#
# To specify parameters (optional):
#   make structure_name THD_BND=3 VAL_BND=3 STP_BND=3

CC = gcc
CIVL = civl verify -checkMemoryLeak=false

ifndef THD_B
	THD_B = 2
endif
ifndef STP_B
	STP_B = 2
endif
ifndef PATCH
	PATCH = 1
endif
ifndef HASH_OPT
	HASH_OPT = 0
endif
ifndef LNR_CHECK
	LNR_CHECK = 1
endif
ifndef SYM_GEN
	SYM_GEN = 1
endif

DEPS = naive/naive_queue.cvl driver/queue_max_driver.cvl ../util/perm_util.c include/queue.cvh include/naive_queue.cvh
INPUTS = -inputTHD_B=$(THD_B) -inputSTP_B=$(STP_B)
DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DLNR_CHECK=$(LNR_CHECK) -DSYM_GEN=$(SYM_GEN)
RUNFILES = driver/queue_max_driver.cvl naive/naive_queue.cvl

.PHONY: lfu_queue

lfu_queue : lock_free_unbounded_queue/lock_free_unbounded_queue.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) $(RUNFILES) \
		lock_free_unbounded_queue/lock_free_unbounded_queue.cvl

