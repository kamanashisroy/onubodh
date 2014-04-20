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
	aroop_uword8 requiredGrayVal;
	Factory<ImageMatrixStringNearLinearMultiple> memory;
	public LineString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift) {
		base(src, radius_shift);
		requiredGrayVal = minGrayVal;
		memory = Factory<ImageMatrixStringNearLinearMultiple>.for_type();
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
					xy++;
					b = getMatrixAt(xy+1);
				}
				if(b == null && col != 0) {
					xy--;xy--;
					b = getMatrixAt(xy-1);
				}
				if(b == null) {
					b = createMatrix(img, col<<shift, row<<shift, (uchar)shift);
					b.copyFrom(a);
					core.assert((xy+1) == b.higherOrderXY);
					appendMatrix(b);
					continue;
				}
				col = b.higherOrderX;
			}
		}

		base.heal();
		return 0;
	}
	public override ImageMatrix? createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		//return new ImageMatrixStringNearLinearMultiple(src, x, y, mat_size, requiredGrayVal);
		ImageMatrixStringNearLinearMultiple a = memory.alloc_full(64);
		a.buildNearLinearMultiple(src, x, y, mat_size, requiredGrayVal);
		return a;
	}
}
/** @} */
