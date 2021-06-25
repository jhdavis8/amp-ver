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

DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DVAL_BND=$(VAL_BND)

.PHONY: lfu_queue

lfu_queue : lock_free_unbounded_queue/lock_free_unbounded_queue.cvl \
		naive/naive_queue.cvl driver/queue_max_driver.cvl driver/perm_util.c \
		include/queue.cvh include/naive_queue.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/queue_max_driver.cvl \
		lock_free_unbounded_queue/lock_free_unbounded_queue.cvl \
		naive/naive_queue.cvl

