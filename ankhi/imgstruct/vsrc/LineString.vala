using aroop;
using shotodol;
using onubodh;

/**
 * \ingroup ankhi
 * \defgroup imgstruct Image structure
 */

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.LineString : StringStructureImpl {
	SearchableFactory<ImageMatrixStringNearLinearPlus> memory;
	public LineString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift) {
		base(src, radius_shift, minGrayVal);
		memory = SearchableFactory<ImageMatrixStringNearLinearPlus>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~LineString() {
		memory.destroy();
	}
	public override int compile() {
		base.compile();
		return 0;
	}
	public override int heal() {
		// for all the matrices..
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		int shift = getShift();
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix a = can.get();
			
			// try to build a line of matrices starting from a ..
			int col = a.higherOrderX;
			int row = a.higherOrderY;
			int xval = row*columns;
			
			for(;row < rows;(xval+=columns),row++) {
				int xy = col+xval;
				ImageMatrix?b = getMatrixAt(xy);
				if(b == null && col != (columns-1)) {
					//xy++;
					b = getMatrixAt(xy+1);
				}
				if(b == null && col != 0) {
					//xy--;xy--;
					b = getMatrixAt(xy-1);
				}
				if(b == null) {
					b = this.createMatrix(img, col<<shift, row<<shift, (uchar)shift, requiredGrayVal, this.createMatrix);
					b.copyFrom(a);
					//core.assert((xy+1) == b.higherOrderXY);
					appendMatrix(b);
					continue;
				}
				col = b.higherOrderX;
			}
		}

		base.heal();
		return 0;
	}
	public override ImageMatrix? createMatrix2(int x, int y) {
		return createMatrix(img, x, y, shift, requiredGrayVal, createMatrix);
	}
	public ImageMatrix? createMatrix(netpbmg*src, int x, int y, uchar mat_size, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fcm) {
		ImageMatrixStringNearLinearPlus a = memory.alloc_full(0,0,true);
		a.buildNearLinearPlus(src, x, y, mat_size, minGrayVal, fcm);
		return a;
	}
}
/** @} */
