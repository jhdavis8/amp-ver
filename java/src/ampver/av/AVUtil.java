package av;
import java.util.Arrays;
import java.io.PrintStream;

/**
 * Utility methods.  To test, run with -ea (assertions enabled).
 */
public class AVUtil {

  private static final PrintStream out = System.out;

  /**
   * Modifies an array a in which entries are in 0..b-1 by moving to
   * the next sequence in lexicographic order, where index 0 has
   * lowest order (i.e., changes most frequently).  For example, if
   * b=4 and a={2,2,3,0}, then upon return a={3,2,3,0}.  After the
   * next call, a={0,3,3,0}.  If a is already at the last sequence,
   * a is not modified and false is returned; otherwise, true is
   * returned.  For example, if called on b=4 and a={3,3,3,3}, false
   * is returned and a is unmodified.
   */
  public static boolean nxt_lex_lo(int b, int[] a) {
    int n=a.length, i=0;
    while (i<n) {
      if (a[i] != b-1) break;
      i++;
    }
    if (i>=n) return false;
    a[i]++;
    i--;
    while (i >= 0) {
      a[i] = 0;
      i--;
    }
    return true;
  }

  public static boolean nxt_lex_lo_2d(int b, int[][] a) {
    int n=a.length, i=0;
    while (i<n) {
      int m = a[i].length, j;
      for (j=0; j<m; j++) {
        if (a[i][j] != b-1) break;
      }
      if (j<m) break;
      i++;
    }
    if (i>=n) return false;
    nxt_lex_lo(b, a[i]);
    i--;
    while (i >= 0) {
      int m = a[i].length;
      for (int j=0; j<m; j++)
        a[i][j] = 0;
      i--;
    }
    return true;
  }

  public static int compare_lo(int[] a1, int[] a2) {
    int n = a1.length;
    assert n==a2.length;
    for (int i=n-1; i>=0; i--) {
      int d = a1[i] - a2[i];
      if (d < 0)
        return -1;
      if (d > 0)
        return 1;
    }
    return 0;
  }

  public static boolean is_const(int[] a, int val) {
    int n = a.length;
    for (int i=0; i<n; i++) 
      if (a[i] != val)
        return false;
    return true;
  }

  /**
   * Like nxt_lex_lo_2d, except that symmetry reduction
   * is done.  If alike[i] is true then a[i]<=a[i+1]
   * will be preserved. alike has length a.length-1.
   */
  public static boolean nxt_lex_lo_2d_sym
    (int b, int[][] a, boolean[] alike) {
    assert a.length == 1+alike.length;
    int n=a.length, i=0;
    while (i<n) {
      if (i<n-1 && alike[i]) {
        if (compare_lo(a[i], a[i+1]) < 0) break;
      } else {
        if (!is_const(a[i], b-1)) break;
      }
      i++;
    }
    if (i>=n) return false;
    nxt_lex_lo(b, a[i]);
    i--;
    while (i >= 0) {
      int m = a[i].length;
      for (int j=0; j<m; j++)
        a[i][j] = 0;
      i--;
    }
    return true;
  }

  /**
   * Same as nxt_lex_lo, except that 0 is considered to have highest
   * order.  So the order of each sequence is reversed.
   */
  public static boolean nxt_lex_hi(int b, int[] a) {
    int n=a.length, i=n-1;
    while (i>=0) {
      if (a[i] != b-1) break;
      i--;
    }
    if (i<0) return false;
    a[i]++;
    i++;
    while (i < n) {
      a[i] = 0;
      i++;
    }
    return true;
  }

  /**
   * Modifies a permutation array a by moving it to the next
   * permutation in increasing lexicographic order, where index 0
   * has lowest order.  a should be a permutation of 0..n-1, where n
   * is the length of a.  For example, if a={1,2,3,0} then upon
   * return a={3,2,0,1}.  If a is already at the last permutation, a
   * is not modified and false is returned; else true is returned.
   * For example, if a={0,1,2,3} then false is returned.
   */
  public static boolean nxt_perm_lo(int[] a) {
    int n = a.length, i = 1;
    if (i >= n) return false;
    while (i<n) {
      if (a[i]<a[i-1]) break;
      i++;
    }
    if (i>=n) return false;
    int p = a[i], j = 0;
    while (a[j] < p) j++;
    assert j<i;
    a[i] = a[j];
    a[j] = p;
    Arrays.sort(a, 0, i); // sort 0..i-1
    // reverse:
    for (j=0; j<i/2; j++) {
      int t=a[j];
      a[j]=a[i-1-j];
      a[i-1-j]=t;
    }
    return true;
  }

