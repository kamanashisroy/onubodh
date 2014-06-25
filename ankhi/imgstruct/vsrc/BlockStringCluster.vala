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
public class onubodh.BlockStringCluster : BlockString {
	Factory<StringStructureImpl>blocks;
	public BlockStringCluster(netpbmg*src, int radius_shift, aroop_uword8 minGrayVal, int[] featureVals, int[] featureOps) {
		base(src, radius_shift, minGrayVal, featureVals, featureOps);
		blocks = Factory<StringStructureImpl>.for_type(8,factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
	}
	~BlockStringCluster() {
		blocks.destroy();
	}

	int detectBlockAt(int pos, StringStructureImpl bl) {
		ImageMatrix?x = getMatrixAt(pos);
		if(x == null) {
			return 0;
		}
		if(x.testFlag(ImageMatrix.MatrixFlags.UNUSED1)) {
			// XXX strange !
			return 0;
		}
		showProgress();
		bl.appendMatrix(x);
		x.flagIt(ImageMatrix.MatrixFlags.UNUSED1);
		int xy = rows*columns;
		if((pos+1) <= xy)detectBlockAt(pos+1, bl);
		if((pos+2) <= xy)detectBlockAt(pos+2, bl);
		if((pos-1) >= 0)detectBlockAt(pos-1, bl);
		if((pos-2) >= 0)detectBlockAt(pos-2, bl);
		if((pos-columns-1) >= 0)detectBlockAt(pos-columns-1, bl);
		if((pos-columns) >= 0)detectBlockAt(pos-columns, bl);
		if((pos-columns*2) >= 0)detectBlockAt(pos-columns*2, bl);
		if((pos-columns+1) >= 0)detectBlockAt(pos-columns+1, bl);
		if((pos+columns-1) <= xy)detectBlockAt(pos+columns-1, bl);
		if((pos+columns) <= xy)detectBlockAt(pos+columns, bl);
		if((pos+columns*2) <= xy)detectBlockAt(pos+columns*2, bl);
		if((pos+columns+1) <= xy)detectBlockAt(pos+columns+1, bl);
		return 0;
	}

	public override int compile() {
		base.compile();
		if(getLength() <= 1) {
			return 0;
		}
		int blockCount = 0;
		print("Total matrices interesting matrices:%d\n", getLength());

		// for all the matrices..
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		int mshift = getShift();
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix a = can.get();
			if(a.testFlag(ImageMatrix.MatrixFlags.UNUSED1)) {
				continue;
			}
			
			// try to build a block of matrices starting from a ..
			StringStructureImpl newBlock = blocks.alloc_full();
			newBlock.buildStringStructureImpl(img, mshift);
			newBlock.pin();
			blockCount++;
			
			int xy = a.higherOrderXY;
			showProgress();
			detectBlockAt(xy, newBlock);
		}
		print("Total block count %d\n", blockCount);
		return 0;
	}

	public override void dumpImage(netpbmg*oimg, aroop_uword8 gval) {
		Iterator<StringStructureImpl> it = Iterator<StringStructureImpl>(&blocks);
		bool high = true;
		int totalBlocks = 0;
		while(it.next()) {
			StringStructureImpl strct = it.get();
			//if(strct.testFlag(PRUNE)) {
			//	continue;
			//}
			totalBlocks++;
			strct.dumpImage(oimg, high?gval:(gval>>1));
			high = !high;
		}
		it.destroy();
		print("Dumped %d blocks\n", totalBlocks);
	}
}
/** @} */
