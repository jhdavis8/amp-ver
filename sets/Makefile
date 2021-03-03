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

.PHONY: naive striped coarse cuckoo striped_cuckoo coarse_list fine_list lfu_queue

naive : naive/naive_set.cvl driver/max_driver.cvl driver/perm_util.c \
	include/set.cvh
	$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) driver/max_driver.cvl naive/naive_set.cvl 

striped : striped/striped_set.cvl driver/max_driver.cvl driver/perm_util.c \
	include/set.cvh
	$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) driver/max_driver.cvl striped/striped_set.cvl

coarse : coarse/coarse_set.cvl driver/max_driver.cvl driver/perm_util.c \
	include/set.cvh
	$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/max_driver.cvl coarse/coarse_set.cvl

cuckoo : cuckoo/cuckoo_seq.cvl driver/max_driver.cvl driver/perm_util.c \
	include/set.cvh
	$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/max_driver.cvl cuckoo/cuckoo_seq.cvl

striped_cuckoo : striped_cuckoo/striped_cuckoo.cvl driver/max_driver.cvl \
	          driver/perm_util.c include/set.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/max_driver.cvl striped_cuckoo/striped_cuckoo.cvl

coarse_list : coarselist/coarse_list.cvl driver/list_max_driver.cvl \
		driver/perm_util.c include/set.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl coarselist/coarse_list.cvl

fine_list : finelist/fine_list.cvl driver/list_max_driver.cvl \
		driver/perm_util.c include/set.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl finelist/fine_list.cvl

optimistic_list : optimisticlist/optimistic_list.cvl driver/list_max_driver.cvl \
		driver/perm_util.c include/set.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl optimisticlist/optimistic_list.cvl

lfu_queue : lock_free_unbounded_queue/lock_free_unbounded_queue.cvl \
		naive/naive_queue.cvl driver/queue_max_driver.cvl driver/perm_util.c \
		include/queue.cvh include/naive_queue.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/queue_max_driver.cvl \
		lock_free_unbounded_queue/lock_free_unbounded_queue.cvl \
		naive/naive_queue.cvl

uhb_priority_queue : unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl \
		naive/naive_priority_queue.cvl driver/priority_queue_max_driver.cvl \
		driver/perm_util.c include/priority_queue.cvh include/naive_priority_queue.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/priority_queue_max_driver.cvl \
		unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl \
		naive/naive_priority_queue.cvl

