# CIVL Verification of *The Art of Multiprocessor Programming*

This repository contains implementations of data structures from *The Art of Multiprocessor Programming* in CIVL-C for model checking with CIVL.

## Installation directions:

Documentation for how to run various experiment cases can be found in the Makefile.

A recent installation of the CIVL model checker is required. Installation directions can be found here: http://vsl.cis.udel.edu:8080/civl/index.html. 

To tell amp-ver where to find your CIVL installation, make a copy of `config/config_default.mk` called `config/config.mk` and set the `CIVL_ROOT` and `VSL_DEPS` arguments appropriately.

## Concurrent data structures implemented:

*All page numbers taken from the 2nd Edition*

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
* A linked list which allows searching the list without locking, locks when the nodes are found, and then checks that the locked nodes are correct. If a synchronization conflict causes the wrong node to be locked, the locks are released and the process restarts.
* AMP Chapter 9.6, page 211

Lazy List:
* src/lists/lazy_list/lazy_list.cvl
* A linked list, similar to the optimistic list, which implements a non-blocking contains and a two-step lazy remove method which uses a boolean mark field on each node.
* AMP Chapter 9.7, page 215

Lock-free List:
* src/lists/lock_free_list/lock_free_list.cvl
* A linked list which uses atomic markable references with compare-and-set for a non-blocking synchronization strategy.
* AMP Chapter 9.8, page 220

### Queues (Ch. 10)

Unbounded Total Queue
* src/queues/unbounded_total_queue/unbounded_total_queue.cvl
* A queue implementation with a simple two-lock synchronization approach.
* AMP Chapter 10.4, page 235

Lock-Free Unbounded Queue
* src/queues/lock_free_unbounded_queue/lock_free_unbounded_queue.cvl
* A queue implementation which uses atomic compare and swap operations to maintain correctness, with a lazy/two-step add/remove process.
* AMP Chapter 10.5, page 236

### Hash Sets (Ch. 13)

Coarse-grained Hash Set:
* src/hash_sets/coarse/coarse_set.cvl
* A closed-address hash set which uses a single lock to control access.
* AMP Chapter 13.2.1, page 308

Striped Hash Set:
* src/hash_sets/striped/striped_set.cvl
* A closed-address hash set which uses a fixed number of locks which each control access to a disjoint subet of the set's buckets.
* AMP Chapter 13.2.2, page 310

Striped Cuckoo Hash Set:
* src/hash_sets/striped_cuckoo/striped_cuckoo.cvl
* An open-address hash set which combines the approaches of the cuckoo hash set and the striped hash set.
* AMP Chapter 13.4.3, page 329

### Priority Queues (Ch. 15)

Unbounded Heap-based Priority Queue
* src/priority_queues/unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl
* A priority queue implementation which uses a fine-grained locking approach for synchronization of the underlying heap structure.
* AMP Chapter 15.4, page 363

Skiplist-based Unbounded Priority Queue
* src/priority_queues/skiplist_based_unbounded_priority_queue/skiplist_based_unbounded_priority_queue.cvl
* A lock-free priority queue using atomic markable references and a skiplist structure.
* AMP Chapter 15.5, page 371

### Barriers (Ch. 18)

Sense-reversing Barrier
* src/barriers/sense_barrier/sense_barrier.cvl
* A simple barrier with one global sense and thread-local Boolean senses
* AMP Chapter 18.3, page 433

Combining Tree Barrier
* src/barriers/combining_tree_barrier/combining_tree_barrier.cvl
* A tree barrier in which each node is a barrier between two threads, and all threads are assigned in pairs to leaf nodes. Similar to a tournament barrier.
* AMP Chapter 18.4, page 434

Static Tree Barrier
* src/barriers/static_tree_barrier/static_tree_barrier.cvl
* A tree barrier in which each thread is a assigned a node, and each node waits for its children to complete.
* AMP Chapter 18.5, page 436

Reverse Tree Barrier
* src/barriers/reverse_tree_barrier/reverse_tree_barrier.cvl
* A tree barrier similar to the combining tree barrier except that barrier completion starts at the root rather than at the leaves, and notifications come back to the root from the leaves. Presented as an exercise for the reader to check correctness.
* AMP Chapter 18.8, Exercise 18.7, page 447

TODO:
* SimpleBarrier
* Termination Detection Barrier?
