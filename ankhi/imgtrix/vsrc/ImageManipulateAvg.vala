using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageManipulateAvg : ImageMatrixManipulate {
	public ImageManipulateAvg(netpbmg*src) {
		base(src);
	}
	public override ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		return new ImageMatrixStringAvg(src, x, y, mat_size);
	}
}
