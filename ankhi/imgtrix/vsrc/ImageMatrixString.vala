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
	bool filled;
	protected int cracks;
	protected int opposite;
	protected int adjacent;
	public void buildString(netpbmg*src, int x, int y, uchar radiusShift, aroop_uword8 minGrayVal) {
		core.assert((1<<(radiusShift+1)) < 255);
		buildMain(src,x,y,radiusShift);
		points = etxt.EMPTY();
		requiredGrayVal = minGrayVal;
		//print("matrix : %d,%d - %d\n", x, y, mat_size);
		filled = false;
		cracks = 0;
		opposite = 0;
		adjacent = 0;
	}
	
	public override void copyFrom(ImageMatrix other) {
		points.destroy();
		points = etxt.same_same(&((ImageMatrixString)other).points);
	}
	
	public override int fill() {
		filled = true;
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

	public virtual int getCracks() {
		return cracks;
	}

	public virtual int getLength() {
		return points.length();
	}
	
	public override void dumpImage(netpbmg*oImg, aroop_uword8 gval) {
		int i = 0;
		if(filled) {
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
