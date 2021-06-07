package hash;

public class Driver {
	
	private static StripedCuckooHashSet<Integer> set;
	
	private static class AddThread extends Thread {
		public void run() {
			set.add(0);
			set.add(1);
			set.add(2);
			System.out.println("Add ops complete.");
		}
	}
	
	private static class RemoveThread extends Thread {
		public void run() {
			set.remove(0);
			set.remove(1);
			set.remove(2);
			System.out.println("Remove ops complete.");
		}
	}

	public static void main(String[] args) throws InterruptedException {
		set = new StripedCuckooHashSet<Integer>(1);
		Thread addT = new AddThread();
		Thread removeT = new RemoveThread();
		addT.start();
		removeT.start();
		removeT.join();
		System.out.print("{");
		for (int i = 0; i < 4; i++) {
			if (set.contains(i)) {
				System.out.print(" " + i + " ");
			}
		}
		System.out.println("}");
	}

}
