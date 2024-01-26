package av;
import java.util.Iterator;
import java.util.Arrays;
import java.io.PrintStream;
import static av.Step.Op;
import static av.Schedule.DSKind.*;

/**
 * An iterator over all Schedules that meet certain requirements, for
 * a Set concurrent data structure.  Ranges of values are specified
 * for nthread (number of threads), nstep (number of steps, excluding
 * any pre-adds), npreAdd (number of pre-adds).  A valueBound is also
 * specified; the values that will be used are in the range
 * 0..valueBound-1.
 *
 * If threadSym is true then it is assumed the behavior of the data
 * structure is symmetric with respect to threads.  Hence there is an
 * equivalence relation on schedules in which one schedule is
 * equivalent to another if it can be obtained by permuting the
 * threads. This attempts to choose one representative from each
 * equivalence class.
 *
 * The pre-adds are a sequence of ADD operations that take place before
 * the concurrent execution begins.   The pre-added values are always
 * 0,1, ..., npreAdd-1.
 *
 * Highest to lowest order:
 *
 * (1) the number of threads (nthread)
 * (2) the total number of steps (nstep) (excluding pre-adds)
 * (3) the number of pre-adds (npreAdd)
 * (4) the partition: nsteps[i], sum over i is nstep
 * (5) kinds: sequence of A/R/C for all steps
 * (6) value sequence for all steps
 */
public class SetScheduleIterator implements Iterator<Schedule> {
    
  // Constants...
  public final static PrintStream out = System.out;
  int nthread_lo;
  int nthread_hi;
  int nstep_lo;
  int nstep_hi;
  int npreAdd_lo;
  int npreAdd_hi;
  int valueBound;
  boolean threadSym = true;

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
    
  /** Choice of ADD/REMOVE/CONTAINS for each step (excluding preAdds).
   *  This is an array of length nthread.  kinds[i] has length
   *  partition[i].  If kinds[i][j]==0 then the j-th step of thread i
   *  is an ADD.  If 1, REMOVE.  If 2, CONTAINS. */
  int[][] kinds;

  /** kinds_stutter is an array of length nthread-1.  For
   *  i:0..nthread-2, kinds_stutter[i] is true iff
   *  partition_stutter[i] and kinds[i] equals kinds[i+1]. */
  boolean[] kinds_stutter;

  /** The sequence of value arguments.  Array of length nthread.
   *  values[i] is the sequence of value arguments for thread i.
   *  values[i] has length partition[i].  values[i][j] is the value
   *  arg for the j-th operation of thread i. */
  int[][] values;

  // Constructor...
    
  /**
   * Creates new iterator with given parameters and options.
   * Initializes curr to the first schedule.
   *
   * In initial schedule: #preAdds = npreAdd_lo, #threads = nthread_lo,
   * #steps = nstep_lo.
   */
  public SetScheduleIterator(int nthread_lo, int nthread_hi,
                             int nstep_lo, int nstep_hi,
                             int npreAdd_lo, int npreAdd_hi,
                             int valueBound,
                             boolean threadSym) {
    assert 1 <= nthread_lo && nthread_lo <= nthread_hi;
    assert 1 <= nstep_lo && nstep_lo <= nstep_hi;
    assert 0 <= npreAdd_lo && npreAdd_lo <= npreAdd_hi;
    assert nthread_lo <= nstep_lo;
    // otherwise nstep in nstep_lo..nthread_lo-1 aren't used
    assert valueBound >= 1;
    assert valueBound >= npreAdd;
    this.nthread_lo = nthread_lo;
    this.nthread_hi = nthread_hi;
    this.nstep_lo = nstep_lo;
    this.nstep_hi = nstep_hi;
    this.npreAdd_lo = npreAdd_lo;
    this.npreAdd_hi = npreAdd_hi;
    this.threadSym = threadSym;
    this.valueBound = valueBound;
    this.hasNext = init_nthread() && init_nstep() && init_npreAdd()
      && init_partition() && init_kinds() && init_values();
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
    kinds_stutter = new boolean[nthread-1];
    values = new int[nthread][];
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
   *  returns false without changing anything.  Otherwise, returns
   *  true. */
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
      return true;
    }
    return false;
  }

  boolean inc_npreAdd() {
    if (npreAdd < npreAdd_hi) {
      npreAdd++;
      return true;
    }
    return false;
  }

  void compute_partition_arrays() {
    for (int i=0; i<nthread-1; i++)
      partition_stutter[i] = (partition[i] == partition[i+1]);
    for (int i=0; i<nthread; i++) {
      values[i] = new int[partition[i]];
      kinds[i] = new int[partition[i]];
    }
  }

  // this partition has form m 1 1 ... 1.
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
   * kinds_stutter[i] (i:0..nthread-1).  */
  void compute_kinds_arrays() {
    for (int i=0; i<nthread-1; i++)
      kinds_stutter[i] =
        partition_stutter[i] && Arrays.equals(kinds[i], kinds[i+1]);
  }

  /** Start with all ADDs */
  boolean init_kinds() {
    for (int i=0; i<nthread; i++) {
      int n = partition[i];
      for (int j=0; j<n; j++)
        kinds[i][j] = 0; // all ADDs
    }
    compute_kinds_arrays();
    return true;
  }

  boolean inc_kinds() {
    boolean result = threadSym ?
      AVUtil.nxt_lex_lo_2d_sym(3, kinds, partition_stutter)
      : AVUtil.nxt_lex_lo_2d(3, kinds);
    if (result) compute_kinds_arrays();
    return result;
  }

  boolean init_values() {
    for (int i=0; i<nthread; i++) {
      int m = partition[i];
      for (int j=0; j<m; j++) {
        values[i][j] = 0;
      }
    }
    return true;
  }

  boolean inc_values() {
    boolean result;
    if (threadSym) {
      result = AVUtil.nxt_lex_lo_2d_sym(valueBound, values, kinds_stutter);
    } else {
      result = AVUtil.nxt_lex_lo_2d(valueBound, values);
    }
    return result;
  }

  public boolean hasNext() {
    return hasNext;
  }

  public Schedule next() {
    if (!hasNext) return null;
    // form the schedule to return...
    Schedule result = new Schedule(SET);
    result.nthread = nthread;
    result.nstep = nstep;
    result.presteps = new Step[npreAdd];
    for (int i=0; i<npreAdd; i++)
      result.presteps[i] = new Step(Op.ADD, i);
    result.steps = new Step[nthread][];
    for (int i=0; i<nthread; i++) {
      int count = 0; // number of ADDs for thread i
      int m = partition[i];
      result.steps[i] = new Step[m];
      for (int j=0; j<m; j++) {
        Op op;
        switch (kinds[i][j]) {
        case 0: op=Op.ADD; break;
        case 1: op=Op.REMOVE; break;
        case 2: op=Op.CONTAINS; break;
        default: throw new RuntimeException("unreachable");
        }
        result.steps[i][j] = new Step(op, values[i][j]);
      }
    }
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
    return result;
  }

  public static void test1() {
    SetScheduleIterator iter = new SetScheduleIterator(2,2,1,3,0,2,2,true);
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
