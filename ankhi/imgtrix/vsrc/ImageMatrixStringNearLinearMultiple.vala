using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixStringNearLinearMultiple : ImageMatrixString {
#if REMEMBER_ALL_LINES
	ArrayList<txt> lines;
	int lineCount;
#endif
	txt? longestLine;
	
	public ImageMatrixStringNearLinearMultiple(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
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
			uchar a = points.char_at(i);
			uchar c = a;
			bool append_a = true;
			int j;
			for(j=i+1; j < points.length();j++) {
				uchar b = points.char_at(j);
				if(ImageMatrixStringNearLinear.diffIsInteresting(a, b, &linearPoints, append_a) 
					|| (a!=c && ImageMatrixStringNearLinear.diffIsInteresting(c, b, &linearPoints, false))) {
					a = c;
					c = b;
					append_a = false;
				}
			}
			if(linearPoints.length() > 0) {
				txt newLine = new txt.memcopy_etxt(&linearPoints);
#if REMEMBER_ALL_LINES
				lines.set(lineCount++, newLine);
#endif
				if(longestLine == null) {
					longestLine = newLine;
				} else if(longestLine.length() < newLine.length()) {
					longestLine = newLine;
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
