/*
 * Barrier.java
 *
 * Created on August 3, 2005, 10:46 PM
 *
 * From "Multiprocessor Synchronization and Concurrent Data Structures",
 * by Maurice Herlihy and Nir Shavit.
 * Copyright 2006 Elsevier Inc. All rights reserved.
 */

package barrier;

/**
 * Generic Barrier interface
 * @author Maurice Herlihy
 */
public interface Barrier {
  /**
   * Block until all threads have reached barrier.
   */
  public void await();
}
