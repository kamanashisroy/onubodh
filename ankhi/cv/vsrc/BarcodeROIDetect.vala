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
public class onubodh.BarcodeROIDetect : Replicable {
	BlockString circuit;
	netpbmg*orig;
	public BarcodeROIDetect(netpbmg*src, int minGrayVal, int radius_shift, int[] featuresVals, int[] featureOps) {
		circuit = new BlockString(src
			, radius_shift, (aroop_uword8)minGrayVal
			, featuresVals, featureOps);
		orig = src;
	}

	public int compile() {
		return circuit.compile();
	}
	
	public void dumpImage(estr*nm) {
		print("Dumping ..\n");
		netpbmg out_image = netpbmg.alloc_like(orig);
		//out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image, 240);
		out_image.write(nm.to_string());
		out_image.close();
	}

	public void dumpFeatures(estr*nm) {
		estr featuresfile = estr.stack(512);
		featuresfile.concat_string("features_");
		featuresfile.concat(nm);
		featuresfile.concat_string(".txt");
		featuresfile.zero_terminate();
		FileOutputStream fos = new FileOutputStream.from_file(&featuresfile);
		circuit.dumpFeatures(fos);
		fos.close();
	}
}
/** @} */
