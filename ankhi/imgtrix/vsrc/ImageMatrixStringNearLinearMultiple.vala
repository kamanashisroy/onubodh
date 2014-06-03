using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixStringNearLinearMultiple : ImageMatrixString {
#if REMEMBER_ALL_LINES
	ArrayList<txt> lines;
	int lineCount;
#endif
	txt? longestLine;
	public void buildNearLinearMultiple(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		//memclean_raw();
		buildString(src,x,y,radiusShift, minGrayVal);
#if REMEMBER_ALL_LINES
		lines = ArrayList<txt>();
		lineCount = 0;
#endif
		longestLine = null;
	}
	
	~ImageMatrixStringNearLinearMultiple() {
#if REMEMBER_ALL_LINES		
		lines.destroy();
#endif
		longestLine = null;
	}
		
	public override int heal() {
		/* sanity check */
		if(points.length() <= 1) {
			return 0;
		}

		int i;
		etxt linearPoints = etxt.stack(size+1);
		uchar oldval = 0;
		int bval = (~(size-1));
		uchar a = points.char_at(0);
		linearPoints.concat_char(a);
		oldval = a;
		for(i = 1; i < points.length(); i++) {
			uchar x = points.char_at(i);
			do {
				int missing = 0;
				int diff = x - oldval;
				if(diff < 0) break;
				missing = (diff & bval);
				if(missing == 0) {
					break;
				}
				oldval += size; // add point
				linearPoints.concat_char(oldval);
			} while(true);
			linearPoints.concat_char(x);
		}
		points.destroy();
		if(linearPoints.length() > 0) {
			points = etxt.dup_etxt(&linearPoints);
		}
		return 0;
	}

	/**
	 * \brief It finds the lines(or nearly linear lines) comapring
	 * (a,b), (a,c), (a,d) .. twin points using checkLinear() method.
	 * 
	 * \see #checkLinear() 
	 **/
	public override int compile() {
		base.compile();
		if(points.length() <= 1) {
			return 0;
		}
#if false			
		dumpString();
#endif
		int i;
		int longestLineLength = 0;
		for(i = 0; i < points.length(); i++) {
			int len = points.length()-i;
#if false
			if(len <= longestLineLength) {
				break;
			}
#endif
			etxt linearPoints = etxt.stack(len+1);
			int cracks = 0;
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			int j;
			ZeroTangle tngl = ZeroTangle.byShift(shift);
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				if(tngl.detect163(a, b) || (a!=c && tngl.detect163(c, b))) {
				//if(tngl.detect150(a, b) || (a!=c && tngl.detect150(c, b))) {
					if(append_a) {
						append_a = false;
						linearPoints.concat_char(a);
					}
					linearPoints.concat_char(b);
					a = c;
					c = b;
				}
			}
			if(linearPoints.length() > 0) {
				txt newLine = new txt.memcopy_etxt(&linearPoints);
#if REMEMBER_ALL_LINES
				lines.set(lineCount++, newLine);
#endif
				if(longestLine == null || longestLine.length() < newLine.length()) {
					longestLine = newLine;
					longestLineLength = longestLine.length();
					continuity = longestLineLength - tngl.crack;
					if(continuity < 1)
						print("length:%d,crack:%d\n", longestLineLength, tngl.crack);
					if(continuity == (1<<shift))
						print("line detected:%d\n", longestLineLength);
				}
			}
		}
		
		points.destroy();
		if(longestLine != null) {
			points = etxt.same_same(longestLine);
#if false			
			dumpString();
#endif
		}
		return 0;
	}
	public override int getVal() {
#if REMEMBER_ALL_LINES
		if(lineCount == 0) 
			return 0;
#endif		
		return ((longestLine == null) ? 0 : ((continuity > 0 )?1:0));
	}
}
/** @} */
