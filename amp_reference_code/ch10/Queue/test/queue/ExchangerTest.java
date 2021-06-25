/*
 * ExchangerTest.java
 * JUnit based test
 *
 * Created on May 19, 2007, 11:29 PM
 */

package queue;

import java.util.Arrays;
import junit.framework.*;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

/**
 *
 * @author mph
 */
public class ExchangerTest extends TestCase {
  private final static int THREADS = 8;
  Exchanger<Integer> instance = new Exchanger<Integer>();
  int[] results = new int[THREADS];
  
  public ExchangerTest(String testName) {
    super(testName);
  }
  
  protected void setUp() throws Exception {
  }
  
  protected void tearDown() throws Exception {
  }
  
  /**
   * Test of exchange method, of class queue.Exchanger.
   */
  public void testExchange() throws Exception {
    System.out.println("exchange");
    Arrays.fill(results, -1);
    Thread[] myThreads = new Thread[THREADS];
    for (int i = 0; i < THREADS; i++) {
      myThreads[i] = new ExchangeThread(i);
    }
    for (Thread thread : myThreads) {
      thread.start();
    }
    for (Thread thread : myThreads) {
      thread.join();
    }
    for (int i = 0; i < results.length; i++) {
      if (i != results[results[i]]) {
        System.out.println("ERROR:");
        System.out.printf("\t%d\t->%d\n", i, results[i]);
        System.out.printf("\t%d\t->%d\n", results[i], results[results[i]]);
      }
    }
    System.out.println("OK");
  }
  class ExchangeThread extends Thread {
    int value;
    public ExchangeThread(int index) {
      value = index;
    }
    public void run() {
      int newValue = -1;
      try {
        newValue = instance.exchange(value, Integer.MAX_VALUE, TimeUnit.MILLISECONDS);
      } catch (InterruptedException ex) {
        ex.printStackTrace();
      } catch (TimeoutException ex) {
        ex.printStackTrace();
      }
      results[value] = newValue;
    }
  }
  
}
