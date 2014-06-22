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
	public BookDetect(netpbmg*src, int minGrayVal, int radius_shift, int[] featureVals, int[]featureOps) {
		circuit = new ManyLineStrings(src
			, (aroop_uword8)minGrayVal
			, radius_shift, featureVals, featureOps);
		orig = src;
	}

	public int compile() {
		return circuit.compile();
	}
	
	public int heal() {
		print("Healing ..\n");
		circuit.heal();
		print("Filling ..\n");
		//circuit.fill();
		return 0;
	}

	public int merge() {
		print("Merging ..\n");
		circuit.mergeOverlapingLines();
		return 0;
	}

	public int prune() {
		print("Pruning ..\n");
		circuit.prune();
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
