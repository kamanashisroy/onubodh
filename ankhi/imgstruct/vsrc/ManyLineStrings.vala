using aroop;
using shotodol;
using onubodh;

public class onubodh.ManyLineStrings : LineString {
	Set<StringStructure> lines;
	public ManyLineStrings(netpbmg*src) {
		base(src);
		lines = Set<StringStructure>();
	}
	
	~ManyLineStrings() {
		lines.destroy();
	}
	
	void unmarkAll(int flag) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			can.unmark(flag);
		}
		it.destroy();
	}
	
	public int compile() {
		compileLine();
		if(strings.count_unsafe() <= 1) {
			return 0;
		}
		print("Total matrices we are investigating next:%d\n", strings.count_unsafe());
		int usedMark = 1<<6;
		unmarkAll(usedMark);
		
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, usedMark, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix a = can.get();
			can.mark(usedMark);
			if(a.testFlag(usedMark)) {
				continue;
			}
			
			StringStructure newLine = new StringStructure();
			int col = a.higher_order_x();
			int row = a.higher_order_y();
			int gap = 0;
			
			for(;row < rows && gap < 4;row++) {
				ImageMatrix?b = strings.get(col*columns+row);
				if(b == null && col != (columns-1)) {
					b = strings.get(col+1+row*columns);
				}
				if(b == null && col != 0) {
					b = strings.get(col-1+row*columns);
				}
				if(b != null) {
					b.flagIt(usedMark);
					newLine.append(b.higher_order_x()+b.higher_order_y()*columns, b);
					col = b.higher_order_x();
					gap = 0;
				} else {
					gap++;
				}
			}
			if(newLine.strings.count_unsafe() > 0) {
				lines.add(newLine);
			}
		}
		it.destroy();
		print("Total lines:%d\n", lines.count_unsafe());
		return 0;
	}
	
	public override void dumpImage(netpbmg*oimg) {
		Iterator<container<StringStructure>> it = Iterator<container<StringStructure>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<StringStructure> can = it.get();
			StringStructure ln = can.get();
			if(ln.strings.count_unsafe() > 4) {
				ln.dumpImage(oimg);
			}
		}
		it.destroy();
	}
}
