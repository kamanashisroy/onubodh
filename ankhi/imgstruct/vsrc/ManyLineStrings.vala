using aroop;
using shotodol;
using onubodh;

public class onubodh.ManyLineStrings : LineString {
	Set<StringStructure> lines;
	int maxCrackLength;
	int requiredContinuity;
	int requiredLength;
	public ManyLineStrings(netpbmg*src
		, int myMaxCrackLength
		, int myRequiredContinuity
		, int myRequiredLength
		, aroop_uword8 minGrayVal
		, int radius_shift) {
		base(src, minGrayVal, radius_shift);
		lines = Set<StringStructure>();
		maxCrackLength = myMaxCrackLength;
		requiredContinuity = myRequiredContinuity;
		requiredLength = myRequiredLength;
	}
	
	~ManyLineStrings() {
		lines.destroy();
	}
	
	void unmarkAll(int flag) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			can.unmark(flag);
		}
		it.destroy();
	}
	
	public override int compile() {
		base.compile();
		if(getLength() <= 1) {
			return 0;
		}
		print("Total matrices we are investigating next:%d\n", getLength());
		int usedMark = 1<<6;
		unmarkAll(usedMark);

		// for all the matrices..
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, usedMark);
		
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix a = can.get();
			//can.mark(usedMark);
			/*if(can.testFlag(usedMark)) {
				continue;
			}*/
			
			// try to build a line of matrices starting from a ..
			StringStructure newLine = new StringStructure();
			int col = a.higher_order_x();
			int row = a.higher_order_y();
			int xval = row*columns;
			int gap = 0;
			int cont = 0;
			
			for(;row < rows && gap <= maxCrackLength;(xval+=columns),row++) {
				int xy = col+xval;
				ImageMatrix?b = getMatrixAt(xy);
				if(b == null && col != (columns-1)) {
					xy++;
					b = getMatrixAt(xy+1);
				}
				if(b == null && col != 0) {
					xy--;xy--;
					b = getMatrixAt(xy-1);
				}
				if(b == null) {
					gap++;
					cont--;
					continue;
				}
				//b.flagIt(usedMark);
				newLine.setMatrixAt(xy, b);
				col = b.higher_order_x();
				gap = 0;
				cont++;
			}
			if(newLine.getLength() > requiredLength && cont > requiredContinuity) {
				newLine.setContinuity(cont);
				lines.add(newLine);
			}
		}
		it.destroy();
		print("Total lines:%d\n", lines.count_unsafe());
		return 0;
	}
	
	public override int heal() {
		Iterator<container<StringStructure>> it = Iterator<container<StringStructure>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<StringStructure> can = it.get();
			can.get().heal();
		}
		it.destroy();
		return 0;
	}
	
	public override void fill() {
		Iterator<container<StringStructure>> it = Iterator<container<StringStructure>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<StringStructure> can = it.get();
			can.get().fill();
		}
		it.destroy();
	}

	
	public override void dumpImage(netpbmg*oimg, aroop_uword8 gval) {
		Iterator<container<StringStructure>> it = Iterator<container<StringStructure>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		bool high = true;
		while(it.next()) {
			container<StringStructure> can = it.get();
			can.get().dumpImage(oimg, high?gval:(gval>>1));
			high = !high;
		}
		it.destroy();
	}
}
