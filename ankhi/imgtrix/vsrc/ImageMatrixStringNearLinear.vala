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
			ZeroTangle tngl = ZeroTangle.forShift(shift);
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				if(tngl.neibor164(a, b) || (a!=c && tngl.neibor164(c, b))) {
					if(append_a) {
						append_a = false;
						linearPoints.concat_char(a);
					}
					linearPoints.concat_char(b);
					a = c;
					c = b;
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
