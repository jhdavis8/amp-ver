package av;
import java.util.Iterator;
import java.util.Arrays;
import java.io.PrintStream;
import static av.Step.Op;
import static av.Schedule.DSKind.*;

/**
 * If genericVals is true, the values in the ADD operations will be
 * 0,1,...,n-1, in that order, where n is the total number of ADD
 * operations, including pre-adds.  Futhermore, any permutation of the
 * values will be considered equivalent to the original.

 * If genericVals is false, the values can be any sequence of n
 * integers with values in 0..n-1.
 *
 * If distinctPriorities is true, the scores in the ADD operations
 * will be any permutation of 0..n-1.  If false, they can be any
 * sequence of n integers with values in 0..n-1.
 *
 * If addsDominate is true, the total number of adds (including
 * preAdds) must be at least the total number of removes in the
 * schedule.
 *
 * If threadSym is true then it is assumed the behavior of the data
 * structure is symmetric with respect to threads.  Hence there is an
 * equivalence relation on schedules in which one schedule is
 * equivalent to another if it can be obtained by permuting the
 * threads (and if genericVals, renumbering the values).  This
 * attempts to choose one representative from each equivalence class.

 * Highest to lowest order:

 * (1) the number of threads (nthread)
 * (2) the total number of steps (nstep) (excluding pre-adds)
 * (3) npreAdd
 * (4) the partition: nsteps[i], sum over i is nstep
 * (5) kinds: sequence of A/R of length nstep
 * (6) value sequence for all adds
 * (7) score sequence for all adds
 */
public class PQScheduleIterator implements Iterator<Schedule> {
    
  // Constants...
  public final static PrintStream out = System.out;
  int nthread_lo;
  int nthread_hi;
  int nstep_lo;
  int nstep_hi;
  int npreAdd_lo;
  int npreAdd_hi;
  boolean genericVals = true;
  boolean distinctPriorities = false;
  boolean addsDominate = true;
  boolean threadSym = true;
  boolean noAllAdd = false; // skip schedules with only ADD operations

  // Variables...
    
  boolean hasNext = true;

  /** Number of threads in current schedule */
  int nthread;

  /** Total number of steps in current schedule (excluding preAdds). */
  int nstep;

  /** Number of pre-adds in current schedule */
  int npreAdd;

  /** The current partition of nstep as the sum of nthread positive
   * integers.  This is an array of length nthread.  partition[i] is
   * the number of steps allocated to thread i in the current
   * schedule. */    
  int[] partition;

  /** partition_stutter is an array of length nthread-1.
   *  partition_stutter[i] is true iff partition[i]==partition[i+1]. */
  boolean[] partition_stutter;
    
  /** Choice of ADD or REMOVE for each step (excluding preAdds).
   *  This is an array of length nthread.  kinds[i] has length
   *  partition[i].  If kinds[i][j]==0 then the j-th step of thread
   *  i is an ADD.  Otherwise, it is a REMOVE. */
  int[][] kinds;

  /** kinds_stutter is an array of length nthread.  kinds_stutter[0]
   *  is false.  For i:1..nthread-1, kinds_stutter[i] is true iff
   *  partition_stutter[i-1] and kinds[i-1] equals kinds[i].  Note
   *  the off-by-one, which is necessary as this array is used with
   *  array values, which has length nthread+1. */
  boolean[] kinds_stutter;

  /** Array of length nthread+1.  nadd[0]=npreAdd.  For i:1..nthread,
   * nadd[i] is the number of ADDs in thread i-1, i.e., the number of 0
   * entries in array kinds[i-1]. NOTE THE OFF-BY-ONE index.  */
  int[] nadd;

  /** The total number of add operations, including the preAdds.
   *  This is the sum of the values in nadd. */
  int totalAdds = 0;

  /** The sequence of value arguments for the ADD operations.  Array
   *  of length nthread+1.  values[0] are the values for the
   *  preAdds.  For i>=1, values[i] is the sequence of value
   *  arguments for thread i-1.  Note the off-by-1.  values[i] has
   *  length nadd[i].  values[i][j] is the value arg for the j-th
   *  add operation of thread i-1. */
  int[][] values;

  /** Array of length nthread.  For i:0..nthread-1,
   *  values_stutter[i] is true iff kinds_stutter[i] is true and
   *  values[i] equals values[i+1]. */
  boolean[] values_stutter;

