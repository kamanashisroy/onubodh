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
public class onubodh.BlockString : StringStructureImpl {
	SearchableFactory<ImageMatrixStringFull> memory;
	public BlockString(netpbmg*src, int radius_shift, aroop_uword8 minGrayVal, int[] featureVals, int[] featureOps) {
		base(src, radius_shift, minGrayVal, featureVals, featureOps);
		memory = SearchableFactory<ImageMatrixStringFull>.for_type(128,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~BlockString() {
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
		ImageMatrixStringFull a = memory.alloc_full(0,0,true);
		a.buildStringFull(src, x, y, mat_size, minGrayVal, fcm);
		return a;
	}
}
/** @} */
