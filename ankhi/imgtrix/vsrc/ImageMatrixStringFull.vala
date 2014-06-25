using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixStringFull : ImageMatrixString {
	//etxt diffPoints;
	public enum feat {
		SPARSITY = 7,
		AREA,
	}
	public void buildStringFull(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fcm) {
		//diffPoints = etxt.EMPTY();
		buildString(src, x, y, radiusShift, minGrayVal, fcm);
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
		return drycompile();
	}
	public override int drycompile() {
		base.drycompile();
		int i;
		uchar a = -1;
		features[feat.SPARSITY] = 0;
		features[feat.AREA] = 0;
		//diffPoints.buffer(points.length());
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
			features[feat.SPARSITY] += diff;
			//diffPoints.concat_char(diff);
		}
		features[feat.AREA] = points.length();
		return 0;
	}
}
/** @} */
