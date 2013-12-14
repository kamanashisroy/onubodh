using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringNearLinear : ImageMatrixString {
	protected etxt linearPoints;
	public ImageMatrixStringNearLinear(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
		linearPoints = etxt.EMPTY();
	}

	public override int compile() {
		base.compile();
		if(points.length() <= 1) {
			return 0;
		}
		linearPoints.buffer(points.length()); // XXX we can use smaller buffer that the original size
		int i,j;
		for(i = 0; i < points.length(); i++) {
			uchar a = points.char_at(i);
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				int diff = b - a;
				//print("diff(%d,%d)=%d\n", points.char_at(i), points.char_at(i-1), diff);
				if((diff >= 3 && diff <= 5) || (diff >= 7 && diff <= 9)) {
					if(!linearPoints.contains_char((char)a)) {
						linearPoints.concat_char(a);
					}
					linearPoints.concat_char(b);
				}
			}
		}
		points.destroy();
		points = etxt.same_same(&linearPoints);
		return 0;
	}
	public override int getVal() {
		return linearPoints.length();
	}
}
