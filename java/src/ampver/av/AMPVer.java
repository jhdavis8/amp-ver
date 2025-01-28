package av;
import dev.civl.mc.run.IF.UserInterface;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Iterator;
import static av.Schedule.DSKind;
import static av.Schedule.DSKind.*;
import static av.Step.Op;
import static av.Step.Op.*;

public class AMPVer {

  public final static PrintStream out = System.out;

  public static enum Property {
    SC, // sequential consistency
    LINEAR, // linearizability
    QUIESCENT // quiescent consistency
  };

  /** start time (nanoseconds) */
  private long time0;

  /**
   * Path to the directory containing subdirectories named include and
   * src with auxiliary verification files.  Set on command line by
   * -root=/path/to/models.  Default: working directory.  */
  private File rootDir = new File(System.getProperty("user.dir"));

  /** The directory used to make schedule files. */
  private File tmpDir = null;

  /** The core commands that will be used for every schedule */
  private ArrayList<String> coreCommands = new ArrayList<>();

  /** Input files. */
  private ArrayList<String> filenames = new ArrayList<>();

  /** Options to pass directly to civl */
  private ArrayList<String> civlOptions = new ArrayList<>();

  /**
   * The kind of data structure being analyzed.  Set on command line
   * by -kind=set|queue|pqueue (default: set). */
  private DSKind kind = SET;

  /**
   * Used for sets: strict upper bound on values.
   */
  private int valueBound = 2;

  /** Lower bound on number of threads in a schedule. Default: 1.*/
  private int nthread_lo = 1;

  /** Upper bound on number of threads in a schedule. Default: 3. */
  private int nthread_hi = 3;

  /** Lower bound on number of steps in a schedule (excluding
   * pre-adds). Default: 1. */
  private int nstep_lo = 1;

  /** Upper bound on number of steps in a schedule (excluding
   * pre-adds). Default: 3. */
  private int nstep_hi = 3;

  /** Lower bound on number of pre-adds in a schedule.  These are additions
   * to the data structure that are made before the concurrently executing
   * threads are created. Default: 0. */
  private int npreAdd_lo = 0;

  /** Upper bound on number of pre-adds in a schedule. Default: 1. */
  private int npreAdd_hi = 1;

  /** Values added are considered irrelevant and interchangeable.
   *  Default: true. */
  private boolean genericVals = true;

  /** For PQUEUEs, every element added will have a unique priority.
   * Default: false.  */
  private boolean distinctPriorities = false;

  /** In any schedule, the number of adds will be greater than or
   * equal to the number of removes. Default: true. */
  private boolean addsDominate = false;

  /** Threads are assumed to be symmetric, so any permutation of
   * thread IDs is considered to yield the same schedule.  Default:
   * true. */
  private boolean threadSym = true;

  /** If true, skip schedules in which every operation is ADD. */
  private boolean noAllAdd = false;

  /** Perform a dry run: print the CIVL commands without executing
   * them. */
  private boolean dryrun = false;

  /** If true, immediately clean up .out and .cvl files for a schedule
      after it has been verified unless it fails. */
  private boolean tidy = false;

  /** By default, the hash function is the identity.  For nondeterministic
   * hashing, choose ND. */
  private boolean hashND = false;

  /** Strict upper bound on the values returned by the hash function when
   * using ND hashing.   Ignored for ident hashing. 
   */
  private int hashRangeBound = -1;

  /** Strict upper bound on the inputs to the hash function when using
   * ND hashing.  The input to the hash function is reduced to a value
   * in [0,hash_vb-1] first.  Ignored for ident hashing. */
  private int hashDomainBound = -1;

  /** Is the CIVL option -fair included in the command line?  If so,
   * add -DFAIR.  This option means that when checking termination,
   * unfair cycles will be ignored. */
  private boolean fair = false;

  /**
    The kind of specification to use for the concurrent data
    structure.  This string is also the prefix of the name of the
    oracle file.  Currently supported "nonblocking" (default),
    "bounded", and "sync".  Nonblocking: all calls are expected to
    return in all cases.  Bounded: a call to add will block if the
    collection is full; a call to remove will block if the collection
    is empty.  Sync: a call to add cannot complete unless matching
    call to remove is made.
  */
  private String spec = "nonblocking";

