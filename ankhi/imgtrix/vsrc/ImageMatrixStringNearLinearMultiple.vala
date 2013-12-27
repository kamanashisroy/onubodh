using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringNearLinearMultiple : ImageMatrixString {
#if REMEMBER_ALL_LINES
	ArrayList<txt> lines;
	int lineCount;
#endif
	txt? longestLine;
	public void buildNearLinearMultiple(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
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
	
	
	public bool checkLinear(uchar a, uchar b, etxt*data, bool append_a, int*disc) {
		int diff = b - a;
		int mod = diff & (size - 1);
		if(diff >= size && (mod == 1 || mod == 0 || mod == (size-1))) {
			if(append_a) {
				data.concat_char(a);
			}
			//print("diff(%d,%d)=%d\n", a, b, diff);
			data.concat_char(b);
			(*disc)=(diff >> shift);
			return true;
		}
		return false;
	}
		
	public override int heal() {
		int i;
		etxt linearPoints = etxt.stack(size+1);
		uchar oldval = 0;
		int bval = (~(size-1));
		for(i = 0; i < points.length(); i++) {
			uchar a = points.char_at(i);
			linearPoints.concat_char(a);
			int missing = 0;
			do {
				int diff = oldval - a;
				if(diff < 0) break;
				missing = (diff & bval);
				if(missing == 0) {
					break;
				}
				oldval += size; // add point
				linearPoints.concat_char(oldval);
			} while(true);
			if(missing == 0) {
				continue;
			}
		}
		points.destroy();
		if(linearPoints.length() > 0) {
			points = etxt.dup_etxt(&linearPoints);
		}
		return 0;
	}

	public override int compile() {
		base.compile();
		if(points.length() <= 1) {
			return 0;
		}
#if false			
		dumpString();
#endif
		int i;
		for(i = 0; i < points.length(); i++) {
			etxt linearPoints = etxt.stack(points.length()+1-i);
			int cont = 0;
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			int j;
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				int disc = 0;
				if(checkLinear(a, b, &linearPoints, append_a, &disc) 
					|| (a!=c && checkLinear(c, b, &linearPoints, false, &disc))) {
					a = c;
					c = b;
					append_a = false;
					cont -= disc;
					cont += 2;
				}
			}
			if(linearPoints.length() > 0) {
				txt newLine = new txt.memcopy_etxt(&linearPoints);
#if REMEMBER_ALL_LINES
				lines.set(lineCount++, newLine);
#endif
				if(longestLine == null || longestLine.length() < newLine.length()) {
					longestLine = newLine;
					continuity = cont;
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
		return ((longestLine == null) ? 0 : longestLine.length());
	}
}
