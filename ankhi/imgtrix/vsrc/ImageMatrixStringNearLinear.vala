using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringNearLinear : ImageMatrixString {
	int candidate;
	int nocandidate;
	public ImageMatrixStringNearLinear(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
		candidate = 0;
		nocandidate = 0;
	}
	public override int compile() {
		base.compile();
		int i = 0;
		for(i = 1; i < points.length(); i++) {
			int diff = points.char_at(i) - points.char_at(i-1);
			if((diff >= 3 && diff <= 5) || (diff >= 7 && diff <= 9)) {
				candidate++;
			} else {
				nocandidate++;
			}
		}
		return 0;
	}
	public override int getVal() {
		return (candidate - nocandidate);
	}
}
