Concurrent data structures implemented:

naive_set.cvl: A simple boolean set
	2 VAL, 2 THD, 2 STP: PASS
	2 VAL, 2 THD, 3 STP: PASS
	2 VAL, 3 THD, 2 STP: PASS
	6 VAL, 2 THD, 2 STP: PASS
	LockRegistry: None, sequential algorithm

striped_set.cvl: A hash set using lock striping to control access
	2 VAL, 2 THD, 2 STP: PASS
	2 VAL, 2 THD, 3 STP: PASS
	2 VAL, 3 THD, 2 STP: PASS
	6 VAL, 2 THD, 2 STP: PASS
	LockRegistry: Started, locking method is out of date

coarse_set.cvl: A hash set using a single lock
	2 VAL, 2 THD, 2 STP: PASS
	2 VAL, 2 THD, 3 STP: PASS
	2 VAL, 3 THD, 2 STP: PASS
	6 VAL, 2 THD, 2 STP: PASS
	LockRegistry: Started, locking method is out of date

cuckoo_set.cvl: A hash set using which moves values between two tables
	2 VAL, 2 THD, 2 STP: FAIL
	2 VAL, 2 THD, 3 STP: FAIL
	2 VAL, 3 THD, 2 STP: FAIL
	6 VAL, 2 THD, 2 STP: FAIL
	LockRegistry: None, sequential algorithm

striped_cuckoo.cvl: A hash set using the cuckoo method along with lock striping
	2 VAL, 2 THD, 2 STP: PASS
	2 VAL, 2 THD, 3 STP: PASS (285.91s)
	2 VAL, 3 THD, 2 STP: PASS (41.15s)
	6 VAL, 2 THD, 2 STP: FAIL
	LockRegistry: 

coarse_list.cvl: A linked list using a single lock
	2 VAL, 2 THD, 2 STP: PASS (5.83)
	2 VAL, 2 THD, 3 STP: PASS (14.77)
	2 VAL, 3 THD, 2 STP: PASS (12.64)
	6 VAL, 2 THD, 2 STP: PASS (14.62)
	LockRegistry: Written and tested

fine_list.cvl: A linked list using a lock for each node
	2 VAL, 2 THD, 2 STP: PASS (6.95s)
	2 VAL, 2 THD, 3 STP: PASS (23.22s)
	2 VAL, 3 THD, 2 STP: PASS (16.94s)
	6 VAL, 2 THD, 2 STP: PASS (21.01s)
	LockRegistry: Written and tested

optimistic_list.cvl: A linked list which uses the fine_list approach, but allows
		     searching without locking
	(Incomplete)



Publication Targets:
		 
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
