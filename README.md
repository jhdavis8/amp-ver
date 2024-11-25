# CIVL Verification of *The Art of Multiprocessor Programming*

This repository contains implementations of data structures from *The Art of
Multiprocessor Programming* in CIVL-C for model checking with CIVL.

## Installation directions:

A recent installation of the CIVL model checker is required. Installation
directions can be found here: http://vsl.cis.udel.edu:8080/civl/index.html.

To tell amp-ver where to find your CIVL installation, make a copy of
`config/config_default.mk` called `config/config.mk` and set the `CIVL_ROOT` and
`VSL_DEPS` arguments appropriately.

Once your CIVL installation is set up and you've configured amp-ver to point to
that installation, you can verify any of the implemented data structures using
our Makefile rules, which use various preset bounds as described in the paper.
The Makefile includes rules to run all the experiments in the paper.

The core experiments are divided into four categories: (hash) sets, lists,
queues, and priority queues. Each category has multiple sets of limits, which
are the parameters for the experiments passed to the AMPVer tool. The limits are
defined in the variables `HASHSET_LIMITS_n`, `LIST_LIMITS_n`, `QUEUE_LIMITS_n`,
and `PQUEUE_LIMITS_n`, where n is the number of the limit set. For example,
`HASHSET_LIMITS_1` is the limit set for the first and smallest core set
experiment. To run all of the core experiments for a particular category and
size, make the corresponding target.

Below is a list of the targets for each category:

* Sets: `hashset_1`, `hashset_2`, `hashset_3`, `hashset_4`
* Lists: `list_1`, `list_2`, `list_3`, `list_4`
* Queues: `queue_1`, `queue_2`, `queue_3`
* Priority Queues: `pqueue_1`, `pqueue_2`, `pqueue_3`, `pqueue_4`

For an example, to verify all lists using the second set of limits, one would
run:

```
make list_2
```

The output of each experiment is stored in the out/ directory. The summary
output for each data structure is stored in a file named out/DS_n.out, where DS
is the name of the data structure and n is the limit set. The outputs for each
schedule are stored in separate files in under a directory named out/DS_n.dir,
following the same naming convention. For example, the output for the
CoarseHashSet data structure using the first set of limits is stored in
out/CoarseHashSet_1.out, and the output for the first schedule is stored in
out/CoarseHashSet_1.dir/schedule_1.out, along with the CIVL schedule
configuration file as schedule_1.cvl. To run just one data structure and limit
set combination, one can run the corresponding target. For example, to run just
the CoarseHashSet data structure using the first set of limits, one would run:

```
make out/CoarseHashSet_1.out
```

Some data structures have additional variants that can also be verified. The
variant names are appended to the data structure name. The available variants
are listed and described below. These variants are included in the core
experiment targets described above.

LockFreeList: LockFreeListOriginal
 - Original: uses the original version of the LockFreeList data structure as
   presented in the 1st edition of the book, which contains a bug in the remove
   method corrected in later editions and the errata.

FineGrainedHeap: FineGrainedHeapFair, FineGrainedHeapNoCycles
 - Fair: uses a fair ReentrantLock instead of the original ReentrantLock. Also
   passes the -fair flag to AMPVer, which indicates thread scheduling must be
   fair.
 - NoCycles: removes the -checkTermination flag from AMPVer, which means AMPVer
   will not check for cycle violations.

SkipQueue: SkipQueuePatched

 - Patched: uses a patched version of the SkipQueue data structure that fixes
   the cycle bug in FindAndMarkMin as described in the paper.

In addition to the core experiments above, the Makefile also includes targets
for running particular individual schedules of interest. These targets are
described below. Currently, the only schedules of interest are for priority
queues.

* `PQUEUE_SCHED_1`: a schedule that reveals the non-linearizable behavior in
  SkipQueuePatched.
* `PQUEUE_SCHED_2`: a schedule that reveals the cycle violation in SkipQueue.
* `PQUEUE_SCHED_3`: same as PQUEUE_SCHED_2, but one fewer pre-add and one fewer
  thread.
* `PQUEUE_SCHED_4`: a schedule of similar size to the above that reveals no
  defect in SkipQueue or SkipQueuePatched.

Individual schedules can be run using a target of the form `out/DS_Sn`, where
`DS` is the name of the data structure, including any variants, and `n` is the
number of the schedule. Note the use of the letter S before the schedule number
to indicate that it is a schedule rule. The output of the schedule is stored in
`out/DS_Sn`. For example, to run the first schedule for SkipQueuePatched, one
would run:

