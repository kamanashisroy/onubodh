using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.ManyLineStrings : LineString {
	Set<StringStructureImpl> lines;
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
		lines = Set<StringStructureImpl>();
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
		print("Total matrices interesting matrices:%d\n", getLength());
		int usedMark = 1<<6;
		unmarkAll(usedMark);

		// for all the matrices..
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, usedMark);
		int mshift = getShift();
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix a = can.get();
			//can.mark(usedMark);
			/*if(can.testFlag(usedMark)) {
				continue;
			}*/
			
			// try to build a line of matrices starting from a ..
			StringStructureImpl newLine = new StringStructureImpl(img, mshift);
			int col = a.higherOrderX;
			int row = a.higherOrderY;
			int xval = row*columns;
			int gap = 0;
			int cont = 0;//100;
			
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
					gap+=(1<<mshift);
					continue;
				}
				cont+=b.continuity;
				cont-=gap;
				print("(%d)", b.continuity);
				//b.flagIt(usedMark);
				newLine.appendMatrix(b);
				col = b.higherOrderX;
				gap = 0;
			}
			print("Cracks:%d, Continuity:%d\n", gap, cont);
			if(newLine.getLength() > requiredLength && cont > requiredContinuity) {
				newLine.setContinuity(cont);
				lines.add(newLine);
			}
		}
		
		it.destroy();
		print("Total lines:%d\n", lines.count_unsafe());
		return 0;
	}
	
	const int PRUNE = 1<<6;
	public override int heal() {
		Iterator<container<StringStructureImpl>> it = Iterator<container<StringStructureImpl>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<StringStructureImpl> can = it.get();
			StringStructureImpl strct =  can.get();
			if(strct.testFlag(PRUNE)) {
				continue;
			}
			strct.heal();
		}
		it.destroy();
		return 0;
	}
	
	public override void fill() {
		Iterator<container<StringStructureImpl>> it = Iterator<container<StringStructureImpl>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<StringStructureImpl> can = it.get();
			StringStructureImpl strct =  can.get();
			if(strct.testFlag(PRUNE)) {
				continue;
			}
			strct.fill();
		}
		it.destroy();
	}
	
	public void mergeOverlapingLines() {
		Iterator<container<StringStructureImpl>> it = Iterator<container<StringStructureImpl>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		int totalLines = 0;
		while(it.next()) {
			container<StringStructureImpl> can = it.get();
			StringStructureImpl x = can.get();
			if(x.testFlag(PRUNE)) {
				continue;
			}
			totalLines++;
			Iterator<container<StringStructureImpl>> ity = Iterator<container<StringStructureImpl>>.EMPTY();
			lines.iterator_hacked(&ity, Replica_flags.ALL, 0, 0);
			while(ity.next()) {
				container<StringStructureImpl> cany = ity.get();
				StringStructureImpl y = cany.get();
				if(x == y) {
					continue;
				}
				if(y.testFlag(PRUNE)) {
					continue;
				}
				if(!x.overlaps(y) && !x.neibor(y)) {
					continue;
				}
				x.merge(y);
				y.flagIt(PRUNE);
			}
			ity.destroy();
		}
		it.destroy();
		print("Merged to %d lines\n", totalLines);
	}

	
	public override void dumpImage(netpbmg*oimg, aroop_uword8 gval) {
		Iterator<container<StringStructureImpl>> it = Iterator<container<StringStructureImpl>>.EMPTY();
		lines.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		bool high = true;
		int totalLines = 0;
		while(it.next()) {
			container<StringStructureImpl> can = it.get();
			StringStructureImpl strct = can.get();
			if(strct.testFlag(PRUNE)) {
				continue;
			}
			totalLines++;
			strct.dumpImage(oimg, high?gval:(gval>>1));
			high = !high;
		}
		it.destroy();
		print("Dumped %d lines\n", totalLines);
	}
}
/** @} */
