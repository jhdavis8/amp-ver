# CIVL Verification of *The Art of Multiprocessor Programming*

## Concurrent data structures implemented:

*All page numbers taken from the Revised Reprint*

Coarse-grained List:
* sets/coarselist/coarse_list.cvl
* A linked list which uses a single lock to control access to the entire list.
* AMP Chapter 9.4, page 200

Fine-grained List:
* sets/finelist/fine_list.cvl
* A linked list which uses one lock for each node of the list.
* AMP Chapter 9.5, page 201

Optimistic List:
* sets/optimisticlist/optimistic_list.cvl
* A linked list which allows searching the list without locking, locks when the nodes are found, and then checks that the locked nodes are correct. If a synchronization conflict causes the wrong node to be locked, the locks are released and the process restarts.
* AMP Chapter 9.6, page 205
* **Note**: This implementation does verify but may need further debugging.

Lock-Free Unbounded Queue
* sets/lock_free_unbounded_queue.cvl
* A queue implementation which uses atomic compare and swap operations to maintain correctness, with a lazy/two-step add/remove process.
* AMP Chapter 10.5, page 230

Naive Set:
* sets/naive/naive_set.cvl
* A minimum set implementation (created for testing the driver)
* No corresponding AMP chapter

Coarse-grained Hash Set:
* sets/coarse/coarse_set.cvl
* A closed-address hash set which uses a single lock to control access.
* AMP Chapter 13.2.1, page 302

Striped Hash Set:
* sets/striped/striped_set.cvl
* A closed-address hash set which uses a fixed number of locks which each control access to a disjoint subet of the set's buckets.
* AMP Chapter 13.2.2, page 303

Sequential Cuckoo Hash Set:
* sets/cuckoo/cuckoo_seq.cvl
* An open-address hash set with (sequential access only) which demonstrates cuckoo hashing. Cuckoo hashing involves the use of two hash tables with different hash function, in which values displaced from one table are moved to the other until all items are stored.
* AMP Chapter 13.4.1, page 316
* **Note**: This data structure fails to verify as it has no means to prevent synchronization errors.

Striped Cuckoo Hash Set:
* sets/cuckoo/striped_cuckoo.cvl
* An open-address hash set which combines the approaches of the cuckoo hash set and the striped hash set.
* AMP Chapter 13.4.3, page 322
* **Note**: This data structure fails to verify when a large value bound is used. I am not yet sure why.

## Publication Targets:


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
