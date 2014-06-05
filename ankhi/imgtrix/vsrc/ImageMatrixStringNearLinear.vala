using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixStringNearLinear : ImageMatrixString {
	public void buildNearLinear(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		buildString(src, x, y, radiusShift, minGrayVal);
	}

	public static bool diffIsInteresting(uchar a, uchar b, etxt*data, bool append_a, int msize) {
		int diff = b - a;
		int mod = diff & (msize - 1);
		if(diff >= msize && (mod == 1 || mod == 0 || mod == (msize-1))) {
			if(append_a) {
				data.concat_char(a);
			}
			//print("diff(%d,%d)=%d\n", a, b, diff);
			data.concat_char(b);
			return true;
		}
		return false;
	}
	
	public override int heal() {
		core.assert("I cannot heal" == null);
		return 0;
	}

	public override int thin() {
		core.assert("I cannot thin" == null);
		return 0;
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
				if(diffIsInteresting(a, b, &linearPoints, append_a, size) 
					|| (a!=c && diffIsInteresting(c, b, &linearPoints, false, size))) {
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
/** @} */