  private Property property = Property.LINEAR;

  /**
     If nonnegative, this is the capacity of the data structure,
     i.e., the maximum number of entries it can hold.
  */
  private int capacity = -1;

  /** Number of Java threads to use */
  private int ncore = 4;

  /** Iterator over schedules. */
  private Iterator<Schedule> schedIter = null;

  /**  Schedule ID for next schedule */
  private int sid = 0;

  // Methods...

  private void err(String msg) {
    System.err.println(msg);
    System.err.flush();
    out.flush();
    System.exit(1);
  }

  private String kindStr() {
    if (kind == SET) return "set";
    if (kind == QUEUE) return "queue";
    if (kind == PQUEUE) return "pqueue";
    throw new RuntimeException("unreachable");
  }

  private void makeCoreCommands() {
    File includeDir = new File(rootDir, "include");
    File srcDir = new File(rootDir, "src");
    File driverDir = new File(srcDir, "driver");
    File driverSrc =
      new File(driverDir,
               (property == Property.QUIESCENT ? "driver_q.cvl" : "driver.cvl"));
    File colSrc = new File(driverDir, kindStr() + "_collection.cvl");
    File permsSrc = new File(driverDir, "perm.c");
    File scheduleSrc = new File(driverDir, "schedule.cvl");
    File utilDir = new File(srcDir, "util");
    File tidSrc = new File(utilDir, "tid.cvl");
    File oracleSrc = new File(driverDir, spec+"_"+kindStr()+"_oracle.cvl");
    
    coreCommands.add("verify");
    coreCommands.addAll(civlOptions);
    if (fair) {
      coreCommands.add("-fair");
      coreCommands.add("-DFAIR");
    }
    if (property == Property.SC) {
      coreCommands.add("-DNLINEAR");
      // since SC and LINEAR share a common driver.
      // QUIESCENT uses a different driver
    }
    coreCommands.add("-userIncludePath="+includeDir);
    if (hashND) {
      coreCommands.add("-DHASH_ND");
      coreCommands.add("-inputVAL_B="+hashDomainBound);
      coreCommands.add("-inputHASH_B="+hashRangeBound);
    }
    if (capacity >= 0) {
      coreCommands.add("-DCAPACITY="+capacity);
    }
    coreCommands.add(driverSrc.toString());
    coreCommands.add(colSrc.toString());
    coreCommands.add(oracleSrc.toString());
    coreCommands.add(permsSrc.toString());
    coreCommands.add(scheduleSrc.toString());
    coreCommands.add(tidSrc.toString());
    coreCommands.addAll(filenames);
  }

  private int nat(String key, String value) {
    try {
      int n = Integer.parseInt(value);
      if (n < 0)
        err("Expected nonnegative integer value for "+key+" but saw "+n);        
      return n;
    } catch (NumberFormatException e) {
      err("Expected integer value for "+key+" but saw "+ value);
    }
    throw new RuntimeException("unreachable");
  }

  private int getLow(String key, String value) {
    // value has form "ddd..ddd" or "ddd"
    int dotIdx = value.indexOf("..");
    if (dotIdx < 0) {
      return nat(key, value);
    } else {
      String left = value.substring(0, dotIdx);
      int low = Integer.parseInt(left);
      if (low < 0)
        err(key+" requires nonnegative range but saw "+ left);
      return low;
    }
  }

  private int getHigh(String key, String value) {
    // value has form "ddd..ddd" or "ddd"
    int dotIdx = value.indexOf("..");
    if (dotIdx < 0) {
      return nat(key, value);
    } else {
      String right = value.substring(dotIdx+2);
      int high = Integer.parseInt(right);
      if (high < 0)
        err(key+" requires nonnegative range by saw "+ right);
      return high;
    }
  }

  private boolean bool(String key, String value) {
    if (value.equals("true")) {
      return true;
    } else if (value.equals("false")) {
      return false;
    } else {
      err("Expected either true or false for "+key+" but saw "+value);
    }
    throw new RuntimeException("unreachable");
  }

