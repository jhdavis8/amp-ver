ROOT = .

##################################  Sets  ##################################

HASHSET_LIMITS_BASE = -kind=set -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_1  = -kind=set -hashKind=ident -valueBound=2 -nthread=1..2 \
     -nstep=1..2 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_1ND = -kind=set -hashKind=nd -hashRangeBound=2 -hashDomainBound=2 \
     -valueBound=2 -nthread=1..2 -nstep=1..2 -npreAdd=0 -threadSym -checkTermination \
     -ncore=$(NCORE)

HASHSET_LIMITS_1.5ND = -kind=set -hashKind=nd -hashRangeBound=2 -hashDomainBound=3 \
     -valueBound=3 -nthread=1..3 -nstep=1..3 -npreAdd=0 -threadSym \
     -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_2  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_2ND = -kind=set -hashKind=nd -hashRangeBound=4 -hashDomainBound=3 \
     -valueBound=3 -nthread=1..3 -nstep=1..3 -npreAdd=0 -threadSym -checkTermination \
     -ncore=$(NCORE)

HASHSET_LIMITS_3  = -kind=set -hashKind=ident -valueBound=3 -nthread=1..3 \
     -nstep=1..3 -npreAdd=1..3 -threadSym -checkTermination -ncore=$(NCORE)

HASHSET_LIMITS_4  = -kind=set -hashKind=ident -valueBound=3 -nthread=3 \
     -nstep=4 -npreAdd=0 -threadSym -checkTermination -ncore=$(NCORE)

HASH_COMMON_DEP = $(DRIVER_INC) $(DRIVER_NB_SRC) $(DRIVER_SET_NB) \
     $(HASH_INC) $(HASH_SRC) $(LOCK_INC) $(LOCK_SRC) $(ARRAYLIST_INC) $(ARRAYLIST_SRC) Makefile
HASH_COMMON_SRC = $(DRIVER_NB_SRC) $(DRIVER_SET_NB) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC)

SET_SCHED_1 = $(SCHEDULE_DIR)/sched_set_1.cvl
SET_SCHED_2 = $(SCHEDULE_DIR)/sched_set_2.cvl
SET_SCHED_3 = $(SCHEDULE_DIR)/sched_set_3.cvl

hashset_1 hashset_2 hashset_3 hashset_4 hashset_1ND hashset_1.5ND hashset_2ND: hashset_%: out/CoarseHashSet_%.out \
  out/StripedHashSet_%.out out/StripedCuckooHashSet_%.out

hashset_schedules: out/CoarseHashSet_S1 out/CoarseHashSet_S2 out/CoarseHashSet_S3 \
	out/StripedHashSet_S1 out/StripedHashSet_S2 out/StripedHashSet_S3 \
	out/StripedCuckooHashSet_S1 out/StripedCuckooHashSet_S2 out/StripedCuckooHashSet_S3

# CoarseHashSet

COARSEHASHSET = $(SET_DIR)/CoarseHashSet.cvl
COARSEHASHSET_DEP = $(HASH_COMMON_DEP) $(COARSEHASHSET)
COARSEHASHSET_SRC =  $(HASH_COMMON_SRC) $(COARSEHASHSET)
CoarseHashSet_Outs = $(addsuffix .out,$(addprefix out/CoarseHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(CoarseHashSet_Outs): out/CoarseHashSet_%.out: $(MAIN_CLASS) $(COARSEHASHSET_DEP)
	rm -rf $(TMP)/CoarseHashSet_$*.dir.tmp
	rm -rf out/CoarseHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/CoarseHashSet_$*.dir.tmp \
          $(COARSEHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/CoarseHashSet_$*.out.tmp
	mv $(TMP)/CoarseHashSet_$*.out.tmp out/CoarseHashSet_$*.out
	mv $(TMP)/CoarseHashSet_$*.dir.tmp out/CoarseHashSet_$*.dir

out/CoarseHashSet_S%: $(COARSEHASHSET_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(COARSEHASHSET_SRC) $(SET_SCHED_$*) \
					>out/CoarseHashSet_S$*

# StripedHashSet

STRIPEDHASHSET = $(SET_DIR)/StripedHashSet.cvl
STRIPEDHASHSET_DEP = $(HASH_COMMON_DEP) $(STRIPEDHASHSET)
STRIPEDHASHSET_SRC =  $(HASH_COMMON_SRC) $(STRIPEDHASHSET)
StripedHashSet_Outs = $(addsuffix .out,$(addprefix out/StripedHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(StripedHashSet_Outs): out/StripedHashSet_%.out: $(MAIN_CLASS) $(STRIPEDHASHSET_DEP)
	rm -rf $(TMP)/StripedHashSet_$*.dir.tmp
	rm -rf out/StripedHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/StripedHashSet_$*.dir.tmp \
          $(STRIPEDHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/StripedHashSet_$*.out.tmp
	mv $(TMP)/StripedHashSet_$*.out.tmp out/StripedHashSet_$*.out
	mv $(TMP)/StripedHashSet_$*.dir.tmp out/StripedHashSet_$*.dir

out/StripedHashSet_S%: $(STRIPEDHASHSET_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(STRIPEDHASHSET_SRC) $(SET_SCHED_$*) \
					>out/StripedHashSet_S$*

# StripedCuckooHashSet

STRIPEDCUCKOOHASHSET = $(SET_DIR)/StripedCuckooHashSet.cvl
STRIPEDCUCKOOHASHSET_DEP = $(HASH_COMMON_DEP) $(STRIPEDCUCKOOHASHSET)
STRIPEDCUCKOOHASHSET_SRC =  $(HASH_COMMON_SRC) $(STRIPEDCUCKOOHASHSET)
StripedCuckooHashSet_Outs = $(addsuffix .out,$(addprefix out/StripedCuckooHashSet_,1 1ND 1.5ND 2 2ND 3 4))

$(StripedCuckooHashSet_Outs): out/StripedCuckooHashSet_%.out: $(MAIN_CLASS) $(STRIPEDCUCKOOHASHSET_DEP)
	rm -rf $(TMP)/StripedCuckooHashSet_$*.dir.tmp
	rm -rf out/StripedCuckooHashSet_$*.dir
	-$(AMPVER) $(HASHSET_LIMITS_$*) -tmpDir=$(TMP)/StripedCuckooHashSet_$*.dir.tmp \
          $(STRIPEDCUCKOOHASHSET) $(HASH_SRC) $(LOCK_SRC) $(ARRAYLIST_SRC) \
          >$(TMP)/StripedCuckooHashSet_$*.out.tmp
	mv $(TMP)/StripedCuckooHashSet_$*.out.tmp out/StripedCuckooHashSet_$*.out
	mv $(TMP)/StripedCuckooHashSet_$*.dir.tmp out/StripedCuckooHashSet_$*.dir

out/StripedCuckooHashSet_S%: $(STRIPEDCUCKOOHASHSET_DEP) $(SET_SCHED_$*)
	-$(VERIFY) -checkMemoryLeak=false -checkTermination=true $(STRIPEDCUCKOOHASHSET_SRC) $(SET_SCHED_$*) \
					>out/StripedCuckooHashSet_S$*
