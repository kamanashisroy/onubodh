using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.ManyLineStrings : LineString {
	Factory<StringStructureImpl>lines;
	public ManyLineStrings(netpbmg*src
		, aroop_uword8 minGrayVal
		, int radius_shift, int[] featureVals, int[] featureOps) {
		base(src, minGrayVal, radius_shift, featureVals, featureOps);
		lines = Factory<StringStructureImpl>.for_type(16, 0, factory_flags.HAS_LOCK | factory_flags.SWEEP_ON_UNREF | factory_flags.MEMORY_CLEAN);
	}
	
	~ManyLineStrings() {
		lines.destroy();
	}
	
	void unmarkAll(int flag) {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			can.unmark(flag);
		}
		it.destroy();
	}

#if false
	public override int compile() {
		base.compile();
		if(getLength() <= 1) {
			return 0;
		}
		print("Total matrices interesting matrices:%d\n", getLength());
		int usedMark = 1<<6;
		unmarkAll(usedMark);

		// for all the matrices..
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, usedMark);
		int mshift = getShift();
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			can.mark(usedMark);
			ImageMatrix a = can.get();
			ImageMatrix c = a;
			
			// try to build a line of matrices starting from a ..
			StringStructureImpl newLine = lines.alloc_full();//new StringStructureImpl(img, mshift);
			newLine.buildStringStructureImpl(img, mshift);
			int col = a.higherOrderX;
			int row = a.higherOrderY;
			int cumx = row*columns; // cumulative value of x axis
			bool appendA = true;
			
			ZeroTangle tngl = ZeroTangle(columns);
			Iterator<AroopPointer<ImageMatrix>> itFollow = Iterator<AroopPointer<ImageMatrix>>.EMPTY();
			getIterator(&itFollow, Replica_flags.ALL, usedMark);
			while(itFollow.next()) {
				AroopPointer<ImageMatrix> can2 = itFollow.get();
				ImageMatrix b = can2.get();
				int axy = a.higherOrderXY;
				int bxy = b.higherOrderXY;
				int cxy = c.higherOrderXY;
				if(tngl.neibor100(axy, bxy) || (a!=c && tngl.neibor102(cxy, bxy))) {
					if(appendA) {
						appendA = false;
						newLine.appendMatrix(a);
					}
					newLine.appendMatrix(b);
					a = c;
					c = b;
				}
			}
			newLine.cracks = tngl.crack;
			newLine.adjacent = tngl.adjacent;
			newLine.thin();
			if((newLine.getLength() > 1) && (!pruneWhileCompile || (newLine.getLength() > requiredLength && (tngl.adjacent < newLine.getLength())))) {
				newLine.pin();
			}
			itFollow.destroy();
		}
		
		it.destroy();
		print("Total lines:%d\n", lines.count_unsafe());
		return 0;
	}
#endif

	public int prune() {
#if false
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		int i = 0;
		while(it.next()) {
			StringStructureImpl strct = it.get();
			if(strct.testFlag(PRUNE)) {
				i++;
				strct.unpin();
				continue;
			}
			int len = strct.getLengthInPixels();
			int crk = strct.getCracksInPixels();
			if(len < requiredLength || strct.adjacent >= len || crk > maxCrackLength) {
				if(i == 0)print("Prunning [%d<%d,%d>=%d,%d>%d] \n", len, requiredLength, strct.adjacent, len, crk, maxCrackLength);
				i++;
				strct.unpin();
			}
		}
		it.destroy();
		print("Pruned %d lines\n", i);
#endif
		return 0;
	}

	const int PRUNE = 1<<6;
	public override int heal() {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		while(it.next()) {
			StringStructureImpl strct = it.get();
			if(strct.testFlag(PRUNE)) {
				continue;
			}
			strct.heal();
		}
		it.destroy();
		return 0;
	}
	
	public override void fill() {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		while(it.next()) {
			StringStructureImpl strct =  it.get();
			if(strct.testFlag(PRUNE)) {
				continue;
			}
			strct.fill();
		}
		it.destroy();
	}

	const int DONE_ALREADY = 1<<7;
	public void mergeOverlapingLines() {
		while(mergeOverlapingLinesHelper());
	}
	
	bool mergeOverlapingLinesHelper() {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		bool callbackMerge = false;
		while(!callbackMerge && it.next()) {
			StringStructureImpl x = it.get();
			callbackMerge = mergeIfMatchedWithLine(x);
			if(!callbackMerge) {
				x.flagIt(DONE_ALREADY);
			}
		}
		it.destroy();
		return callbackMerge;
	}

	bool mergeIfMatchedWithLine(StringStructureImpl x) {
		bool callbackMerge = false;
		if(x.testFlag(PRUNE)) {
			x.unpin();
			return false;
		}
		if(x.testFlag(DONE_ALREADY)) {
			return false;
		}
		Iterator<StringStructureImpl> ity = Iterator<StringStructureImpl>(&lines);
		while(!callbackMerge && ity.next()) {
			StringStructureImpl y = ity.get();
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
			callbackMerge = true;
		}
		ity.destroy();
		return callbackMerge;
	}
	
#if false
	public override void dumpImage(netpbmg*oimg, aroop_uword8 gval) {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		bool high = true;
		int totalLines = 0;
		while(it.next()) {
			StringStructureImpl strct = it.get();
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
#endif
}
/** @} */