  /**
   * Syntax: sequence of args, each of which is either a filename
   * or an option, which starts with the character '-'.  An option
   * has the form -X or -X=Y.  The form -X is equivalent to -X=true.
   */
  private void parseCommandLine(String[] args) throws IOException {
    int n = args.length;
    for (int i=0; i<n; i++) {
      String arg = args[i];
      if (!arg.startsWith("-")) {
        filenames.add(arg);
        continue;
      }
      String key, value;
      int eqidx = arg.indexOf('=');
      if (eqidx < 0) {
        key = arg.substring(1);
        value = "true";
      } else {
        key = arg.substring(1, eqidx);
        value = arg.substring(eqidx+1);
      }
      switch (key) {
      case "root":
        rootDir = new File(value);
        break;
      case "tmpDir":
        tmpDir = new File(value);
        break;
      case "kind":
        switch (value) {
        case "set":
          kind = SET;
          break;
        case "queue":
          kind = QUEUE;
          break;
        case "pqueue":
          kind = PQUEUE;
          break;
        default:
          err("Unknown kind: "+value+
              "\nkind must be one of set, queue, pqueue");
        }
        break;
      case "valueBound":
        valueBound = nat(key, value);
        break;
      case "nthread":
        nthread_lo = getLow(key, value);
        nthread_hi = getHigh(key, value);
        break;
      case "nstep":
        nstep_lo = getLow(key, value);
        nstep_hi = getHigh(key, value);
        break;
      case "npreAdd":
        npreAdd_lo = getLow(key, value);
        npreAdd_hi = getHigh(key, value);
        break;
      case "genericVals":
        genericVals = bool(key, value);
        break;
      case "distinctPriorities":
        distinctPriorities = bool(key, value);
        break;
      case "addsDominate":
        addsDominate = bool(key, value);
        break;
      case "threadSym":
        threadSym = bool(key, value);
        break;
      case "noAllAdd":
        noAllAdd = bool(key, value);
        break;
      case "dryrun":
        dryrun = bool(key, value);
        break;
      case "tidy":
        tidy = bool(key, value);
        break;
      case "hashKind":
        if (value.equals("nd"))
          hashND=true;
        else if (value.equals("ident"))
          hashND=false;
        else
          err("-hashKind expects either nd (nondeterministic) or "+
              "ident (identity)");
        break;
      case "hashDomainBound":
        hashDomainBound = nat(key, value);
        break;
      case "hashRangeBound":
        hashRangeBound = nat(key, value);
        break;
      case "fair":
        fair = bool(key, value);
        break;
      case "property":
        switch(value) {
        case "sc":
          property = Property.SC;
          break;
        case "linear":
          property = Property.LINEAR;
          break;
        case "quiescent":
          property = Property.QUIESCENT;
          break;
        default:
          err("-property expects one of sc, linear, quiescent");
        }
        break;
      case "ncore":
        ncore = nat(key, value);
        break;
      case "spec":
        spec = value;
        break;
      case "capacity":
        capacity = nat(key, value);
        break;
      default:
        civlOptions.add(arg);
      }
    }
    if (tmpDir == null) {
      Path workingPath =
        FileSystems.getDefault().getPath("");
      Path tmpPath = Files.createTempDirectory(workingPath, "AVREP_");
      tmpDir = tmpPath.toFile();
    } else {
      // make the directory if it isn't already there
      tmpDir.mkdir();
    }
    if (filenames.isEmpty())
      err("No filename specified on command line");
    if (!("nonblocking".equals(spec) || "bounded".equals(spec) ||
          "sync".equals(spec)))
      err("spec must be one of nonblocking, bounded, or sync");
    if (valueBound < 1)
      err("valueBound must be at least 1");
    if (nthread_lo < 1)
      err("nthread_lo ("+nthread_lo+") must be at least 1");
    if (nthread_lo > nthread_hi)
      err("nthread_lo ("+nthread_lo+") cannot be greater than nthread_hi ("+
          nthread_hi+")");
    if (nstep_lo < 1)
      err("nstep_lo ("+nstep_lo+") must be at least 1");
    if (nstep_lo > nstep_hi)
      err("nstep_lo ("+nstep_lo+") cannot be greater than nstep_hi ("+
          nstep_hi+")");
    if (npreAdd_lo > npreAdd_hi)
      err("npreAdd_lo ("+npreAdd_lo+") cannot be greater than npreAdd_hi ("+
          npreAdd_hi+")");
    if (ncore < 1)
      err("ncore must be at least 1 but saw "+ncore);
    if (hashND) {
      if (hashDomainBound < 1)
        err("Nondeterministic hashing (-hashKind=nd) requires "+
            "-hashDomainBound=N for N>=1");
      if (hashRangeBound < 1)
        err("Nondeterministic hashing (-hashKind=nd) requires "+
            "-hashRangeBound=N for N>=1");
    } else {
      if (hashDomainBound != -1)
        err("-hashDomainBound can only be used with nondeterministic hashing"+
            " (-hashKind=nd)");
      if (hashRangeBound != -1)
        err("-hashRangeBound can only be used with nondeterministic hashing"+
            " (-hashKind=nd)");
    }
    out.println("Generating schedules for "+
                "nthread="+nthread_lo+".."+nthread_hi+" "+
                "nstep="+nstep_lo+".."+nstep_hi+" "+
                "npreAdd="+npreAdd_lo+".."+npreAdd_hi);
    out.print("hashND="+hashND);
    if (hashND) {
      out.print(" hashDomainBound="+hashDomainBound+
                " hashRangeBound="+hashRangeBound);
    }
    out.println();
    out.println("genericVals="+genericVals+" "+
                "distinctPriorities="+distinctPriorities+" "+
                "addsDominate="+addsDominate+" "+
                "threadSym="+threadSym+" "+
                "noAllAdd="+noAllAdd);
    out.println("dryrun="+dryrun+" tidy="+tidy+" ncore="+ncore);
    out.println();
  }