  /** The sequence of score arguments for the ADD operations.
   *  The length of this array is nthread+1. scores[i] has
   *  length nadd[i].  scores[0] are the score arguments for
   *  the preAdds.  For i>=1, scores[i][j] is the score arg
   *  for the j-th add operation of thread i-1. */
  int[][] scores;


  // Constructor...
    
  /**
   * Creates new iterator with given parameters and options.
   * Initializes curr to the first schedule.
   *
   * In initial schedule: #preAdds = npreAdd_lo, #threads = nthread_lo,
   * #steps = nstep_lo.
   */
  public PQScheduleIterator(int nthread_lo, int nthread_hi,
                            int nstep_lo, int nstep_hi,
                            int npreAdd_lo, int npreAdd_hi,
                            boolean genericVals,
                            boolean distinctPriorities,
                            boolean addsDominate,
                            boolean threadSym,
                            boolean noAllAdd) {
    // out.println("nthread_lo="+nthread_lo+" nthread_hi="+nthread_hi);
    // out.println("nstep_lo="+nstep_lo+" nstep_hi="+nstep_hi);
    // out.println("npreAdd_lo="+npreAdd_lo+" npreAdd_hi="+npreAdd_hi);
    assert 1 <= nthread_lo && nthread_lo <= nthread_hi;
    assert 1 <= nstep_lo && nstep_lo <= nstep_hi;
    assert 0 <= npreAdd_lo && npreAdd_lo <= npreAdd_hi;
    assert nthread_lo <= nstep_lo;
    // otherwise nstep in nstep_lo..nthread_lo-1 aren't used
    this.nthread_lo = nthread_lo;
    this.nthread_hi = nthread_hi;
    this.nstep_lo = nstep_lo;
    this.nstep_hi = nstep_hi;
    this.npreAdd_lo = npreAdd_lo;
    this.npreAdd_hi = npreAdd_hi;
    this.genericVals = genericVals;
    this.distinctPriorities = distinctPriorities;
    this.addsDominate = addsDominate;
    this.threadSym = threadSym;
    this.noAllAdd = noAllAdd;

    /*
    if (!init_nthread()) return;
    
    while (!init_nstep()) {
      if (!inc_nthread()) return;
    }
    // nthread and nstep initialized

    out.println("nthread and nstep initialized");
    
    while (!init_npreAdd()) {
      if (!inc_nstep()) {
        if (!inc_nthread()) return;
        while (!init_nstep()) {
          if (!inc_nthread()) return;
        }
      }
    }
    // nthread and nstep and npreAdd initialized
    out.println("nthread and nstep and npreAdd initialized");

    while (!init_partition()) {
      if (!inc_npreAdd()) {
        if (!inc_nstep()) {
          if (!inc_nthread()) return;
          while (!init_nstep()) {
            if (!inc_nthread()) return;
          }
        }
        while (!init_npreAdd()) {
          if (!inc_nstep()) {
            if (!inc_nthread()) return;
            while (!init_nstep()) {
              if (!inc_nthread()) return;
            }
          }
        }
      }
    }
    */
    
    this.hasNext =
      init_nthread() && init_nstep() && init_npreAdd() && init_partition() &&
      init_kinds() && init_values() && init_scores();
  }

  void print_state(PrintStream out) {
    out.print("nthread="+nthread+", nstep="+nstep+", npreAdd="+npreAdd+", partition=");
    AVUtil.print(out, partition);
    out.print(", kinds=");
    AVUtil.print(out, kinds);
    out.println();
  }
	

  /** Allocate the arrays that have length nthread */
  void allocate_nthread_arrays() {
    partition = new int[nthread];
    partition_stutter = new boolean[nthread-1];
    kinds = new int[nthread][];
    kinds_stutter = new boolean[nthread];
    nadd = new int[nthread+1];
    values = new int[nthread+1][];
    values_stutter = new boolean[nthread];
    scores = new int[nthread+1][];
  }

  /** Sets nthread to its initial value */
  boolean init_nthread() {
    if (nthread_lo <= nthread_hi) {
      nthread = nthread_lo;
      allocate_nthread_arrays();
      return true;
    }
    return false;
  }

  /** Increments nthread.  If it cannot be incremented further,
   *	returns false without changing anything.  Otherwise, returns
   *	true. */
  boolean inc_nthread() {
    if (nthread < nthread_hi) {
      nthread++;
      allocate_nthread_arrays();
      return true;
    }
    return false;
  }

