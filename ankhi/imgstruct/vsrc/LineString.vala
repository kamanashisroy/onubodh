using aroop;
using shotodol;
using onubodh;

public class onubodh.LineString : StringStructure4 {
	public LineString(netpbmg*src) {
		base(src);
	}
	public override ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		return new ImageMatrixStringNearLinearMultiple(src, x, y, mat_size);
	}
}
