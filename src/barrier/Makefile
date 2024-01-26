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
ifndef DEP_BND
	DEP_BND = 2
endif

DEFINES = -DENABLE_PATCH=$(PATCH) -DHASH_FN_OPTION=$(HASH_OPT) -DVAL_BND=$(VAL_BND)

.PHONY: all sense_barrier reverse_tree_barrier combining_tree_barrier static_tree_barrier

all : sense_barrier reverse_tree_barrier combining_tree_barrier static_tree_barrier

sense_barrier : sense_barrier/sense_barrier.cvl driver/barrier_driver.cvl \
	include/barrier.cvh
	$(CIVL) -inputTHD_B=$(THD_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) \
		driver/barrier_driver.cvl sense_barrier/sense_barrier.cvl

combining_tree_barrier : combining_tree_barrier/combining_tree_barrier.cvl driver/barrier_driver.cvl \
	include/barrier.cvh
	$(CIVL) -inputD_B=$(DEP_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) -DTHREADS_ARE_LEAVES \
		driver/barrier_driver.cvl combining_tree_barrier/combining_tree_barrier.cvl

static_tree_barrier : static_tree_barrier/static_tree_barrier.cvl driver/barrier_driver.cvl \
	include/barrier.cvh
	$(CIVL) -inputD_B=$(DEP_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) -DTHREADS_ARE_NODES \
		driver/barrier_driver.cvl static_tree_barrier/static_tree_barrier.cvl

reverse_tree_barrier : reverse_tree_barrier/reverse_tree_barrier.cvl driver/barrier_driver.cvl \
	include/barrier.cvh
	$(CIVL) -inputD_B=$(DEP_BND) -inputSTP_B=$(STP_BND) \
	 	$(DEFINES) -DTHREADS_ARE_LEAVES \
		driver/barrier_driver.cvl reverse_tree_barrier/reverse_tree_barrier.cvl
