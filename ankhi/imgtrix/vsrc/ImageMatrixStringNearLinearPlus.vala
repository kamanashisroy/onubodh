using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public class onubodh.ImageMatrixStringNearLinearPlus : ImageMatrixStringNearLinear {
	public void buildNearLinearPlus(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fcm) {
		buildNearLinear(src, x, y, radiusShift, minGrayVal, fcm);
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

}
/** @} */
