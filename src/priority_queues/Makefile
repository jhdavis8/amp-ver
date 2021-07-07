# To running test driver with a particular data structure:
#   make structure_name
#
# To specify parameters (optional):
#   make structure_name THD_BND=3 VAL_BND=3 STP_BND=3

CC = gcc
CIVL = civl verify -checkMemoryLeak=false

ifndef VAL_BND
	VAL_BND = 2
endif
ifndef THD_BND
	THD_BND = 2
endif
ifndef STP_BND
	STP_BND = 2
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

DEPS = naive/naive_priority_queue.cvl driver/priority_queue_max_driver.cvl ../util/perm_util.c include/priority_queue.cvh include/naive_priority_queue.cvh
INPUTS = -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND)
DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DLNR_CHECK=$(LNR_CHECK) -DVAL_BND=$(VAL_BND)
RUNFILES = driver/priority_queue_max_driver.cvl naive/naive_priority_queue.cvl

.PHONY: uhb_priority_queue sbu_priority_queue

uhb_priority_queue : unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) $(RUNFILES) \
		unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl

sbu_priority_queue : skiplist_based_unbounded_priority_queue/skiplist_based_unbounded_priority_queue.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) $(RUNFILES) \
		skiplist_based_unbounded_priority_queue/skiplist_based_unbounded_priority_queue.cvl
