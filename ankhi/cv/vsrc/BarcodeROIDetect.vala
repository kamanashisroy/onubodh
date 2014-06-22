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
	SparseBlockString circuit;
	netpbmg*orig;
	public BarcodeROIDetect(netpbmg*src, int minGrayVal, int radius_shift, int[] featuresVals, int[] featureOps) {
		circuit = new SparseBlockString(src
			, (aroop_uword8)minGrayVal
			, radius_shift, featuresVals, featureOps);
		orig = src;
	}

	public int compile() {
		return circuit.compile();
	}
	
	public void dumpImage(etxt*nm) {
		print("Dumping ..\n");
		netpbmg out_image = netpbmg.alloc_like(orig);
		//out_image.set_filename(nm.to_string());
		circuit.dumpImage(&out_image, 240);
		out_image.write(nm.to_string());
		out_image.close();
	}

	public void dumpFeatures(etxt*nm) {
		etxt featuresfile = etxt.stack(128);
		featuresfile.concat_string("features_");
		featuresfile.concat(nm);
		featuresfile.concat_string(".txt");
		FileOutputStream fos = new FileOutputStream.from_file(&featuresfile);
		circuit.dumpFeatures(fos);
		fos.close();
	}
}
/** @} */
