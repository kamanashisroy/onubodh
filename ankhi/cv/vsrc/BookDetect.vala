using aroop;
using shotodol;
using onubodh;

public class onubodh.BookDetect : Replicable {
	LineString circuit;
	netpbmg*orig;
	public BookDetect(netpbmg*src) {
		circuit = new LineString(src);
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
		//out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image);
		out_image.write(nm.to_string());
		out_image.close();
	}
}
