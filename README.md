# CIVL Verification of *The Art of Multiprocessor Programming*

## Concurrent data structures implemented:

*All page numbers taken from the 2nd Edition*

### Lists (Ch. 9)

Coarse-grained List:
* src/lists/coarselist/coarse_list.cvl
* A linked list which uses a single lock to control access to the entire list.
* AMP Chapter 9.4, page 200

Fine-grained List:
* src/lists/finelist/fine_list.cvl
* A linked list which uses one lock for each node of the list.
* AMP Chapter 9.5, page 201

Optimistic List:
* src/lists/optimisticlist/optimistic_list.cvl
* A linked list which allows searching the list without locking, locks when the nodes are found, and then checks that the locked nodes are correct. If a synchronization conflict causes the wrong node to be locked, the locks are released and the process restarts.
* AMP Chapter 9.6, page 205

Lock-free List:
* src/lists/lock_free_list/lock_free_list.cvl
* A linked list which uses atomic markable references with compare-and-set for a non-blocking synchronization strategy.
* AMP Chapter 9.8, page 220

### Queues (Ch. 10)

Lock-Free Unbounded Queue
* src/queues/lock_free_unbounded_queue/lock_free_unbounded_queue.cvl
* A queue implementation which uses atomic compare and swap operations to maintain correctness, with a lazy/two-step add/remove process.
* AMP Chapter 10.5, page 230

### Hash Sets (Ch. 13)

Naive Set:
* src/hash_sets/naive/naive_set.cvl
* A minimum set implementation (created for testing the driver)
* No corresponding AMP chapter

Coarse-grained Hash Set:
* src/hash_sets/coarse/coarse_set.cvl
* A closed-address hash set which uses a single lock to control access.
* AMP Chapter 13.2.1, page 302

Striped Hash Set:
* src/hash_sets/striped/striped_set.cvl
* A closed-address hash set which uses a fixed number of locks which each control access to a disjoint subet of the set's buckets.
* AMP Chapter 13.2.2, page 303

Sequential Cuckoo Hash Set:
* src/hash_sets/cuckoo/cuckoo_seq.cvl
* An open-address hash set with (sequential access only) which demonstrates cuckoo hashing. Cuckoo hashing involves the use of two hash tables with different hash function, in which values displaced from one table are moved to the other until all items are stored.
* AMP Chapter 13.4.1, page 316
* **Note**: This data structure fails to verify as it has no means to prevent synchronization errors.

Striped Cuckoo Hash Set:
* src/hash_sets/striped_cuckoo/striped_cuckoo.cvl
* An open-address hash set which combines the approaches of the cuckoo hash set and the striped hash set.
* AMP Chapter 13.4.3, page 322
* **Note**: This data structure fails to verify in its unmodified form due to a confirmed bug in the relocate() method. We have implemented a patch that can be enabled with the ENABLE_PATCH=1 option at the command line.

### Priority Queues (Ch. 15)

Unbounded Heap-Based Priority Queue
* src/priority_queues/unbounded_heap_based_priority_queue/unbounded_heap_based_priority_queue.cvl
* A priority queue implementation which uses a fine-grained locking approach for synchronization of the underlying heap structure.
* AMP Chapter 15.4, page 363

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

## Publication Targets (outdated):


	PPoPP 2020:  ACM SIGPLAN Symposium on Principles and Practice of Parallel
		     Programming
		     --> ? August 2019    : Abstract Due
			 ? February 2020  : Conference

	ICST 2020:   IEEE Conference on Software Testing
		     --> ? October 2019   : Abstract Due
			 ? April 2020     : Conference

	ISCE 2020:   Internation Conference on Software Engineering
		     --> ? October 2019   : Abstract Due
			 23-29 May 2020   : Conference in Seoul

	TACAS 2020:  International Conference on Tools and Algorithms for the
		     Construction and Analysis of Systems
		     --> ? November 2019  : Abstract Due
			 ? April 2020  	  : Conference

	ISSTA 2020:  ACM SIGSOFT International Symposium on Software Testing and
		     Analysis
		     --> 28 January 2020  : Technical Paper Submission
			 15-19 July 2020  : Conference in Beijing

	VSTTE 2020:  Verified Software: Theories, Tools, Experiments
		     --> ? April 2020     : Abstract Due
			 ? July 2020      : Conference

	CONCUR 2020: International Conference on Concurrency Theory
		     --> ? April 2020     : Abstract Due
			 ? September 2020 : Conference