  public static boolean nxt_perm_lo_2d(int[][] a) {
    int n = a.length;
    int totalLen = 0;
    for (int i=0; i<n; i++)
      totalLen += a[i].length;
    int[] tmp = new int[totalLen];
    int count = 0;
    for (int i=0; i<n; i++) {
      int m = a[i].length;
      for (int j=0; j<m; j++)
        tmp[count++] = a[i][j];
    }
    boolean result = nxt_perm_lo(tmp);
    if (!result) return false;
    count = 0;
    for (int i=0; i<n; i++) {
      int m = a[i].length;
      for (int j=0; j<m; j++)
        a[i][j] = tmp[count++];
    }
    return true;
  }

  /**
   * Same next_perm_lo, except that 0 has highest order.
   */
  public static boolean nxt_perm_hi(int[] a) {
    int n = a.length, i = n-2;
    if (i < 0) return false;
    while (i>=0) {
      if (a[i]<a[i+1]) break;
      i--;
    }
    if (i<0) return false;
    int p = a[i], j = n-1;
    while (a[j] < p) j--;
    assert j>i;
    a[i] = a[j];
    a[j] = p;
    Arrays.sort(a, i+1, n); // sort i+1..n-1
    return true;
  }


  /**
   * Increments a partition.  A k-partition of n (n>=1) is a k-tuple
   * of positive integers whose components sum to n.  These k-tuples
   * can be ordered lexicographically.  The orientation is 0-low.
   * Given such a partition, this method changes the partition to
   * the next partition under this order, if there is one.  It
   * returns true if there was a next partition, false if there was
   * not one (in which case, the given partition is unmodified).
   *
   * Algorithm: start with (a_0,a_1,...,a_{k-1}).  Working from left
   * (lowest index, 0), find the first entry which has entry to its
   * left which is not 1.  Increment that entry.  Then replace the
   * elements to its left with m,1,...,1, where m is the number that
   * makes the tuple sum to n.
   *
   * Example: the 4-partitions of 6, in order, are as follow, where
   * the 0 index is on the left:
   *
   * <pre>
   * 3,1,1,1.  i=1
   * 2,2,1,1.  i=1
   * 1,3,1,1.  i=2
   * 2,1,2,1   i=1
   * 1,2,2,1   i=2
   * 1,1,3,1   i=3
   * 2,1,1,2   i=1
   * 1,2,1,2   i=2
   * 1,1,2,2   i=3
   * 1,1,1,3
   * </pre>
   *
   * The same sequence where the 0-index is on the right is:
   * <pre>
   * 1,1,1,3
   * 1,1,2,2
   * 1,1,3,1
   * 1,2,1,2
   * 1,2,2,1
   * 1,3,1,1
   * 2,1,1,2
   * 2,1,2,1
   * 2,2,1,1
   * 3,1,1,1
   * </pre>
   */
  public static boolean nxt_partition_lo(int[] a) {
    int k = a.length, idx = 1;
    int sum = a[0];
    while (idx < k) {
      sum += a[idx];
      if (a[idx-1] > 1)
        break;
      idx++;
    }
    if (idx == k) return false;
    // sum is sum (i=0..idx) a[i].  this sum must be preserved.
    a[idx]++;
    for (int i=idx-1; i>=1; i--)
      a[i] = 1;
    // a[0] + (idx-1) + a[idx] = sum
    a[0] = 1 + sum - a[idx] - idx;
    return true;
  }

  public static boolean nxt_partition_hi(int[] a) {
    int k = a.length, idx = 1;
    int sum = a[k-1];
    while (idx < k) {
      sum += a[k-idx-1];
      if (a[k-idx] > 1)
        break;
      idx++;
    }
    if (idx == k) return false;
    // sum is sum (i=0..idx) a[k-i-1].  this sum must be preserved.
    a[k-idx-1]++;
    for (int i=idx-1; i>=1; i--)
      a[k-i-1] = 1;
    a[k-1] = 1 + sum - a[k-idx-1] - idx;
    return true;
  }