  /** Set initial value of nstep, give current value of nthread.
   *  Since each thread must have at least one step, we must always
   *  have nstep >= nthread.  We must also have
   *  nstep_lo<=nstep<=nstep_hi. */
  boolean init_nstep() {
    if (nstep_lo >= nthread) {
      nstep = nstep_lo;
      return true;
    } else if (nthread <= nstep_hi) {
      nstep = nthread;
      return true;
    }
    return false;
  }

  boolean inc_nstep() {
    if (nstep < nstep_hi) {
      nstep++;
      return true;
    }
    return false;
  }

  boolean init_npreAdd() {
    if (npreAdd_lo <= npreAdd_hi) {
      npreAdd = npreAdd_lo;
      nadd[0] = npreAdd;
      return true;
    }
    return false;
  }

  boolean inc_npreAdd() {
    if (npreAdd < npreAdd_hi) {
      npreAdd++;
      nadd[0] = npreAdd;
      return true;
    }
    return false;
  }

  void compute_partition_arrays() {
    for (int i=0; i<nthread-1; i++)
      partition_stutter[i] = (partition[i] == partition[i+1]);
    for (int i=0; i<nthread; i++) {
      kinds[i] = new int[partition[i]];
    }
  }

  // this partition has form m 1 1 ... 1.
  // change to 1 ... 1 m.
  boolean init_partition() {
    assert nstep >= nthread;
    partition[0] = nstep - nthread + 1;
    for (int i=1; i<nthread; i++)
      partition[i] = 1;
    compute_partition_arrays();
    return true;
  }

  boolean inc_partition() {
    boolean result = threadSym ? AVUtil.nxt_partition_sym_lo(partition) :
      AVUtil.nxt_partition_lo(partition);
    if (result)
      compute_partition_arrays();
    return result;
  }

  /** Updates data structures that depend on kinds.  Computes
   * nadd[i] (for i:1..nthread) and totalAdds.  Computes
   * kinds_stutter[i] (i:0..nthread-1).  Allocates values[i] and
   * scores[i] for i in 0..nthread. */
  void compute_kinds_arrays() {
    values[0] = new int[npreAdd];
    scores[0] = new int[npreAdd];
    totalAdds = npreAdd;
    for (int i=0; i<nthread; i++) {
      int sum = 0;
      int m = kinds[i].length;
      for (int j=0; j<m; j++)
        sum += (kinds[i][j] == 0 ? 1 : 0);
      totalAdds += sum;
      nadd[i+1] = sum;
      values[i+1] = new int[sum];
      scores[i+1] = new int[sum];
    }
    kinds_stutter[0] = false;
    for (int i=1; i<nthread; i++)
      kinds_stutter[i] =
        partition_stutter[i-1] && Arrays.equals(kinds[i-1], kinds[i]);
  }

  /** Start with all ADDs */
  boolean init_kinds_base() {
    for (int i=0; i<nthread; i++) {
      int n = partition[i];
      for (int j=0; j<n; j++)
        kinds[i][j] = 0; // all ADDs
    }
    compute_kinds_arrays();

    //    out.println("init_kinds_base: done");
    
    return true;
  }

  /** Does the work of incrementing kinds without heed to
   * addsDominate. */ 
  boolean inc_kinds_base() {
    boolean result = threadSym ?
      AVUtil.nxt_lex_lo_2d_sym(2, kinds, partition_stutter)
      : AVUtil.nxt_lex_lo_2d(2, kinds);
    if (result) compute_kinds_arrays();

    //    out.println("inc_kinds_base: "+result);
    return result;
  }

  boolean inc_kinds() {
    while (inc_kinds_base()) {
      // #removes = nstep - #add = nstep - (totalAdds-npreAdd)
      // totalAdds >= #removes  iff  totalAdds >= nstep - totalAdds + npreAdd
      // iff   2*totalAdds >= nstep + npreAdd
      if (!addsDominate || 2*totalAdds >= nstep + npreAdd)
        return true;
    }
    return false;
  }

  boolean init_kinds() {
    if (noAllAdd) {
      init_kinds_base();
      return inc_kinds();
    } else {
      return init_kinds_base();
    }
  }

  void compute_values_arrays() {
    for (int i=0; i<nthread; i++)
      values_stutter[i] =
        genericVals ? kinds_stutter[i] :
        (kinds_stutter[i] && Arrays.equals(values[i], values[i+1]));
  }

