/*
 * SynchronousQueueDualTest.java
 * JUnit based test
 *
 * Created on March 8, 2006, 8:13 PM
 */

package queue;

import junit.framework.*;
import java.util.concurrent.atomic.AtomicInteger;
import queue.FullException;

/**
 * @author Maurice Herlihy
 */
public class SynchronousDualQueueTest extends TestCase {
  private final static int THREADS = 8;
  private final static int TEST_SIZE = 512;
  private final static int PER_THREAD = TEST_SIZE / THREADS;
  int index;
  SynchronousDualQueue<Integer> instance;
  boolean[] map = new boolean[TEST_SIZE];
  Thread[] thread = new Thread[THREADS];
  
  public SynchronousDualQueueTest(String testName) {
    super(testName);
    instance = new SynchronousDualQueue<Integer>();
  }
  
  public static Test suite() {
    TestSuite suite = new TestSuite(SynchronousDualQueueTest.class);
    return suite;
  }
  
  /**
   * Parrallel enqueues, parallel dequeues
   */
  public void testParallelBoth()  throws Exception {
    System.out.println("parallel both");
    Thread[] myThreads = new Thread[2 * THREADS];
    for (int i = 0; i < THREADS; i++) {
      myThreads[i] = new EnqThread(i * PER_THREAD);
      myThreads[i + THREADS] = new DeqThread();
    }
    for (int i = 0; i < 2 * THREADS; i ++) {
      myThreads[i].start();
    }
    for (int i = 0; i < 2 * THREADS; i ++) {
      myThreads[i].join();
    }
  }
  class EnqThread extends Thread {
    int value;
    EnqThread(int i) {
      value = i;
    }
    public void run() {
      for (int i = 0; i < PER_THREAD; i++) {
        instance.enq(value + i);
      }
    }
  }
  class DeqThread extends Thread {
    public void run() {
      for (int i = 0; i < PER_THREAD; i++) {
        int value = instance.deq();
        if (map[value]) {
          fail("DeqThread: duplicate pop");
        }
        map[value] = true;
      }
    }
  }
  
}