  /** 
   * Increments a parition to the next representative partition
   * under the equivalence relation induced by S_k.  The orientation
   * is 0-low.
   *
   * There is an equivalence relation on the set of k-partitions of
   * n induced by the symmetric group on 0..k-1.  A unique
   * representative from each equivalence class is obtained by
   * requiring that the components of the tuple are non-increasing
   * as the index moves from 0 to k-1.  I.e., (a[0],a[1],...,a[k-1])
   * is a representative iff a[0]>=a[1]>=...>=a[k-1].
   *
   * Algorithm: working from lowest to highest index, find the first
   * entry with idx>=1 such that if incremented, and the new value
   * stuttered all the way to the left (index 0), the resulting sum
   * will be <= n.  Increment that entry, call the resulting value
   * of that entry b, and replace the elements to its left with
   * b,b,...,b,m, where m is the number that makes the components
   * sum to n.
   * 
   * Example: the representative 4-partitions of 10, in order, are:
   *
   * <pre>
   * 7,1,1,1.  idx=1
   * 6,2,1,1.  idx=1
   * 5,3,1,1.  idx=1
   * 4,4,1,1.  idx=2
   * 5,2,2,1.  idx=1
   * 4,3,2,1.  idx=2
   * 3,3,3,1.  idx=3
   * 4,2,2,2.  idx=1
   * 3,3,2,2.
   * </pre>
   *
   * The same sequence, written with 0 on the right:
   * <pre>
   * 1,1,1,7.  idx=1
   * 1,1,2,6.  idx=1
   * 1,1,3,5.  idx=1
   * 1,1,4,4.  idx=2
   * 1,2,2,5.  idx=1
   * 1,2,3,4.  idx=2
   * 1,3,3,3.  idx=3
   * 2,2,2,4.  idx=1
   * 2,2,3,3
   * </pre>
   */
  public static boolean nxt_partition_sym_lo(int[] a) {
    int k = a.length, idx = 1;
    int sum = a[0];
    while (idx < k) {
      sum += a[idx];
      if ((idx+1)*(a[idx]+1) <= sum)
        break;
      idx++;
    }
    if (idx == k) return false;
    // sum is sum (i=0..idx) a[i].  this sum must be preserved.
    a[idx]++;
    for (int i=idx-1; i>=1; i--)
      a[i] = a[idx];
    // a[0] + idx*a[idx] = sum
    a[0] = sum - idx*a[idx];
    assert a[0]>=a[idx];
    return true;
  }

  public static boolean nxt_partition_sym_hi(int[] a) {
    int k = a.length, idx = 1;
    int sum = a[k-1];
    while (idx < k) {
      sum += a[k-idx-1];
      if ((idx+1)*(a[k-idx-1]+1) <= sum)
        break;
      idx++;
    }
    if (idx == k) return false;
    a[k-idx-1]++;
    for (int i=idx-1; i>=1; i--)
      a[k-i-1] = a[k-idx-1];
    a[k-1] = sum - idx*a[k-idx-1];
    assert a[k-1]>=a[k-idx-1];
    return true;
  }

  // Tests...

  public static void print(PrintStream out, int[] a) {
    if (a == null)
      out.print("null");
    out.print("{");
    for (int i=0; i<a.length; i++) {
      if (i>0) out.print(",");
      out.print(a[i]);
    }
    out.print("}");
  }

  public static void println(PrintStream out, int[] a) {
    print(out, a);
    out.println();
  }

  public static void print(PrintStream out, int[][] a) {
    if (a == null)
      out.print("null");
    out.print("{");
    for (int i=0; i<a.length; i++) {
      if (i>0) out.print(",");
      print(out, a[i]);
    }
    out.print("}");	    
  }

  public static void println(PrintStream out, int[][] a) {
    print(out, a);
    out.println();
  }

  private static void test_nxt_lex_lo(int n) {
    int[] a = new int[n];
    int total = 1;
    out.println("Testing nxt_lex_lo:");
    for (int i=0; i<n; i++) {
      a[i] = 0;
      total *= n;
    }
    int c = 0;
    do {
      println(out, a);
      if (c == total - 2) {
        assert a[0] == n-2;
        for (int j=1; j<n; j++)
          assert a[j] == n-1;
      } else if (c == total - 1) {
        for (int j=0; j<n; j++)
          assert a[j] == n-1;
      }
      c++;
    } while (nxt_lex_lo(n,a));
    assert c == total;
    out.println();
  }

  private static void test_nxt_lex_lo_2d(int b, int n, int m) {
    out.println("Testing nxt_lex_lo_2d:");
    int[][] a = new int[n][m];
    for (int i=0; i<n; i++)
      for (int j=0; j<m; j++)
        a[i][j] = 0;
    do {
      println(out, a);
    } while (nxt_lex_lo_2d(b, a));
    out.println();
  }

  private static void test_nxt_lex_lo_2d_sym(int n) {
    out.println("Testing nxt_lex_lo_2d_sym:");
    int m = n/2;
    // two blocks: 0..m-1 and m..n-1
    // e.g., n=5: m=2: 0..1 and 2..4
    int[][] a = new int[n][];
    for (int i=0; i<m; i++)
      a[i] = new int[2];
    for (int i=m; i<n; i++)
      a[i] = new int[3];
    for (int i=0; i<n; i++)
      for (int j=0; j<a[i].length; j++)
        a[i][j] = 0;
    boolean[] alike = new boolean[n-1];
    for (int i=0; i<m-1; i++)
      alike[i] = true;
    alike[m-1] = false;
    for (int i=m; i<n-1; i++)
      alike[i] = true;
    do {
      println(out, a);
    } while (nxt_lex_lo_2d_sym(2, a, alike));
    out.println();
  }

