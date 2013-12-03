using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageString : Replicable {
	ArrayList<ImageMatrixString> strings;
	netpbmg*img;
	int mat_width;
	int mat_height;
	public ImageString(netpbmg*src) {
		img = src;
		strings = ArrayList<ImageMatrixString>();
	}
	public int compile4() {
		mat_width = img.width;
		mat_width = (mat_width >> 2) + (((mat_width & 3) == 0)?0:1);
		mat_height = img.height;
		mat_height = (mat_height >> 2) + (((mat_height & 3) == 0)?0:1);
		int x,y;
		int i;
		for(y=0,i=0;y<mat_height;y++) {
			for(x=0;x<mat_width;x++,i++) {
				ImageMatrixString mat = new ImageMatrixString(img, x<<2, (y*mat_height)<<2, 4);
				mat.compile();
				strings[i] = mat;
			}
		}
		return 0;
	}
}
