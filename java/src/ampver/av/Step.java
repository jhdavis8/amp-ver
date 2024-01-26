package av;

/** A Step represents one operation executed by a thread.  It is
 * either an ADD, REMOVE, or CONTAINS operation. */
public class Step {

    public final static int UNDEF = -2;
    public static enum Op {
	ADD,
	REMOVE,
	CONTAINS
    };
    
    Op op;
    int arg0 = UNDEF;
    int arg1 = UNDEF; 
    int result = UNDEF;
    int start_time = UNDEF;
    int stop_time = UNDEF;

    Step(Op op) {
	this.op = op;
    }

    Step(Op op, int arg0) {
	this.op = op;
	this.arg0 = arg0;
    }
    
    Step(Op op, int arg0, int arg1) {
	this.op = op;
	this.arg0 = arg0;
	this.arg1 = arg1;
    }
    

    public String toString() {
	String result;
	switch (op) {
	case ADD:
	    result = "ADD(";
	    break;
	case REMOVE:
	    result = "REMOVE(";
	    break;
	case CONTAINS:
	    result = "CONTAINS(";
	    break;
	default:
	    return "UNKNOWN";
	}
	if (arg0 != UNDEF) result += ""+arg0;
	if (arg1 != UNDEF) result += ","+arg1;
	result += ")";
	return result;
    }
}
