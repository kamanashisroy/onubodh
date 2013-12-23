using aroop;
using shotodol;
using onubodh;

public class onubodh.StringStructure : Replicable {
	ArrayList<ImageMatrix> strings;
	int continuity;
	public StringStructure() {
		strings = ArrayList<ImageMatrix>();
	}
	
	~StringStructure() {
		strings.destroy();
	}
	
	public void setContinuity(int cont) {
		continuity = cont;
	}
	
	public int getLength() {
		return strings.count_unsafe();
	}

	public virtual int setMatrixAt(int xy, ImageMatrix x) {
		strings.set(xy, x);
		return 0;
	}
	
	public virtual ImageMatrix getMatrixAt(int xy) {
		return strings.get(xy);
	}
	
	public void getIterator(Iterator<container<ImageMatrix>>*it, int if_set, int if_not_set) {
		strings.iterator_hacked(it, if_set, if_not_set, 0);
	}
	
	public virtual int compile() {
		core.assert("Unimplemented" == null);
		return 0;
	}

	public virtual void dump(OutputStream os, int higher_order_width, int higher_order_height) {
		int x,y;
		etxt val = etxt.stack(32);
		x = 0;
		y = 0;
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix mat = can.get();
			int higher_order_x = mat.higher_order_x();
			int higher_order_y = mat.higher_order_y();
			for(;y<higher_order_y;y++,x=0) {
				for(;x<higher_order_width;x++) {
					val.printf(",");
					val.zero_terminate();
					os.write(&val);
				}
				val.printf("\n");
				val.zero_terminate();
				os.write(&val);
			}
			for(;x<higher_order_x;x++) {
				val.printf(",");
				val.zero_terminate();
				os.write(&val);
			}
			val.printf("%d,", mat.getVal());
			val.zero_terminate();
			os.write(&val);
			x++;
		}
	}

	public virtual void dumpImage(netpbmg*oimg, aroop_uword8 grayVal) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix mat = can.get();
			mat.dumpImage(oimg, grayVal);
		}
		it.destroy();
	}
}
