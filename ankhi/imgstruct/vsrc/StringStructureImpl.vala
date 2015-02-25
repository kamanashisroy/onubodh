using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public class onubodh.StringStructureImpl : StringStructure {
	protected aroop_uword8 requiredGrayVal;
	protected netpbmg*img;
	protected int img_width;
	protected int img_height;
	protected int columns;
	protected int rows;
	protected int radius; // 4 or 8, it is actually the size of the matrix
	protected aroop_uword8 shift; // 2 if 4 and 3 if 8 so on ..
	int reqVals[ImageMatrixString.MAX_FEATURES];
	int reqOps[ImageMatrixString.MAX_FEATURES];
	public StringStructureImpl(netpbmg*src, int yourShift, aroop_uword8 minGrayVal, int[]featureVals, int[]featureOps) {
		buildStringStructureImpl(src, yourShift);
		int i = 0;
		for(i = 0; i < ImageMatrixString.MAX_FEATURES; i++) {
			reqVals[i] = featureVals[i];
			reqOps[i] = featureOps[i];
		}
		requiredGrayVal = minGrayVal;
	}
	
	public void buildStringStructureImpl(netpbmg*src, int yourShift) {
		buildStringStructure();
		img = src;
		radius = 1<<yourShift;
		shift = (aroop_uword8)yourShift;
	}

	public int getShift() {
		return shift;
	}

	public override bool pruneMatrix(ImageMatrix mat) {
		int i = 0;
		for(i = 0; i < ImageMatrixString.MAX_FEATURES; i++) {
			int ft = mat.getFeature(i);
			switch(reqOps[i]) {
			case ImageMatrixUtils.feature_ops.GT:
				if(ft <= reqVals[i]) return true;
				break;
			case ImageMatrixUtils.feature_ops.LT:
				if(ft >= reqVals[i]) return true;
				break;
			case ImageMatrixUtils.feature_ops.EQ:
				if(ft != reqVals[i]) return true;
				break;
			default:
				break;
			}
		}
		return false;
	}

	protected int showProgress() {
		print("#");
		shotodol_platform.ProcessControl.mesmerize();
		return 0;
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
				ImageMatrix mat = createMatrix2(x, y);
				mat.compile();
				if(!pruneMatrix(mat)) {
					appendMatrix(mat);
				}
			}
			showProgress();
		}
		print("Total interesting matrices:%d\n", getLength());
		return 0;
	}

	public override int getCracksInPixels() {
		int crk = 0;
		Iterator<AroopPointer<ImageMatrixString>> it = Iterator<AroopPointer<ImageMatrixString>>();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			AroopPointer<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.getUnowned();
			crk += mat.getFeature(ImageMatrixStringNearLinear.feat.CRACKS);
		}
		it.destroy();
		crk += cracks<<shift;
		return crk;
	}
	
	public override bool overlaps(StringStructure other) {
		bool olaps = false;
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		getIterator(&it, Replica_flags.ALL, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix x = can.getUnowned();
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
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		getIterator(&it, Replica_flags.ALL, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix x = can.getUnowned();
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
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		other.getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix x = can.getUnowned();
			//print("Merging ......\n");
			if(getMatrixAt(x.higherOrderXY) == null) {
				appendMatrix(x);
			}
		}
		it.destroy();
	}
	
#if false
	public int mark(int val) {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			if(can.getUnowned().getVal() == val) {
				can.mark(1);
			}
		}
		return 0;
	}	
	public int dump(OutputStream os) {
		int x,y;
		int i;
		extring val = extring.stack(32);
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
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		getIterator(&it, Replica_flags.ALL, 0);
		ImageMatrix? a = null;
		ImageMatrix? b = null;
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix c = can.getUnowned();
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
	public override void dumpFeatures(OutputStream os) {
		extring val = extring.stack(512);
		extring data = extring.stack(128);
		extring intval = extring.stack(32);
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		getIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix mat = can.getUnowned();
			int higher_order_x = mat.higherOrderX;
			int higher_order_y = mat.higherOrderY;
			int i;
			data.truncate();
			for(i=0; i < ImageMatrixString.MAX_FEATURES; i++) {
				intval.printf("%d,", mat.getFeature(i));
				data.concat(&intval);
			}
			data.zero_terminate();
			val.printf("<area shape=\"rect\" coords=\"%d,%d,%d,%d\"  href=\"javascript:void(0)\" onclick=\"updateVal(this.title);\" title=\"%s\"/>\n", mat.left, mat.top, mat.left+radius, mat.top+radius, data.to_string());
			val.zero_terminate();
			os.write(&val);
		}
		os.close();
		data.destroy();
		val.destroy();
	}
	public virtual ImageMatrix? createMatrix2(int x, int y) {
		return null;
	}
}
/** @} */
