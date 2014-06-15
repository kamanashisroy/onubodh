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
public class onubodh.SparseBlockString : StringStructureImpl {
	aroop_uword8 requiredGrayVal;
	int requiredSparsityVal;
	SearchableFactory<ImageMatrixSparsityString> memory;
	public SparseBlockString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift, int minSparsityVal) {
		base(src, radius_shift);
		requiredGrayVal = minGrayVal;
		requiredSparsityVal = minSparsityVal;
		memory = SearchableFactory<ImageMatrixSparsityString>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~LineString() {
		memory.destroy();
	}
	public override int compile() {
		base.compile();
		// for all the matrices..
		Iterator<container<ImageMatrixSparsityString>> it = Iterator<container<ImageMatrixSparsityString>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			container<ImageMatrixSparsityString> can = it.get();
			ImageMatrixSparsityString mat = can.get();
			print("SparseBlock:Checking matrix (%d>=%d)\n", mat.getVal(), requiredSparsityVal);
			if(mat.getVal() < requiredSparsityVal) {
				removeMatrixAT(mat.higherOrderXY);
			}
		}
		it.destroy();
		return 0;
	}
	public override int heal() {
		base.heal();
		return 0;
	}
	public override ImageMatrix? createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		ImageMatrixSparsityString a = memory.alloc_full(0,0,true);
		a.buildSparsityString(src, x, y, mat_size, requiredGrayVal);
		return a;
	}
}
/** @} */
