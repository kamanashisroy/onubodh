using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.ManyLineStrings : LineString {
	//Set<StringStructureImpl> lines;
	Factory<StringStructureImpl>lines;
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
		lines = Factory<StringStructureImpl>.for_type(16, 0, factory_flags.HAS_LOCK | factory_flags.SWEEP_ON_UNREF | factory_flags.MEMORY_CLEAN);
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

#if true
	/**
	 * \brief It takes twin points to check linearity/Connectivity.
	 **/
	public bool checkLinearMatrix(ImageMatrix a, ImageMatrix b, StringStructureImpl newLine, bool append_a, int*disc, int*direction) {
		int diff = b.higherOrderXY - a.higherOrderXY; // cumulative distance of the points in the matrix
		int mod = diff % columns;
		bool right = ((*direction) >= 0 && mod == 1);
		bool left = ((*direction) <= 0 && mod == (columns-1));
		if(diff >= (columns-1)
			&& (left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			if(append_a) {
				newLine.appendMatrix(a);
			}
			newLine.appendMatrix(b);
			if((*direction == 0) && (right || left))
				 *direction = right?1:-1;
			(*disc)/* calculate the missing points in the line */=diff/columns;
			return true;
		}
		return false;
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
			ImageMatrix c = a;
			int direction = 0;
			
			// try to build a line of matrices starting from a ..
			StringStructureImpl newLine = lines.alloc_full();//new StringStructureImpl(img, mshift);
			newLine.buildStringStructureImpl(img, mshift);
			int col = a.higherOrderX;
			int row = a.higherOrderY;
			int cumx = row*columns; // cumulative value of x axis
			int gap = 0;
			bool appendA = true;
			
			Iterator<container<ImageMatrix>> itFollow = Iterator<container<ImageMatrix>>.EMPTY();
			getIterator(&itFollow, Replica_flags.ALL, usedMark);
			while(itFollow.next()) {
				container<ImageMatrix> can2 = itFollow.get();
				if(can2.get() == a) {
					break;
				}
			}
			if(!itFollow.next()) {
				itFollow.destroy();
				break;
			}
			while(itFollow.next()) {
				container<ImageMatrix> can2 = itFollow.get();
				ImageMatrix b = can2.get();
				if(checkLinearMatrix(a, b, newLine, appendA, &gap, &direction) 
					|| (a!=c && checkLinearMatrix(c, b, newLine, false, &gap, &direction))) {
					a = c;
					c = b;
					appendA = false;
				}
			}
			if(newLine.getLength() > requiredLength) {
				newLine.setContinuity(100);
				newLine.pin();
			}
			itFollow.destroy();
		}
		
		it.destroy();
		print("Total lines:%d\n", lines.count_unsafe());
		return 0;
	}

#else
	
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
			StringStructureImpl newLine = lines.alloc_full();
			newLine.build(img, mshift);
			int col = a.higherOrderX;
			int row = a.higherOrderY;
			int cumx = row*columns; // cumulative value of x axis
			int gap = 0;
			int cont = 0;//100;
			
			for(;row < rows && gap <= maxCrackLength;(cumx+=columns),row++) {
				int xy = col+cumx;
				ImageMatrix?b = getMatrixAt(xy);
				if(b == null && col != (columns-1)) {
					b = getMatrixAt(xy+1);
				}
				if(b == null && col != 0) {
					b = getMatrixAt(xy-1);
				}
				if(b == null && col != (columns-2)) {
					b = getMatrixAt(xy+2);
				}
				if(b == null && (col-1) >= 0) {
					b = getMatrixAt(xy-2);
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
#endif
	
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
	
	public void mergeOverlapingLines() {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&lines);
		int totalLines = 0;
		while(it.next()) {
			StringStructureImpl x = it.get();
			if(x.testFlag(PRUNE)) {
				continue;
			}
			totalLines++;
			Iterator<StringStructureImpl> ity = Iterator<StringStructureImpl>(&lines);
			while(ity.next()) {
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
			}
			ity.destroy();
		}
		it.destroy();
		print("Merged to %d lines\n", totalLines);
	}

	
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
}
/** @} */
