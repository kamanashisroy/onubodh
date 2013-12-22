using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.ImageMatrix : Replicable {
	protected netpbmg*img;
	public int top{public get;private set;}
	public int left{public get;private set;}
	protected uchar size;
	int flag;
	public ImageMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		img = src;
		top = y;
		left = x;
		size = mat_size;
	}
	public int higher_order_x() {
		return left/size;
	}
	public int higher_order_y() {
		return top/size;
	}
	public abstract int compile();
	public abstract int getVal();
	public abstract void dumpImage(netpbmg*out);
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
