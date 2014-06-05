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
	int longestLineOpposite;
	public void buildNearLinearMultiple(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		//memclean_raw();
		buildString(src,x,y,radiusShift, minGrayVal);
#if REMEMBER_ALL_LINES
		lines = ArrayList<txt>();
		lineCount = 0;
#endif
		longestLine = null;
		longestLineOpposite = 0;
	}
	
	~ImageMatrixStringNearLinearMultiple() {
#if REMEMBER_ALL_LINES		
		lines.destroy();
#endif
		longestLine = null;
	}

	
	public override int thin() {
		uchar a = 255;
		uchar b = 255;
		int i;
		etxt linearPoints = etxt.stack(points.length()+1);
		int skipped = 0;
		for(i = 0; i < points.length(); i++) {
			uchar c = points.char_at(i);
			if(a == 255) {
				a = c;continue;
			}
			if(b == 255) {
				b = c;continue;
			}
			if((b - a == 1) && (c - b == 1)) {
				// skip a ..
				skipped++;
			} else {
				linearPoints.concat_char(a);
			}
			a = b;
			b = c;
		}
		if(skipped > 0) {
			points.trim_to_length(0);
			points.concat(&linearPoints);
			if(a != 255)points.concat_char(a);
			if(b != 255)points.concat_char(b);
		}
		return 0;
	}
		
	public override int heal() {
		/* sanity check */
		if(points.length() <= 1) {
			return 0;
		}

		int i;
		etxt linearPoints = etxt.stack(size<<3+1);
		uchar oldval = 0;
		int bval = (~(size-1));
		uchar a = points.char_at(0);
		linearPoints.concat_char(a);
		oldval = a;
		int adjacent = 0;
		for(i = 1; i < points.length(); i++) {
			uchar x = points.char_at(i);
			adjacent = ((x - oldval) & (size-1));
			bool left = false;
			if(adjacent > (size>>1)) {
				left = true;
				adjacent = size - adjacent;
			}
			do {
				int missing = 0;
				int diff = x - oldval;
				if(diff < 0) break;
				missing = (diff & bval);
				if(missing == 0) {
					break;
				}
				missing = missing >> shift;
				
				oldval = oldval + size; // add point
				if(left) oldval -= 1;
				else oldval+=1;
				adjacent--;
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

	int calcOpposite(etxt*ln) {
		uchar y1 = ln.char_at(0);
		uchar y2 = ln.char_at(ln.length()-1);
		return (y2-y1) >> shift;
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
		int longestLineOpposite = 0;
		for(i = 0; i < points.length(); i++) {
			int len = points.length()-i;
#if false
			if(len <= longestLineOpposite) {
				break;
			}
#endif
			etxt linearPoints = etxt.stack(len+1);
			int cracks = 0;
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			int j;
			ZeroTangle tngl = ZeroTangle.forShift(shift);
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				//if(tngl.neibor150(a, b) || (a!=c && tngl.neibor150(c, b))) {
				//if(tngl.neibor163(a, b) || (a!=c && tngl.neibor163(c, b))) {
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
			if(linearPoints.length() > 0) {
				txt newLine = new txt.memcopy_etxt(&linearPoints);
#if REMEMBER_ALL_LINES
				lines.set(lineCount++, newLine);
#endif
				int newLineOpposite = calcOpposite(newLine);
				if(longestLine == null || (longestLineOpposite < newLineOpposite) || (longestLineOpposite == newLineOpposite && adjacent > tngl.adjacent)) {
					longestLine = newLine;
					longestLineOpposite = newLineOpposite;
					cracks = tngl.crack;
					adjacent = tngl.adjacent;
					opposite = newLineOpposite;
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
	public override int getLength() {
		return opposite;
	}
	public override int getVal() {
#if REMEMBER_ALL_LINES
		if(lineCount == 0) 
			return 0;
#endif		
		return ((longestLine == null) ? 0 : (((getLength()-getCracks()) > 0 )?1:0));
	}
}
/** @} */
