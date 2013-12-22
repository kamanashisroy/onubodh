using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringNearLinear : ImageMatrixString {
	public ImageMatrixStringNearLinear(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
	}

	public static bool diffIsInteresting(uchar a, uchar b, etxt*data, bool append_a) {
		int diff = b - a;
		//print("diff(%d,%d)=%d\n", a, b, diff);
		if((diff >= 4 && diff <= 5) || (diff >= 7 && diff <= 9) || (diff >= 11 && diff <= 13)) {
			if(append_a) {
				data.concat_char(a);
			}
			//print("diff(%d,%d)=%d\n", a, b, diff);
			data.concat_char(b);
			return true;
		}
		return false;
	}

	public override int compile() {
		base.compile();
		if(points.length() <= 1) {
			return 0;
		}
		etxt linearPoints = etxt.stack(points.length()+1);
		int i,j;
		for(i = 0; i < points.length(); i++) {
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				if(diffIsInteresting(a, b, &linearPoints, append_a) 
					|| (a!=c && diffIsInteresting(c, b, &linearPoints, false))) {
					a = c;
					c = b;
					append_a = false;
				}
			}
		}
		points.destroy();
		if(linearPoints.length() > 0) {
			points = etxt.dup_etxt(&linearPoints);
		}
		return 0;
	}
	public override int getVal() {
		return points.length();
	}
}
