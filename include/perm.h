#ifndef _PERM_H
#define _PERM_H
/* Filename : perm.h
   Author   : Stephen F. Siegel
   Created  : 2024-01-25
   Modified : 2025-01-18

   Utility functions for generating sets of sequential interleavings
   of schedules.  A "perm" is a sequence of thread IDs.  It specifies
   which thread executes at each point in time.  A perm is specified
   by a an int size (the number of thread IDs in the sequence) and an
   int* (pointing to the first element in the sequence).  A "perm-set"
   is an ordered set of perms.  It it represented as an int**.  All
   perms in a perm-set must have the same size.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "schedule.h"

/* Prints a perm from a perm-set perms.  idx_perms is the index of the
   perm to print in perms.  size_perm is the size of each perm in
   perms. */
void perm_print(int idx_perms, int size_perm, int** perms);

/* Prints all the perms in the perm-set perms.  num_perms is the
   number of perms in perms, and size_perm is the size of each perm in
   perms. */
void perm_print_all(int num_perms, int size_perm, int** perms);

/* Computes the number of perms generated by the counts array.  counts
   has length n, which is typically the number of threads in a
   schedule. counts[i] is the number of steps performed by thread i in
   the schedule.  The perm-set generated from counts is the set of all
   permutations of the set {0,...0,1,...,1,...,n-1,...,n-1} consisting
   of counts[0] 0s, counts[1] 1s, ...., count[n-1] (n-1)s.  This function
   returns the size of that set.
*/
int perm_calc_num(int n, int * counts);

/* Computes the set of permutations generated by the counts array,
   which has length n. */
int** perm_compute(int n, int * counts);

/* Computes the permutations generated by counts array, filtering out
   permuations that fail to meet the linearizability condition, based
   on the given schedule. Filtered perms are flagged with a -1 in
   their first index.

   schedule: a schedule that has been filled in with results and
   timing data after a concurrent execution

   counts: array of length schedule.nthread.  For each i, counts[i] is
   the number of steps in the schedule completed by thread i.
 */
int** perm_compute_linear(schedule_t schedule, int * counts);

#endif
