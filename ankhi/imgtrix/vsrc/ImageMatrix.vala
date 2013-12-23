using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.ImageMatrix : Replicable {
	protected netpbmg*img;
	public int top{public get;private set;}
	public int left{public get;private set;}
	protected uchar size;
	protected uchar shift;
	int flag;
	public void buildMain(netpbmg*src, int x, int y, uchar radiusShift) {
		img = src;
		top = y;
		left = x;
		size = 1<<radiusShift;
		shift = radiusShift;
	}
	public abstract void copyFrom(ImageMatrix other);
	public int higher_order_x() {
		return left>>shift;
	}
	public int higher_order_y() {
		return top>>shift;
	}
	public abstract int heal();
	public abstract int fill();
	public abstract int compile();
	public abstract int getVal();
	public abstract void dumpImage(netpbmg*out, aroop_uword8 gval);
	public bool testFlag(int myFlag) {
		return (flag & myFlag) != 0;
	}
	public void flagIt(int myFlag) {
		flag |= myFlag;
	}
	public void unflagIt(int myFlag) {
		flag &= ~myFlag;
	}
}
