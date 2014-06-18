using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.StringStructureImpl : StringStructure {
	protected netpbmg*img;
	protected int img_width;
	protected int img_height;
	protected int columns;
	protected int rows;
	int radius; // 4 or 8, it is actually the size of the matrix
	int shift; // 2 if 4 and 3 if 8 so on ..
	public StringStructureImpl(netpbmg*src, int yourShift) {
		buildStringStructureImpl(src, yourShift);
	}
	
	public void buildStringStructureImpl(netpbmg*src, int yourShift) {
		buildStringStructure();
		img = src;
		radius = 1<<yourShift;
		shift = yourShift;
	}

	public int getShift() {
		return shift;
	}
	
	public override int compile() {
		img_width = img.width;
		img_height = img.height;
		columns = (img_width >> shift);
		columns += ((img_width & (( 1<< shift)-1)) == 0?0:1);
		rows = (img_height >> shift);
		rows += ((img_height & (( 1<< shift)-1)) == 0?0:1);
		
		int x,y;
		print("rows:%d, columns:%d\n", rows, columns);
		for(y=0;y<img_height;y+=radius) {
			for(x=0;x<img_width;x+=radius) {
				ImageMatrix mat = createMatrix(img, x, y, (uchar)shift);
				mat.compile();
				if(mat.getVal() > 0) {
					appendMatrix(mat);
				}
			}
		}
		print("Total interesting matrices:%d\n", getLength());
		return 0;
	}

	public override int getCracksInPixels() {
		int crk = 0;
		Iterator<container<ImageMatrixString>> it = Iterator<container<ImageMatrixString>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			container<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.get();
			crk += mat.getFeature(ImageMatrixString.feat.CRACKS);
		}
		it.destroy();
		crk += cracks<<shift;
		return crk;
	}
	
	public override bool overlaps(StringStructure other) {
		bool olaps = false;
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix x = can.get();
			if(other.getMatrixAt(x.higherOrderXY) != null) {
				olaps = true;
				//print("Overlaps ......\n");
				break;
			}
		}
		it.destroy();
		return olaps;
	}
	
	public override bool neibor(StringStructure other) {
		bool nbr = false;
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix x = can.get();
			int xy = x.higherOrderXY;
			//print("checking neibor around %d, %d\n", x.higherOrderX, x.higherOrderY);
			core.assert(x == getMatrixAt(xy));
			if(other.getMatrixAt(xy) != null
				|| other.getMatrixAt(xy+1) != null
				|| other.getMatrixAt(xy-1) != null) {
				nbr = true;
				//print("Neibor ......\n");
				break;
			}
			xy += columns;
			if(other.getMatrixAt(xy) != null
				|| other.getMatrixAt(xy+1) != null
				|| other.getMatrixAt(xy-1) != null) {
				nbr = true;
				print("Neibor ......\n");
				break;
			}
			xy -= columns;
			xy -= columns;
			if(xy > 0 && (other.getMatrixAt(xy) != null
				|| other.getMatrixAt(xy+1) != null
				|| other.getMatrixAt(xy-1) != null)) {
				nbr = true;
				print("Neibor ......\n");
				break;
			}
		}
		it.destroy();
		return nbr;
	}
	
	public override void merge(StringStructure other) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		other.getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix x = can.get();
			//print("Merging ......\n");
			if(getMatrixAt(x.higherOrderXY) == null) {
				appendMatrix(x);
			}
		}
		it.destroy();
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
	public override int thin() {
		// for all the matrices..
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		getIterator(&it, Replica_flags.ALL, 0);
		ImageMatrix? a = null;
		ImageMatrix? b = null;
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix c = can.get();
			if(a == null) {
				a = c;
				continue;
			}
			if(b == null) {
				b = c;
				continue;
			}
			if((b.higherOrderXY - a.higherOrderXY == 1) && (c.higherOrderXY - b.higherOrderXY == 1)) {
				// Oh 3 points in a row !
				// discard a
				removeMatrixAT(a.higherOrderXY);
			}
			a = b;
			b = c;
		}

		base.thin();
		return 0;

	}
	public virtual ImageMatrix? createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		return null;
	}
}
/** @} */