  private void makeScheduleIterator() {
    switch (kind) {
    case SET:
      schedIter = new SetScheduleIterator
        (nthread_lo, nthread_hi, nstep_lo, nstep_hi, npreAdd_lo,
         npreAdd_hi, valueBound, threadSym);
      break;
    case QUEUE:
      schedIter = new QueueScheduleIterator
        (nthread_lo, nthread_hi, nstep_lo, nstep_hi, npreAdd_lo, npreAdd_hi,
         genericVals, addsDominate, threadSym);
      break;
    case PQUEUE:
      schedIter = new PQScheduleIterator
        (nthread_lo, nthread_hi, nstep_lo, nstep_hi, npreAdd_lo, npreAdd_hi,
         genericVals, distinctPriorities, addsDominate, threadSym, noAllAdd);
      break;
    default:
      throw new RuntimeException("unreachable");
    }
  }

  /**
   * How many arguments does an operation (ADD/REMOVE/CONTAIN)
   * for a given kind of data structure take?
   */
  private int numArgs(DSKind kind, Op op) {
    if (kind == SET) return 1;
    // note that queues and priority queues do not support CONTAINS
    if (kind == QUEUE)
      return op == Op.ADD ? 1 : (op == Op.REMOVE ? 0 : -1);
    if (kind == PQUEUE)
      return op == Op.ADD ? 2 : (op == Op.REMOVE ? 0 : -1);
    throw new RuntimeException("unreachable");
  }

  void writeSchedule(PrintStream out, Schedule sched) {
    int id = sched.id;
    int nthread = sched.nthread;
    int npreAdd = sched.presteps.length;
    DateTimeFormatter dtf =
      DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
    LocalDateTime now = LocalDateTime.now();  
    out.print("/* Schedule "+id+" of ");
    out.print(dtf.format(now));
    out.println(" */");
    out.println("#include \"driver.h\"");
    out.println("#include \"schedule.h\"");
    out.println("#include <stdlib.h>");
    out.println("schedule_t make_schedule() {");
    out.println("  schedule_t sched;");
    out.println("  int nthread = "+nthread+";");
    out.println("  sched.kind = "+sched.kind+";");
    out.print("  sched.num_ops = ");
    if (sched.kind == SET)
      out.print("3");
    else
      out.print("2");
    out.println(";");
    out.println("  sched.nthread = nthread;");
    out.println("  sched.npreAdd = "+npreAdd+";");
    if (npreAdd == 0)
      out.println("  sched.preAdds = NULL;");
    else {
      out.println("  sched.preAdds = malloc("+npreAdd+"*sizeof(step_t));");
      for (int i=0; i<npreAdd; i++) {
        Step step = sched.presteps[i];
        out.print("  sched.preAdds["+i+"] = schedule_make_step_2(ADD, ");
        out.println(step.arg0+", "+step.arg1+");");
      }
    }
    out.println("  sched.nstep = "+sched.nstep+";");
    out.println("  sched.nsteps = malloc(nthread*sizeof(int));");
    for (int i=0; i<nthread; i++) {
      out.println("  sched.nsteps["+i+"] = "+sched.steps[i].length+";");
    }
    out.println("  sched.steps = malloc(nthread*sizeof(step_t*));");
    out.println("  for (int i=0; i<nthread; i++)");
    out.print("    sched.steps[i] = ");
    out.println("malloc(sched.nsteps[i]*sizeof(step_t));");
    for (int i=0; i<nthread; i++) {
      for (int j=0; j<sched.steps[i].length; j++) {
        Step step = sched.steps[i][j];
        int narg = numArgs(kind, step.op);
        out.print("  sched.steps["+i+"]["+j+"] = ");
        out.print("schedule_make_step_"+narg+"("+step.op);
        if (narg > 0) out.print(", "+step.arg0);
        if (narg > 1) out.print(", "+step.arg1);
        out.println(");");
      }
    }
    out.println("  return sched;");
    out.println("}");
  }

