using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixStringNearLinear : ImageMatrixString {
	public enum feat {
		CRACKS = 4,
		OPPOSITE, // It is the perpendicular side of a right-angled triangle, the opposite side of the angle theta.
		ADJACENT,
	}
	public void buildNearLinear(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fcm) {
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

	public ImageMatrixStringNearLinear appendSubmatrix(etxt*givenPoints) {
		ImageMatrixStringNearLinear?smat = this;
		do {
			if(smat.submatrix != null) {
				smat = (ImageMatrixStringNearLinear)smat.submatrix;
				continue;
			}
			smat.submatrix = fcreate(img, left, top, shift, requiredGrayVal, fcreate);
			smat = (ImageMatrixStringNearLinear)smat.submatrix;
			smat.points = etxt.dup_etxt(givenPoints);
			smat.drycompile();
			break;
		} while(true);
		return smat;
	}

	int calcOpposite(etxt*ln) {
		uchar y1 = ln.char_at(0);
		uchar y2 = ln.char_at(ln.length()-1);
		return (y2-y1) >> shift;
	}

	public override int compile() {
		base.compile();
		if(points.length() <= 1) {
			return 0;
		}
		int i,j;
		for(i = 0; i < points.length(); i++) {
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			ZeroTangle tngl = ZeroTangle.forShift(shift);
			etxt linearPoints = etxt.stack(points.length()+1);
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
			if(linearPoints.length() > 1) {
				ImageMatrixStringNearLinear mat = appendSubmatrix(&linearPoints);
				mat.features[feat.CRACKS] = tngl.crack;
				mat.features[feat.ADJACENT] = tngl.adjacent;
			}
			linearPoints.destroy();
		}
		drycompile();
		return 0;
	}
	public override int drycompile() {
		base.drycompile();
		features[feat.OPPOSITE] = calcOpposite(&points);
		return 0;
	}
}
/** @} */
