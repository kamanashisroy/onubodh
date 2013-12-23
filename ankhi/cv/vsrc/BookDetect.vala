using aroop;
using shotodol;
using onubodh;

public class onubodh.BookDetect : Replicable {
	ManyLineStrings circuit;
	netpbmg*orig;
	public BookDetect(netpbmg*src, int allowedCrackLen, int lineContinuity, int minGrayVal, int radius_shift) {
		circuit = new ManyLineStrings(src
			, allowedCrackLen
			, lineContinuity
			, lineContinuity
			, (aroop_uword8)minGrayVal
			, radius_shift);
		orig = src;
	}

	public int compile() {
		return circuit.compile();
	}
	
	public int heal() {
		print("Healing ..\n");
		circuit.heal();
		circuit.fill();
		return 0;
	}

	public void dumpImage(etxt*nm) {
		print("Dumping ..\n");
		netpbmg out_image = netpbmg.alloc_like(orig);
		//out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image, 240);
		out_image.write(nm.to_string());
		out_image.close();
	}
}