  void printTime() {
    out.println("Time (seconds) = "+
                0.1*((System.nanoTime() - time0)/100000000L));
  }

  void executeSchedule(Schedule sched) {
    int id = sched.id;
    File sfile = new File(tmpDir, "schedule_"+id+".cvl");
    ArrayList<String> commands = new ArrayList<>();
    commands.addAll(coreCommands);
    commands.add(sfile.toString());
    /*
    out.print("civl ");
    for (String str:commands)
      out.print(str+" ");
    out.println();
    out.println();
    */
    PrintStream sout = null;
    try {
      sout = new PrintStream(sfile);
    } catch (FileNotFoundException e) {
      System.err.println(e);
      System.err.flush();
      out.flush();
      System.exit(1);
    }
    writeSchedule(sout, sched);
    sout.close();
    if (!dryrun) {
      String[] commandArray = commands.toArray(new String[0]);
      File outFile = new File(tmpDir, "schedule_"+id+".out");
      PrintStream outStream = null;
      try {
        outStream = new PrintStream(outFile);
      } catch (FileNotFoundException e) {
        System.err.println(e);
        System.err.flush();
        out.flush();
        System.exit(1);
      }
      UserInterface ui = new UserInterface(outStream, outStream);
      boolean result = ui.run(commandArray);
      outStream.close();
      if (!result) {
        out.println("AMPVer: error detected on schedule "+id+
                    ".  Exiting.");
        printTime();
        System.err.flush();
        out.flush();
        System.exit(2);
      } else if (tidy) {
        sfile.delete();
        outFile.delete();
      }
    } else if (tidy) {
      sfile.delete();
    }
  }

  synchronized Schedule getTask(int wid) {
    if (schedIter.hasNext()) {
      Schedule result = schedIter.next();
      result.id = sid;
      out.println("Worker "+wid+" working on schedule "+sid);
      result.print(out);
      out.println();
      sid++;
      return result;
    }
    return null;
  }

  class Worker extends Thread {
    int wid = -1;

    Worker(int wid) {
      this.wid = wid;
    }
    
    public void run() {
      out.println("Worker "+wid+" starting");
      while (true) {
        Schedule sched = getTask(wid);
        if (sched == null) break;
        executeSchedule(sched);
      }
      out.println("Worker "+wid+" terminating");
    }
  }

  void execute() throws IOException {
    time0 = System.nanoTime();
    Worker[] workers = new Worker[ncore];
    for (int i=0; i<ncore; i++) {
      workers[i] = new Worker(i);
      workers[i].start();
    }
    for (int i=0; i<ncore; i++) {
      try {
        workers[i].join();
      } catch (InterruptedException e) {
        out.println("Thread "+i+" interrupted");
        System.err.flush();
        out.flush();
        System.exit(1);
      }
    }
    out.println(sid+" schedules generated.  All tests pass.");
    printTime();
  }
  
  public static void main(String[] args) throws IOException {
    System.out.println("AMP Verification Driver v0.1");
    AMPVer av = new AMPVer();
    av.parseCommandLine(args);
    av.makeCoreCommands();
    av.makeScheduleIterator();
    av.execute();
  }
}
