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
	public LineString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift, int[] featureVals, int[] featureOps) {
		base(src, radius_shift, minGrayVal, featureVals, featureOps);
		memory = SearchableFactory<ImageMatrixStringNearLinearPlus>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~LineString() {
		memory.destroy();
	}
	public override int heal() {
		// for all the matrices..
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		getIterator(&it, Replica_flags.ALL, 0);
		int shift = getShift();
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix a = can.getUnowned();
			
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

	public override int compile() {
		img_width = img.width;
		img_height = img.height;
		columns = (img_width >> shift);
		columns += ((img_width & (( 1<< shift)-1)) == 0?0:1);
		rows = (img_height >> shift);
		rows += ((img_height & (( 1<< shift)-1)) == 0?0:1);
		
		int x,y;
		print("rows:%d, columns:%d\n", rows, columns);
		for(y=0;y<img_height;y+=radius) {
			for(x=0;x<img_width;x+=radius) {
				ImageMatrixStringNearLinearPlus?mat = (ImageMatrixStringNearLinearPlus)createMatrix2(x, y);
				mat.compile();
				do {
					ImageMatrixStringNearLinearPlus?linemat = (ImageMatrixStringNearLinearPlus)mat.submatrix;
					if(linemat == null) break;
					if(!pruneMatrix(linemat)) {
						appendMatrix(linemat);
						linemat.highlight();
						break;
					}
					mat = linemat;
				} while(true);
			}
			showProgress();
		}
		print("Total interesting matrices:%d\n", getLength());
		return 0;
	}
}
/** @} */
