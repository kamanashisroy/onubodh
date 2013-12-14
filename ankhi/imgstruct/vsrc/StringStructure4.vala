using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.StringStructure4 : StringStructure {
	netpbmg*img;
	protected int mat_width;
	protected int mat_height;
	enum MatrixSize {
		MATRIX_4 = 4,
		MATRIX_SHIFT_4 = 2,
	}
	public StringStructure4(netpbmg*src) {
		base();
		img = src;
	}
	public int compile4() {
		mat_width = img.width;
		mat_height = img.height;
		int x,y;
		print("matrix height:%d, matrix width:%d\n", mat_height, mat_width);
		for(y=0;y<mat_height;y+=MatrixSize.MATRIX_4) {
			for(x=0;x<mat_width;x+=MatrixSize.MATRIX_4) {
				ImageMatrix mat = createMatrix(img, x, y, MatrixSize.MATRIX_4);
				mat.compile();
				if(mat.getVal() > 0) {
					strings.add(mat);
				}
			}
		}
		return 0;
	}
#if false
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
#endif
	public abstract ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size);
}