```
make out/SkipQueuePatched_S1
```

All schedules for all priority queues can be run using the target
pqueue_schedules:

```
make pqueue_schedules
```

## Concurrent data structures implemented:

*All page numbers taken from the 2nd Edition.*

### Lists (Ch. 9)

Coarse-grained List:
* src/lists/coarselist/coarse_list.cvl
* A linked list which uses a single lock to control access to the entire list.
* AMP Chapter 9.4, page 206

Fine-grained List:
* src/lists/finelist/fine_list.cvl
* A linked list which uses one lock for each node of the list.
* AMP Chapter 9.5, page 207

Optimistic List:
* src/lists/optimisticlist/optimistic_list.cvl
* A linked list which allows searching the list without locking, locks when the
  nodes are found, and then checks that the locked nodes are correct. If a
  synchronization conflict causes the wrong node to be locked, the locks are
  released and the process restarts.
* AMP Chapter 9.6, page 211

Lazy List:
* src/lists/lazy_list/lazy_list.cvl
* A linked list, similar to the optimistic list, which implements a non-blocking
  contains and a two-step lazy remove method which uses a boolean mark field on
  each node.
* AMP Chapter 9.7, page 215

Lock-free List:
* src/lists/lock_free_list/lock_free_list.cvl
* A linked list which uses atomic markable references with compare-and-set for a
  non-blocking synchronization strategy.
* AMP Chapter 9.8, page 220

### Queues (Ch. 10)

Unbounded Total Queue
* src/queues/unbounded_total_queue/unbounded_total_queue.cvl
* A queue implementation with a simple two-lock synchronization approach.
* AMP Chapter 10.4, page 235

Lock-Free Unbounded Queue
* src/queues/lock_free_unbounded_queue/lock_free_unbounded_queue.cvl
* A queue implementation which uses atomic compare and swap operations to
  maintain correctness, with a lazy/two-step add/remove process.
* AMP Chapter 10.5, page 236

### Hash Sets (Ch. 13)

Coarse-grained Hash Set:
* src/hash_sets/coarse/coarse_set.cvl
* A closed-address hash set which uses a single lock to control access.
* AMP Chapter 13.2.1, page 308

Striped Hash Set:
* src/hash_sets/striped/striped_set.cvl
* A closed-address hash set which uses a fixed number of locks which each
  control access to a disjoint subet of the set's buckets.
* AMP Chapter 13.2.2, page 310

Striped Cuckoo Hash Set:
* src/hash_sets/striped_cuckoo/striped_cuckoo.cvl
* An open-address hash set which combines the approaches of the cuckoo hash set
  and the striped hash set.
* AMP Chapter 13.4.3, page 329

### Priority Queues (Ch. 15)

Unbounded Heap-based Priority Queue
* src/priority_queues/unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl
* A priority queue implementation which uses a fine-grained locking approach for
  synchronization of the underlying heap structure.
* AMP Chapter 15.4, page 363

Skiplist-based Unbounded Priority Queue
* src/priority_queues/skiplist_based_unbounded_priority_queue/skiplist_based_unbounded_priority_queue.cvl
* A lock-free priority queue using atomic markable references and a skiplist
  structure.
* AMP Chapter 15.5, page 371

### Barriers (Ch. 18)

Sense-reversing Barrier
* src/barriers/sense_barrier/sense_barrier.cvl
* A simple barrier with one global sense and thread-local Boolean senses
* AMP Chapter 18.3, page 433

Combining Tree Barrier
* src/barriers/combining_tree_barrier/combining_tree_barrier.cvl
* A tree barrier in which each node is a barrier between two threads, and all
  threads are assigned in pairs to leaf nodes. Similar to a tournament barrier.
* AMP Chapter 18.4, page 434

Static Tree Barrier
* src/barriers/static_tree_barrier/static_tree_barrier.cvl
* A tree barrier in which each thread is a assigned a node, and each node waits
  for its children to complete.
* AMP Chapter 18.5, page 436

Reverse Tree Barrier
* src/barriers/reverse_tree_barrier/reverse_tree_barrier.cvl
* A tree barrier similar to the combining tree barrier except that barrier
  completion starts at the root rather than at the leaves, and notifications
  come back to the root from the leaves. Presented as an exercise for the reader
  to check correctness.
* AMP Chapter 18.8, Exercise 18.7, page 447

TODO:
* SimpleBarrier
* Termination Detection Barrier?
