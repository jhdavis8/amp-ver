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

.PHONY: coarse_list fine_list optimistic_list lock_free_list

coarse_list : coarselist/coarse_list.cvl driver/list_max_driver.cvl \
		../util/perm_util.c include/list.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl coarselist/coarse_list.cvl

fine_list : finelist/fine_list.cvl driver/list_max_driver.cvl \
		../util/perm_util.c include/list.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl finelist/fine_list.cvl

optimistic_list : optimisticlist/optimistic_list.cvl driver/list_max_driver.cvl \
		../util/perm_util.c include/list.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl optimisticlist/optimistic_list.cvl

lock_free_list : lock_free_list/lock_free_list.cvl driver/list_max_driver.cvl \
		../util/perm_util.c include/list.cvh
		$(CIVL) -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
                $(DEFINES) driver/list_max_driver.cvl lock_free_list/lock_free_list.cvl
