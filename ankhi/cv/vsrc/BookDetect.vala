using aroop;
using shotodol;
using onubodh;

public class onubodh.BookDetect : Replicable {
	ManyLineStrings circuit;
	netpbmg*orig;
	public BookDetect(netpbmg*src) {
		circuit = new ManyLineStrings(src);
		orig = src;
	}

	public int compile() {
		circuit.compile();
		return 0;
	}

	public void dumpImage(etxt*nm) {
		netpbmg out_image = netpbmg.alloc_like(orig);
		//out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image);
		out_image.write(nm.to_string());
		out_image.close();
	}
}
