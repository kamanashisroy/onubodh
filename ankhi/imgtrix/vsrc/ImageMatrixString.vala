using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.ImageMatrixString : ImageMatrix {
	protected etxt points;
	public ImageMatrixString(netpbmg*src, int x, int y, uchar mat_size) {
		base(src,x,y,mat_size);
		points = etxt.EMPTY();
		points.buffer(mat_size*mat_size); // XXX we can use smaller buffer that the original size
		//print("matrix : %d,%d - %d\n", x, y, mat_size);
	}
	public override int compile() {
		int y;
		uchar cumx = 0;
		for(y=0,cumx=0;(y<size) && ((y+top) < img.height) ;y++,cumx+=size) {
			int x;
			for(x=0;(x<size) && ((x+left) < img.width);x++) {
				aroop_uword8 gval = 0;
				img.getGrayVal(x+left,y+top,&gval);
				if(gval != 0) {
					//print("scanning : %d,%d - %d[%d]\n", x+left, y+top, cumx+(uchar)x, gval);
					points.concat_char(cumx+(uchar)x);
				}
			}
		}
		return 0;
	}
	public override void dumpImage(netpbmg*oImg) {
		int i = 0;
		for(i = 0; i < points.length(); i++) {
			uchar pos = points.char_at(i);
			int r = pos%size;
			int x = left+r;
			int y = ((pos-r)/size)+top;
			//aroop_uword8 val = 0;
			//img.getGrayVal(x,y,&val);
			//print("dumping : %d,%d\n", x+left, y+top);
			oImg.setGrayVal(x,y,200);
		}
	}
}
