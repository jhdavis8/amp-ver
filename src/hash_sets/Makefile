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

DEPS = driver/hash_set_max_driver.cvl ../util/perm_util.c include/set.cvh
INPUTS = -inputVAL_B=$(VAL_BND) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND)
DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DLNR_CHECK=$(LNR_CHECK) -DVAL_BND=$(VAL_BND)

.PHONY: naive striped coarse cuckoo striped_cuckoo

naive : naive/naive_set.cvl $(DEPS)
	$(CIVL) $(INPUTS) $(DEFINES) driver/hash_set_max_driver.cvl naive/naive_set.cvl 

striped : striped/striped_set.cvl $(DEPS)
	$(CIVL) $(INPUTS) $(DEFINES) driver/hash_set_max_driver.cvl striped/striped_set.cvl

coarse : coarse/coarse_set.cvl $(DEPS)
	$(CIVL) $(INPUTS) $(DEFINES) driver/hash_set_max_driver.cvl coarse/coarse_set.cvl

cuckoo : cuckoo/cuckoo_seq.cvl $(DEPS)
	$(CIVL) $(INPUTS) $(DEFINES) driver/hash_set_max_driver.cvl cuckoo/cuckoo_seq.cvl

striped_cuckoo : striped_cuckoo/striped_cuckoo.cvl $(DEPS)
	$(CIVL) $(INPUTS) $(DEFINES) driver/hash_set_max_driver.cvl striped_cuckoo/striped_cuckoo.cvl
