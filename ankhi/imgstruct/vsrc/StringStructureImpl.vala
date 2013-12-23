using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.StringStructureImpl : StringStructure {
	netpbmg*img;
	protected int img_width;
	protected int img_height;
	protected int columns;
	protected int rows;
	int radius; // 4 or 8, it is actually the size of the matrix
	int shift; // 2 if 4 and 3 if 8 so on ..
	public StringStructureImpl(netpbmg*src, int yourShift) {
		base();
		img = src;
		radius = 1<<yourShift;
		shift = yourShift;
	}
	
	public override int compile() {
		img_width = img.width;
		img_height = img.height;
		columns = (img_width >> shift);
		columns += (((columns << shift) < img_width)?1:0);
		rows = (img_height >> shift);
		rows += (((rows << shift) < img_height)?1:0);
		
		int x,y;
		print("rows:%d, columns:%d\n", rows, columns);
		for(y=0;y<img_height;y+=radius) {
			for(x=0;x<img_width;x+=radius) {
				ImageMatrix mat = createMatrix(img, x, y, (uchar)radius);
				mat.compile();
				if(mat.getVal() > 0) {
					setMatrixAt(mat.higher_order_x()+mat.higher_order_y()*columns, mat);
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
		for(y=0,i=0;y<img_height;y+=radius) {
			for(x=0;x<img_width;x+=radius,i++) {
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
