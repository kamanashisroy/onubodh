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
public class onubodh.StructureDetect : Replicable {
	public enum imgStructTypes {
		LINE = 0,
		BLOCK,
		BLOCK_CLUSTER,
	}
	StringStructureImpl circuit;
	netpbmg*orig;
	public StructureDetect(netpbmg*src, int tp, int minGrayVal, int radius_shift, int[] featureVals, int[] featureOps) {
		orig = src;
		if(tp == imgStructTypes.BLOCK_CLUSTER) {
			circuit = new BlockStringCluster(src
				, radius_shift, (aroop_uword8)minGrayVal
				, featureVals, featureOps);
		} else if(tp == imgStructTypes.BLOCK) {
			circuit = new BlockString(src
				, radius_shift, (aroop_uword8)minGrayVal
				, featureVals, featureOps);
		} else {
			circuit = new ManyLineStrings(src
				, (aroop_uword8)minGrayVal
				, radius_shift, featureVals, featureOps);
		}
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

	public void dumpFeatures(estr*nm, estr*fnm) {
		estr featuresfile = estr.stack(512);
		if(fnm != null) {
			featuresfile.concat(fnm);
		} else {
			featuresfile.concat_string("features_");
			featuresfile.concat(nm);
			featuresfile.concat_string(".txt");
		}
		featuresfile.zero_terminate();
		FileOutputStream fos = new FileOutputStream.from_file(&featuresfile);
		circuit.dumpFeatures(fos);
		fos.close();
	}
}
/** @} */
