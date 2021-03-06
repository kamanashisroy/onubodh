using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class shotodol.BarcodeROIDetectCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
		MIN_GRAY_VAL,
		RADIUS_SHIFT,
		FEATURES,
		NO_IMAGE_OUTPUT,
	}
	public BarcodeROIDetectCommand() {
		extring prefix = extring.set_static_string("barcodedetect");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		addOptionString("-features", M100Command.OptionType.TXT, Options.FEATURES, "Required features. Comma separated values.");
		addOptionString("-mgval", M100Command.OptionType.TXT, Options.MIN_GRAY_VAL, "Required grayval(value) in lines"); 
		addOptionString("-rshift", M100Command.OptionType.TXT, Options.RADIUS_SHIFT, "Matrix radius by power of 2"); 
		addOptionString("-noimgout", M100Command.OptionType.NONE, Options.NO_IMAGE_OUTPUT, "Do not dump image"); 
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int ecode = 0;
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?infile = null;
		xtring?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		netpbmg img = netpbmg.for_file(infile.fly().to_string());
		if(img.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
		}
		int featureVals[ImageMatrixString.MAX_FEATURES];
		int featureOps[ImageMatrixString.MAX_FEATURES];
		int i = 0;
		for(i = 0; i < ImageMatrixString.MAX_FEATURES; i++) {
			featureVals[i] = 0;
			featureOps[i] = 0;
		}
		xtring?fstring = vals[Options.FEATURES];
		if(fstring != null) {
			ImageMatrixUtils.parseFeatures(fstring, featureVals, featureOps);
		}
		int minGrayVal = 10;
		xtring?arg = null;
		if((arg = vals[Options.MIN_GRAY_VAL]) != null) {
			minGrayVal = arg.fly().to_int();
		}
		int radius_shift = 4;
		if((arg = vals[Options.RADIUS_SHIFT]) != null) {
			radius_shift = arg.fly().to_int();
		}
		bool output_image = true;
		if((arg = vals[Options.NO_IMAGE_OUTPUT]) != null) {
			output_image = false;
		}
		BarcodeROIDetect s = new BarcodeROIDetect(&img, minGrayVal, radius_shift, featureVals, featureOps);
		s.compile();
		if(output_image) {
			s.dumpImage(outfile);
		}
		s.dumpFeatures(outfile);
		return 0;
	}
}

/** @} */
