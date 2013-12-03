using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.ImageMatrixManipulate : Replicable {
	ArrayList<ImageMatrix> strings;
	netpbmg*img;
	int mat_width;
	int mat_height;
	enum MatrixSize {
		MATRIX_4 = 4,
		MATRIX_SHIFT_4 = 2,
	}
	public ImageMatrixManipulate(netpbmg*src) {
		img = src;
		strings = ArrayList<ImageMatrix>();
	}
	public int compile4() {
		mat_width = img.width;
		mat_width = (mat_width >> MatrixSize.MATRIX_SHIFT_4) + (((mat_width & (MatrixSize.MATRIX_4-1)) == 0)?0:1);
		mat_height = img.height;
		mat_height = (mat_height >> MatrixSize.MATRIX_SHIFT_4) + (((mat_height & (MatrixSize.MATRIX_4-1)) == 0)?0:1);
		int x,y;
		int i;
		print("matrix height:%d, matrix width:%d\n", mat_height, mat_width);
		for(y=0,i=0;y<mat_height;y+=MatrixSize.MATRIX_4) {
			for(x=0;x<mat_width;x+=MatrixSize.MATRIX_4,i++) {
				ImageMatrix mat = createMatrix(img, x<<MatrixSize.MATRIX_SHIFT_4, y<<MatrixSize.MATRIX_SHIFT_4, MatrixSize.MATRIX_4);
				mat.compile();
				strings[i] = mat;
			}
		}
		return 0;
	}
	public int mark(int val) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			if(can.get().getVal() == val) {
				can.mark(1);
			}
		}
		return 0;
	}		
	public int dump(OutputStream os) {
		int x,y;
		int i;
		etxt val = etxt.stack(32);
		for(y=0,i=0;y<mat_height;y+=MatrixSize.MATRIX_4) {
			for(x=0;x<mat_width;x+=MatrixSize.MATRIX_4,i++) {
				val.printf("%d,", strings[i].getVal());
				val.zero_terminate();
				os.write(&val);
			}
			val.printf("\n");
			val.zero_terminate();
			os.write(&val);
		}
		return 0;
	}
	public abstract ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size);
}
