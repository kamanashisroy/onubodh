using aroop;
using shotodol;
using onubodh;

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
	public override ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		//return new ImageMatrixStringNearLinearMultiple(src, x, y, mat_size, requiredGrayVal);
		ImageMatrixStringNearLinearMultiple a = memory.alloc_full(64);
		a.buildNearLinearMultiple(src, x, y, mat_size, requiredGrayVal);
		return a;
	}
}