  boolean init_values() {
    int count = 0;
    for (int i=0; i<=nthread; i++) {
      int m = nadd[i];
      for (int j=0; j<m; j++) {
        values[i][j] = genericVals ? count++ : 0;
      }
    }
    compute_values_arrays();
    return true;
  }

  boolean inc_values() {
    if (genericVals) return false;
    boolean result;
    if (threadSym) {
      result = AVUtil.nxt_lex_lo_2d_sym(totalAdds, values, kinds_stutter);
    } else {
      result = AVUtil.nxt_lex_lo_2d(totalAdds, values);
    }
    if (result) compute_values_arrays();
    return result;
  }

  boolean init_scores() {
    int count = totalAdds - 1;
    for (int i=0; i<=nthread; i++) {
      int m = nadd[i];
      for (int j=0; j<m; j++)
        scores[i][j] = distinctPriorities ? count-- : 0;
    }
    // in certain cases, this initial value may not be a representative
    // of its equivalence class:
    if (distinctPriorities && threadSym && !is_symrep_scores())
      return inc_scores(); // increment to first symrep
    return true;
  }

  boolean is_symrep_scores() {
    for (int i=1; i<nthread; i++) {
      if (values_stutter[i]) {
        // values[i]=values[i+1]
        int c = AVUtil.compare_lo(scores[i], scores[i+1]);
        if (c > 0) return false;
      }
    }
    return true;
  }

  // 0,1,...,n-1    is the last score sequence in low order
  // same for values.  need to reverse that, or use high order.

    
  boolean inc_scores() {
    if (distinctPriorities) {
      while (AVUtil.nxt_perm_lo_2d(scores)) {
        if (!threadSym || is_symrep_scores()) return true;
      }
      return false;
    } else {
      return threadSym ?
        AVUtil.nxt_lex_lo_2d_sym(totalAdds, scores, values_stutter) :
        AVUtil.nxt_lex_lo_2d(totalAdds, scores);
    }
  }

  public boolean hasNext() {
    return hasNext;
  }

  public Schedule next() {
    if (!hasNext) return null;
    // form the schedule to return...
    Schedule result = new Schedule(PQUEUE);
    result.nthread = nthread;
    result.nstep = nstep;
    result.presteps = new Step[npreAdd];
    for (int i=0; i<npreAdd; i++)
      result.presteps[i] =
        new Step(Op.ADD, values[0][i], scores[0][i]);
    result.steps = new Step[nthread][];
    for (int i=0; i<nthread; i++) {
      int count = 0; // number of ADDs for thread i
      int m = partition[i];
      result.steps[i] = new Step[m];
      for (int j=0; j<m; j++) {
        if (kinds[i][j]==0) {
          result.steps[i][j] =
            new Step(Op.ADD,
                     values[i+1][count],
                     scores[i+1][count]);
          count++;
        } else {
          result.steps[i][j] = new Step(Op.REMOVE);
        }
      }
    }
    if (!inc_scores()) {
      do {
        if (!inc_values()) {
          do {
            if (!inc_kinds()) {
              do {
                if (!inc_partition()) {
                  do {
                    if (!inc_npreAdd()) {
                      do {
                        if (!inc_nstep()) {
                          do {
                            if (!inc_nthread()) {
                              hasNext = false;
                              return result;
                            }
                          } while (!init_nstep());
                        }
                      } while (!init_npreAdd());
                    }
                  } while (!init_partition());
                }
              } while (!init_kinds());
            }
          } while (!init_values());
        }
      } while (!init_scores());
    }
    return result;
  }

  // SkipQueue (skip list based unbounded score queue)
  // preadd: (0,1)
  // ADD(1,0), ADD(2,2)
  // REMOVE
  // REMOVE
  // 1096 schedules

  /* Arguments:
     (int nthread_lo, int nthread_hi,
     int nstep_lo, int nstep_hi,
     int npreAdd_lo, int npreAdd_hi,
     boolean genericVals,
     boolean distinctPriorities,
     boolean addsDominate,
     boolean threadSym)
  */
  public static void test1() {
    PQScheduleIterator iter =
      new PQScheduleIterator(1,3,1,4,0,1,true,true,true,true,true);
    int count = 0;
    while (iter.hasNext()) {
      iter.next().print(System.out);
      count++;
    }
    out.println(count+" distinct schedules generated.");
  }

  public final static void main(String[] args) {
    test1();
  }
}
