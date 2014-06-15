using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixSparsityString : ImageMatrixString {
	int diffsum;
	public void buildSparsityString(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		diffsum = 0;
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
		etxt diffPoints = etxt.stack(points.length());
		int i,j;
		uchar a = -1;
		diffsum = 0;
		for(i = 0; i < points.length(); i++) {
			if(a == -1) {
				a = points.char_at(i);
				continue;
			}
			uchar c = a;
			a = points.char_at(i);
			if(c==a) { // avoid duplicate
				continue;
			}
			uchar diff = a-c;
			diffsum += diff;
			diffPoints.concat_char(diff);
		}
		points.destroy();
		if(diffPoints.length() > 0) {
			points = etxt.dup_etxt(&diffPoints);
		}
		return 0;
	}
	public override int getVal() {
		return diffsum;
	}
}
/** @} */