  private static void test_nxt_lex_hi(int n) {
    int[] a = new int[n];
    int total = 1;
    out.println("Testing nxt_lex_hi:");
    for (int i=0; i<n; i++) {
      a[i] = 0;
      total *= n;
    }
    int c = 0;
    do {
      println(out, a);
      if (c == total - 2) {
        assert a[n-1] == n-2;
        for (int j=0; j<n-1; j++)
          assert a[j] == n-1;
      } else if (c == total - 1) {
        for (int j=0; j<n; j++)
          assert a[j] == n-1;
      }
      c++;
    } while (nxt_lex_hi(n,a));
    assert c == total;
    out.println();
  }

  private static void test_nxt_perm_lo(int n) {
    int[] a = new int[n];
    int total = 1;
    out.println("Testing nxt_perm_lo:");
    for (int i=0; i<n; i++) {
      a[i] = n-1-i;
      total *=(i+1);
    }
    int c = 0;
    do {
      println(out, a);
      c++;
    } while (nxt_perm_lo(a));
    assert c == total;
    for (int i=0; i<n; i++)
      assert a[i]==i;
    out.println();
  }

  private static void test_nxt_perm_hi(int n) {
    int[] a = new int[n];
    int total = 1;
    out.println("Testing nxt_perm_hi:");
    for (int i=0; i<n; i++) {
      a[i] = i;
      total *=(i+1);
    }
    int c = 0;
    do {
      println(out, a);
      c++;
    } while (nxt_perm_hi(a));
    assert c == total;
    for (int i=0; i<n; i++)
      assert a[i]==n-i-1;
    out.println();
  }

  // k is length, n is sum
  private static void test_nxt_partition_lo(int k, int n) {
    assert n>=k;
    int a[] = new int[k];
    a[0] = n-k+1;
    for (int i=1; i<k; i++)
      a[i] = 1;
    out.println("Testing nxt_partition_lo:");
    int c = 0;
    do {
      println(out, a);
      int s = 0;
      for (int i=0; i<k; i++)
        s += a[i];
      assert s==n;
      c++;
    } while (nxt_partition_lo(a));
    for (int i=0; i<k-1; i++)
      assert a[i]==1;
    assert a[k-1]==n-k+1;
    out.println();	
  }

  private static void test_nxt_partition_hi(int k, int n) {
    assert n>=k;
    int a[] = new int[k];
    int b[] = new int[k];
    a[0] = n-k+1;
    for (int i=1; i<k; i++) a[i] = 1;
    for (int i=0; i<k; i++) b[i] = a[k-i-1];
    out.println("Testing nxt_partition_hi:");
    do {
      println(out, b);
      for (int i=0; i<k; i++)
        assert a[i] == b[k-i-1];
      nxt_partition_lo(a);
    } while (nxt_partition_hi(b));
    out.println();
  }

  private static void test_nxt_partition_sym_lo(int k, int n) {
    assert n>=k;
    int a[] = new int[k];
    a[0] = n-k+1;
    for (int i=1; i<k; i++)
      a[i] = 1;
    out.println("Testing nxt_partition_sym_lo:");
    int c = 0;
    do {
      println(out, a);
      int s = 0;
      for (int i=0; i<k; i++)
        s += a[i];
      assert s==n;
      c++;
    } while (nxt_partition_sym_lo(a));
    out.println();	
  }

  private static void test_nxt_partition_sym_hi(int k, int n) {
    assert n>=k;
    int a[] = new int[k];
    int b[] = new int[k];
    a[0] = n-k+1;
    for (int i=1; i<k; i++) a[i] = 1;
    for (int i=0; i<k; i++) b[i] = a[k-i-1];
    out.println("Testing nxt_partition_sym_hi:");
    do {
      println(out, b);
      for (int i=0; i<k; i++)
        assert a[i] == b[k-i-1];
      nxt_partition_sym_lo(a);
    } while (nxt_partition_sym_hi(b));
    out.println();
  }



  public final static void main(String[] args) {
    /*
    int n=3;
    test_nxt_lex_lo(n);
    test_nxt_lex_lo_2d(2, 3, 2);
    test_nxt_lex_hi(n);
    test_nxt_perm_lo(n);
    test_nxt_perm_hi(n);
    test_nxt_partition_lo(4, 6);
    */
    test_nxt_partition_sym_lo(4, 10);
    /*
    test_nxt_lex_lo_2d_sym(5);
    test_nxt_partition_hi(4, 6);
    */
    test_nxt_partition_sym_hi(4, 10);
    out.println("All tests pass.");
  }
}
