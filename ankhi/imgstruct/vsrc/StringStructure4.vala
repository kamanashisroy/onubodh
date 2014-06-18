using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public abstract class onubodh.StringStructure4 : StringStructure {
	netpbmg*img;
	protected int img_width;
	protected int img_height;
	protected int columns;
	protected int rows;
	enum MatrixSize {
		MATRIX_4 = 4,
		MATRIX_SHIFT_4 = 2,
	}
	public StringStructure4(netpbmg*src) {
		base();
		img = src;
	}
	
	public bool pruneMatrix4(ImageMatrix mat) {
		return mat.getFeature(ImageMatrixString.feat.LENGTH) > 0;
	}

	public int compile4() {
		img_width = img.width;
		img_height = img.height;
		columns = (img_width >> MatrixSize.MATRIX_SHIFT_4);
		columns += (((columns << MatrixSize.MATRIX_SHIFT_4) < img_width)?1:0);
		rows = (img_height >> MatrixSize.MATRIX_SHIFT_4);
		rows += (((rows << MatrixSize.MATRIX_SHIFT_4) < img_height)?1:0);
		
		int x,y;
		print("rows:%d, columns:%d\n", rows, columns);
		for(y=0;y<img_height;y+=MatrixSize.MATRIX_4) {
			for(x=0;x<img_width;x+=MatrixSize.MATRIX_4) {
				ImageMatrix mat = createMatrix(img, x, y, MatrixSize.MATRIX_4);
				mat.compile();
				if(!pruneMatrix4(mat)) {
					appendMatrix(mat);
				}
			}
		}
		print("Total interesting matrices:%d\n", getLength());
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
		for(y=0,i=0;y<img_height;y+=MatrixSize.MATRIX_4) {
			for(x=0;x<img_width;x+=MatrixSize.MATRIX_4,i++) {
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
/** @} */
