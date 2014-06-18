using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgtrix 
 * @{
 */
public abstract class onubodh.ImageMatrixString : ImageMatrix {
	protected etxt points;
	aroop_uword8 requiredGrayVal = 0;
	protected int features[8];
	public enum feat {
		CRACKS = 0,
		OPPOSITE,
		ADJACENT,
		LENGTH,
	}
	public void buildString(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		core.assert((1<<(radiusShift+1)) < 255);
		buildMain(src,x,y,radiusShift);
		points = etxt.EMPTY();
		requiredGrayVal = minGrayVal;
		//print("matrix : %d,%d - %d\n", x, y, mat_size);
		int i = 0;
		for(i = 0; i < 8; i++) {
			features[i] = 0;
		}
	}
	
	public override void copyFrom(ImageMatrix other) {
		points.destroy();
		points = etxt.same_same(&((ImageMatrixString)other).points);
	}
	
	public override int fill() {
		flagIt(MatrixFlags.FILL);
		return 0;
	}
	
	public override int highlight() {
		flagIt(MatrixFlags.HIGHLIGHT);
		return 0;
	}
	
	public override int compile() {
		int y;
		uchar cumx = 0;
		etxt myPoints = etxt.stack(size*size);
		for(y=0,cumx=0;(y<size) && ((y+top) < img.height) ;y++,cumx+=size) {
			int x;
			for(x=0;(x<size) && ((x+left) < img.width);x++) {
				aroop_uword8 gval = 0;
				img.getGrayVal(x+left,y+top,&gval);
				if(gval > requiredGrayVal) {
					myPoints.concat_char(cumx+(uchar)x);
				}
			}
		}
		points = etxt.dup_etxt(&myPoints);
		features[feat.LENGTH] = points.length();
		return 0;
	}
	
	public void dumpString() {
		int i;
		print("[");
		for(i = 0; i < points.length(); i++) {
			print(",%d", points.char_at(i));
		}
		print("],[");
		for(i = 0; i < points.length(); i++) {
			uchar pos = points.char_at(i);
			int r = pos&(size-1);
			int x = left+r;
			int y = (pos>>shift)+top;
		}
		print("]\n");
	}

	public virtual int getFeature(int feat) {
		return features[feat];
	}

	public override void dumpImage(netpbmg*oImg, aroop_uword8 gval) {
		int i = 0;
		if((flag & MatrixFlags.HIGHLIGHT) != 0) {
			int y;
			for(y = 0; y < size; y++) {
				oImg.setGrayVal(left,y+top,gval);
				oImg.setGrayVal(left+size,y+top,gval);
			}
			int x;
			for(x=0; x < size; x++) {
				oImg.setGrayVal(x+left,top,gval);
				oImg.setGrayVal(x+left,top+size,gval);
			}
		}
		if((flag & MatrixFlags.FILL) != 0) {
			int y;
			int maxy = top+size;
			for(y = top; y < maxy; y++) {
				int x;
				for(x=0; x < size; x++) {
					oImg.setGrayVal(x+left,y,gval);
				}
			}
		} else for(i = 0; i < points.length(); i++) {
			uchar pos = points.char_at(i);
			int r = pos&(size-1);
			int x = left+r;
			int y = (pos>>shift)+top;
			//aroop_uword8 val = 0;
			//img.getGrayVal(x,y,&val);
			//print("dumping : %d,%d\n", x+left, y+top);
			oImg.setGrayVal(x,y,gval);
		}
#if false
		dumpString();
#endif
	}
}
/** @} */
