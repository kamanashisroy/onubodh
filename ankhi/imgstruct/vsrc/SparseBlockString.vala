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
	int requiredSparsityVal;
	SearchableFactory<ImageMatrixSparsityString> memory;
	public SparseBlockString(netpbmg*src, aroop_uword8 minGrayVal, int radius_shift, int minSparsityVal) {
		base(src, radius_shift, minGrayVal);
		requiredSparsityVal = minSparsityVal;
		memory = SearchableFactory<ImageMatrixSparsityString>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~LineString() {
		memory.destroy();
	}
	public override bool pruneMatrix(ImageMatrix mat) {
		if(mat.getFeature(ImageMatrixSparsityString.feat.SPARSITY) > 0)print("SparseBlock:Checking matrix (%d>=%d)\n", mat.getFeature(ImageMatrixSparsityString.feat.SPARSITY), requiredSparsityVal);
		if(mat.getFeature(ImageMatrixSparsityString.feat.SPARSITY) < requiredSparsityVal)
			return true;
		else
			mat.highlight();
		return false;
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
