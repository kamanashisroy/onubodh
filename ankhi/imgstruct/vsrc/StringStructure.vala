using aroop;
using shotodol;
using onubodh;

public abstract class onubodh.StringStructure : Replicable {
	protected Set<ImageMatrix> strings;
	public StringStructure() {
		strings = Set<ImageMatrix>();
	}

	public virtual int append(ImageMatrix x) {
		strings.add(x);
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

	public virtual void dumpImage(netpbmg*oimg) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix mat = can.get();
			mat.dumpImage(oimg);
		}
		it.destroy();
	}
}
