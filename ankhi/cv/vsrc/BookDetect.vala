using aroop;
using shotodol;
using onubodh;


/**
 * \defgroup ankhi An intelligent image processing library
 */

/**
 * \ingroup ankhi
 * \defgroup bookdetect Detect book
 */
/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.BookDetect : Replicable {
	ManyLineStrings circuit;
	netpbmg*orig;
	public BookDetect(netpbmg*src, int allowedCrackLen, int requiredLength, int minGrayVal, int radius_shift) {
		circuit = new ManyLineStrings(src
			, allowedCrackLen
			, requiredLength
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
		print("Merging ..\n");
		circuit.mergeOverlapingLines();
		print("Filling ..\n");
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
/** @} */
