using aroop;
using shotodol;

public class LineOrient : Replicable {
	netpbmg*img;
	netpbmg marks;
	bool should_mark;
	int degree;
	public LineOrient(netpbmg*src, bool enable_mark) {
		img = src;
		should_mark = enable_mark;
		degree = 0;
		if(should_mark) {
			marks = netpbmg.alloc_like(src);
		}
	}
	~LineOrient() {
		if(should_mark) {
			marks.close();
		}
	}

	public int nextLine() {
		return 0;
	}
}
