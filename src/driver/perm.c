/* Filename : perm.c
   Authors  : Wenhao Wu, Josh Davis, Stephen F. Siegel
   Created  : 2017-12-05
   Moified  : 2025-01-17

   Utility functions for creation and manipulation of permuations,
   and some functions specialized for analyzing schedules.

   Verified Software Lab
   Department of Computer & Information Sciences
   University of Delaware
 */
#include "perm.h"
#include "schedule.h"
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

/* Prints one permutation from a perm-set. */
void perm_print(int idx_perms, int size_perm, int** perms) {
  printf("Perm[%d]:\t", idx_perms);
  for (int j = 0; j < size_perm; j++)
    printf("%d, ", perms[idx_perms][j]);
  printf("\n");
}

/* Prints all permutations in a perm-set. */
void perm_print_all(int num_perms, int size_perm, int** perms) {
  for (int i = 0; i < num_perms; i++) {
    printf("Perm[%d]:\t", i);
    for (int j = 0; j < size_perm; j++)
      printf("%d ", perms[i][j]);
    printf("\n");
  }
}

/*  Factorial(n) */
static int fact(int n) {
  int result = 1;
  for (int i = 1; i <= n; i++)
    result *= i;
  return result;
}

int perm_calc_num(int n, int * counts){
  int sum = 0;
  for (int i = 0; i < n; i++)
    sum += counts[i];
  int numerator = fact(sum), denom = 1;
  for (int i = 0; i < n; i++)
    denom *= fact(counts[i]);
  return numerator/denom;
}

/* Auxiliary function used to compute the set of permutations.
   table is the 2d array of permutations that has already been
   allocated and is under construction.  This will fill in the
   bottom right quadrant of the table which is a rectangle with
   uppoer left corner at row i0, column j0.

   counts is an array of length len.  This fills in the quadrant with
   the list of all permutations of the set of integers S consisting of
   count[i] i's (for i:0..len-1).  They ordered as follows: first all
   such permutations starting with 0, then all such perms starting
   with 1, etc.
*/
static void perm_aux(int **table,
                     int i0,
                     int j0,
                     int len,
                     int * counts) {
  for (int i=0; i<len; i++) {
    if (counts[i] != 0) {
      int new_counts[len];
      for (int j=0; j<len; j++)
	new_counts[j] = j==i ? counts[j]-1 : counts[j];
      int np = perm_calc_num(len, new_counts);
      for (int j=0; j<np; j++)
	table[i0+j][j0] = i;
      perm_aux(table, i0, j0+1, len, new_counts);
      i0 += np;
    }
  }
}

int** perm_compute(int n, int * counts) {
  int num_rows = perm_calc_num(n, counts), sum = 0;
  for (int i = 0; i < n; i++)
    sum += counts[i];
  int num_cols = sum;
  int** result = malloc(num_rows * sizeof(int*));
  for (int i = 0; i < num_rows; i++)
    result[i] = malloc(num_cols * sizeof(int));
  perm_aux(result, 0, 0, n, counts);
  return result;
}

/* Linearizability check, returns false if the next op to be added has
   a stop time that is earlier than the start time of some other op
   that has already been added to the permuation. */
static bool check_times(int* row,
                        int curr_total_op_count,
                        int tid_next,
                        schedule_t schedule,
                        int nthread) {
  int tid_next_op_index = 0;
  int ops_index[nthread];
  step_t** steps = schedule.steps;
  for (int i = 0; i < nthread; i++) ops_index[i] = 0;
  for (int i = 0; i < curr_total_op_count - 1; i++) {
    if (row[i] == tid_next) tid_next_op_index++;
  } 
  int next_stop_time = steps[tid_next][tid_next_op_index].stop_time;
  if (next_stop_time < 0) {
    // if next_stop_time == UNDEF, treat it as +infty, since the
    // thread never returned from the call.  There is no way it could
    // violate the linearizability condition, since all the start
    // times are finite numbers.
    assert(next_stop_time == UNDEF);
    return true;
  }
  for (int i = 0; i < curr_total_op_count - 1; i++) {
    if (next_stop_time < steps[row[i]][ops_index[row[i]]++].start_time)
      return false;
  }
  return true;
}

/* Analogous to perm_aux but includes linearizability check.  A -1 is
   entered into column 0 of any row that represents an interleaving
   which violates the linearizability criterion.  */
static void linearizable_aux(int **table,
                             int i0,
                             int j0,
                             int nthread,
                             int * counts,
                             schedule_t schedule) {
  for (int i=0; i<nthread; i++) {
    if (counts[i] != 0) {
      int new_counts[nthread];
      for (int j=0; j<nthread; j++) {
	new_counts[j] = j==i ? counts[j]-1 : counts[j];
      }
      int np = perm_calc_num(nthread, new_counts);
      for (int j=0; j<np; j++) {
	if (table[i0+j][0] >= 0) {
	  if (check_times(table[i0+j], j0, i, schedule, nthread)) {
	    table[i0+j][j0] = i;
	  } else {
	    table[i0+j][0] = -1;
	  }
	}
      }
      linearizable_aux(table, i0, j0+1, nthread, new_counts, schedule);
      i0 += np;
    }
  }
}

int** perm_compute_linear(schedule_t schedule, int * counts) {
  int n = schedule.nthread;
  //int* counts = schedule.nsteps;
  step_t** steps = schedule.steps;
  int num_rows = perm_calc_num(n, counts);
  int sum = schedule.nstep;
  int num_cols = sum;
  int** result = (int **) malloc(num_rows * sizeof(int*));
  for (int i = 0; i < num_rows; i++) {
    result[i] = (int *) malloc(num_cols * sizeof(int));
    for (int j = 0; j < num_cols; j++) {
      result[i][j] = 0;
    }
  }
  linearizable_aux(result, 0, 0, n, counts, schedule);
  return result;
}

#ifdef _PERMS_MAIN
int main() {
  int test_n = 4;
  int* test_counts;
  test_counts = (int*) malloc(sizeof(int)*test_n);
  test_counts[0] = 1;
  test_counts[1] = 1;
  test_counts[2] = 2;
  test_counts[3] = 1;
  int** result = perm_compute(test_n, test_counts);
  int num_rows = perm_calc_num(test_n, test_counts);
  int num_cols = 0;
  for (int i = 0; i < test_n; i++) {
    num_cols += test_counts[i];
  }
  for (int i = 0; i < num_rows; i++) {
    for (int j = 0; j < num_cols; j++) {
      printf("%d ", result[i][j]);
    }
    printf("\n");
  }
}
#endif
