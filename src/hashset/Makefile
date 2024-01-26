ROOT = ../..
include $(ROOT)/common.mk

all: CoarseHashSet StripedCuckooHashSet StripedHashSet

CoarseHashSet: CoarseHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 -DHASH_ND \
          -D_COARSE_HASH_SET_MAIN CoarseHashSet.cvl $(ARRAYLIST_SRC) \
          $(LOCK_SRC) $(HASH_SRC)

StripedHashSet: StripedHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
          -D_STRIPED_HASH_SET_MAIN StripedHashSet.cvl $(ARRAYLIST_SRC) \
          $(LOCK_SRC) $(HASH_SRC)

StripedCuckooHashSet: StripedCuckooHashSet.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
          -D_STRIPED_CUCKOO_HASH_SET_MAIN StripedCuckooHashSet.cvl $(ARRAYLIST_SRC) \
          $(LOCK_SRC) $(HASH_SRC)

StripedCuckooHashSetPatched: StripedCuckooHashSetPatched.cvl $(ARRAYLIST_INC) $(ARRAYLIST_SRC) \
     $(LOCK_INC) $(LOCK_SRC) $(HASH_INC) $(HASH_SRC)
	$(VERIFY) -inputVAL_B=4 -inputHASH_B=3 \
          -D_STRIPED_CUCKOO_HASH_SET_MAIN StripedCuckooHashSetPatched.cvl $(ARRAYLIST_SRC) \
          $(LOCK_SRC) $(HASH_SRC)

.PHONY: CoarseHashSet StripedCuckooHashSet StripedHashSet StripedCuckooHashSetPatched
