using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.ImageMatrix : Replicable {
	protected netpbmg*img;
	protected int top;
	protected int left;
	protected uchar size;
	public ImageMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		img = src;
		top = y;
		left = x;
		size = mat_size;
	}
	public abstract int compile();
	public abstract int getVal();
}
