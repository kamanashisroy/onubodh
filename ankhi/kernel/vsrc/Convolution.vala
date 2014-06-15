using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup kernelop
 * @{
 */
public class onubodh.kernel.Convolution : Replicable {
	protected netpbmg*img;
	protected int img_width;
	protected int img_height;
	int radius; // 4 or 8, it is actually the size of the matrix
	etxt kernel;
	public Convolution(netpbmg*src, int gRadius) {
		img = src;
		radius = gRadius;
		img_width = img.width;
		img_height = img.height;
		kernel = etxt.EMPTY();
		kernel.buffer(gRadius*gRadius);
	}

	~Convolution() {
		kernel.destroy();
	}

	public int concatKernel(aroop_uword8 val) {
		kernel.concat_char(val);
		return 0;
	}
	
	public override int compile() {
		int x,y;
		for(y=0;y<img_height;y++) {
			for(x=0;x<img_width;x++) {
				aroop_uword8 gval = 0;
				img.getGrayVal(x,y,&gval);
				// TODO fill me
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
		for(y=0,i=0;y<img_height;y+=radius) {
			for(x=0;x<img_width;x+=radius,i++) {
				etxt val = etxt.stack(4);
				val.concat_char(strings[i].getVal());
				val.zero_terminate();
				os.write(&val);
			}
		}
		return 0;
	}
}
/** @} */
