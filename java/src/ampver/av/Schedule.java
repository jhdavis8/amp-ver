package av;
import java.io.PrintStream;

public class Schedule {

  /** Kind of data structure */
  public static enum DSKind {
    SET, // a set
    QUEUE, // FIFO queue
    PQUEUE // priority queue
  };

  int id=-1; // ID number
  DSKind kind; // kind of data structure
  int nthread; // number of threads
  int nstep; // total number of steps (excluding presteps)
  Step[] presteps; // steps to be executed before threads
  Step[][] steps; // steps for each thread, length nthread

  Schedule(DSKind kind) {
    this.kind = kind;
  }

  public void print(PrintStream out) {
    out.println("begin schedule[id="+id+" kind="+kind+"]");
    out.print("  presteps  = {");
    for (int i=0; i<presteps.length; i++) {
      if (i>0) out.print(", ");
      out.print(presteps[i]);
    }
    out.println("}");
    for (int i=0; i<nthread; i++) {
      out.print("  thread["+i+"] = {");
      for (int j=0; j<steps[i].length; j++) {
        if (j>0) out.print(", ");
        out.print(steps[i][j]);
      }
      out.println("}");
    }
    out.println("end schedule");
  }
}
