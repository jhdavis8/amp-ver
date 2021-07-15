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


DEPS = driver/list_max_driver.cvl ../util/perm_util.c include/list.cvh
INPUTS = -inputTHD_B=$(THD_B) -inputSTP_B=$(STP_B)
DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DLNR_CHECK=$(LNR_CHECK) -DSYM_GEN=$(SYM_GEN)

.PHONY: coarse_list fine_list optimistic_list lock_free_list

coarse_list : coarselist/coarse_list.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) driver/list_max_driver.cvl coarselist/coarse_list.cvl

fine_list : finelist/fine_list.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) driver/list_max_driver.cvl finelist/fine_list.cvl

optimistic_list : optimisticlist/optimistic_list.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) driver/list_max_driver.cvl optimisticlist/optimistic_list.cvl

lock_free_list : lock_free_list/lock_free_list.cvl $(DEPS)
		$(CIVL) $(INPUTS) $(DEFINES) driver/list_max_driver.cvl lock_free_list/lock_free_list.cvl
