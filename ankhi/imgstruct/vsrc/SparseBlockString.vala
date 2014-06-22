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
	SearchableFactory<ImageMatrixSparsityString> memory;
	public SparseBlockString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift, int[] featureVals, int[] featureOps) {
		base(src, radius_shift, minGrayVal, featureVals, featureOps);
		memory = SearchableFactory<ImageMatrixSparsityString>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~LineString() {
		memory.destroy();
	}
	public override bool pruneMatrix(ImageMatrix mat) {
		bool p = base.pruneMatrix(mat);
		if(!p)
			mat.highlight();
		return p;
	}
	public override int heal() {
		base.heal();
		return 0;
	}
	public override ImageMatrix? createMatrix2(int x, int y) {
		return createMatrix(img, x, y, shift, requiredGrayVal, createMatrix);
	}
	public ImageMatrix? createMatrix(netpbmg*src, int x, int y, uchar mat_size, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fcm) {
		ImageMatrixSparsityString a = memory.alloc_full(0,0,true);
		a.buildSparsityString(src, x, y, mat_size, minGrayVal, fcm);
		return a;
	}
}
/** @} */
