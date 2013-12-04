using aroop;
using shotodol;
using onubodh;

public class onubodh.BookDetect : Replicable {
	ImageManipulateLineString circuit;
	netpbmg*orig;
	public BookDetect(netpbmg*src) {
		circuit = new ImageManipulateLineString(src);
		orig = src;
	}

	public int compile() {
		circuit.compile4();
		//circuit.mark(4);
		circuit.parseLines();
		return 0;
	}

	public void dump(OutputStream os) {
		circuit.dumpString(os);
	}
	public void dumpImage(etxt*nm) {
		netpbmg out_image = netpbmg.alloc_like(orig);
		out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image);
		out_image.write();
		out_image.close();
	}
}
