# Filename : Makefile (src/hashset)
# Author   : Josh Davis, Stephen F. Siegel
# Created  : 2024-01-25
# Modified : 2025-01-17

# Makefile will perform simple tests on the hash set implementations
# in this directory.

ROOT = ../..
include $(ROOT)/common.mk

all: CoarseHashSet StripedHashSet StripedCuckooHashSet LockFreeHashSet

CoarseHashSet: CoarseHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -DHASH_ND \
  -D_COARSE_HASH_SET_MAIN -checkTermination=true \
  CoarseHashSet.cvl $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC)

StripedHashSet: StripedHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
  -D_STRIPED_HASH_SET_MAIN -checkTermination=true \
  StripedHashSet.cvl $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC)

RefinableHashSet: RefinableHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC) \
     $(AMR_INC) $(AMR_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -D_REFINABLE_HASH_SET_MAIN -D_LOCK_TEST \
  -fair -checkMemoryLeak=false -checkTermination=true RefinableHashSet.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC) $(AMR_SRC)

RefinableHashSetPatched: RefinableHashSetPatched.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC) \
     $(AMR_INC) $(AMR_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -D_REFINABLE_HASH_SET_MAIN -D_LOCK_TEST \
  -fair -checkMemoryLeak=false -checkTermination=true RefinableHashSetPatched.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC) $(AMR_SRC)

LockFreeHashSet: LockFreeHashSet.cvl \
  $(AMR_INC) $(AMR_SRC) $(HASH_INC) $(HASH_SRC) $(AI_INC) $(AI_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -checkMemoryLeak=false \
  -checkTermination=true -fair -D_LOCK_FREE_HASH_SET_MAIN LockFreeHashSet.cvl \
  $(AMR_SRC) $(HASH_SRC) $(AI_SRC) $(TID_SRC)

LockFreeHashSetPatched: LockFreeHashSetPatched.cvl \
  $(AMR_INC) $(AMR_SRC) $(HASH_INC) $(HASH_SRC) $(AI_INC) $(AI_SRC) \
  $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -checkMemoryLeak=false \
  -checkTermination=true -fair -D_LOCK_FREE_HASH_SET_MAIN LockFreeHashSetPatched.cvl \
  $(AMR_SRC) $(HASH_SRC) $(AI_SRC) $(TID_SRC)

StripedCuckooHashSet: StripedCuckooHashSet.cvl \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(LOCK_INC) $(LOCK_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
  -D_STRIPED_CUCKOO_HASH_SET_MAIN StripedCuckooHashSet.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC)

StripedCuckooHashSetPatched: StripedCuckooHashSetPatched.cvl \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(LOCK_INC) $(LOCK_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
  -D_STRIPED_CUCKOO_HASH_SET_MAIN StripedCuckooHashSetPatched.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC)

RefinableCuckooHashSet: RefinableCuckooHashSet.cvl \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(LOCK_INC) $(LOCK_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC) $(AMR_INC) $(AMR_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -D_LOCK_TEST \
  -D_REFINABLE_CUCKOO_HASH_SET_MAIN -fair -checkMemoryLeak=false \
  -checkTermination=true RefinableCuckooHashSet.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC) $(AMR_SRC)

RefinableCuckooHashSetPatched: RefinableCuckooHashSetPatched.cvl \
  $(ARRAYLIST_INC) $(ARRAYLIST_SRC) $(LOCK_INC) $(LOCK_SRC) \
  $(HASH_INC) $(HASH_SRC) $(TID_INC) $(TID_SRC) $(AMR_INC) $(AMR_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -D_LOCK_TEST \
  -D_REFINABLE_CUCKOO_HASH_SET_MAIN -fair -checkMemoryLeak=false \
  -checkTermination=true RefinableCuckooHashSetPatched.cvl \
  $(ARRAYLIST_SRC) $(LOCK_SRC) $(HASH_SRC) $(TID_SRC) $(AMR_SRC)

.PHONY: CoarseHashSet StripedCuckooHashSet StripedHashSet \
  StripedCuckooHashSetPatched LockFreeHashSet LockFreeHashSetPatched \
  RefinableHashSet RefinableHashSetPatched RefinableCuckooHashSet \
  RefinableCuckooHashSetPatched
