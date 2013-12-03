using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringAvg : ImageMatrixString {
	protected int avg;
	public ImageMatrixStringAvg(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
		avg = 0;
	}
	public override int compile() {
		base.compile();
		int i = 0;
		avg = 0;
		for(i = 1; i < points.length(); i++) {
			avg += points.char_at(i) - points.char_at(i-1);
		}
		if(points.length() != 0) {
			avg = avg/points.length();
		}
		return 0;
	}
	public override int getVal() {
		return avg;
	}
}
