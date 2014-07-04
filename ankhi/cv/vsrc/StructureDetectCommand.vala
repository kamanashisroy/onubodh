using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup cv
 * @{
 * \useage 
 * 
 * bookdetecttest:
 *       structdetect -mgval 30 -i $(INPUTFILE) -o output.pgm -rshift 4 -features ">15,,,,,=15,<5"
 *       convert -i output.pgm -o output.jpg
 *       convert -i $(INPUTFILE) -o input.jpg
 *
 *
 *   barcodedetect:
 *        structdetect -st 1 -features ",,,,,,,>10" -mgval 60 -i $(INPUTFILE) -o output.pgm -rshift 3
 *        convert -i output.pgm -o output.jpg
 *        convert -i $(INPUTFILE) -o input.jpg
 *
 */
public class shotodol.StructureDetectCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		FEATURE_OUTFILE,
		MIN_GRAY_VAL,
		RADIUS_SHIFT,
		FEATURES,
		STRUCTURE_TYPE,
		NO_IMAGE_OUTPUT,
	}
	public StructureDetectCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		addOptionString("-features", M100Command.OptionType.TXT, Options.FEATURES, "Required features. Comma separated values.");
		addOptionString("-mgval", M100Command.OptionType.TXT, Options.MIN_GRAY_VAL, "Required grayval(value) in lines"); 
		addOptionString("-rshift", M100Command.OptionType.TXT, Options.RADIUS_SHIFT, "Matrix radius by power of 2"); 
		addOptionString("-noimgout", M100Command.OptionType.NONE, Options.NO_IMAGE_OUTPUT, "Do not dump image"); 
		addOptionString("-st", M100Command.OptionType.TXT, Options.STRUCTURE_TYPE, "Specify which structure to use, 0 for line, 1 for block"); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("structdetect");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		int ecode = 0;
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = null;
		txt?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		netpbmg img = netpbmg.for_file(infile.to_string());
		if(img.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
		}
		int featureVals[ImageMatrixString.feat.MAX_FEATURES];
		int featureOps[ImageMatrixString.feat.MAX_FEATURES];
		int i = 0;
		for(i = 0; i < ImageMatrixString.feat.MAX_FEATURES; i++) {
			featureVals[i] = 0;
			featureOps[i] = 0;
		}
		txt?fstring = vals[Options.FEATURES];
		if(fstring != null) {
			ImageMatrixUtils.parseFeatures(fstring, featureVals, featureOps);
		}
		int minGrayVal = 10;
		txt?arg = null;
		if((arg = vals[Options.MIN_GRAY_VAL]) != null) {
			minGrayVal = arg.to_int();
		}
		int radius_shift = 4;
		if((arg = vals[Options.RADIUS_SHIFT]) != null) {
			radius_shift = arg.to_int();
		}
		bool output_image = true;
		if((arg = vals[Options.NO_IMAGE_OUTPUT]) != null) {
			output_image = false;
		}
		int tp = 0;
		if((arg = vals[Options.STRUCTURE_TYPE]) != null) {
			tp = arg.to_int();
		}
		StructureDetect s = new StructureDetect(&img, tp, minGrayVal, radius_shift, featureVals, featureOps);
		s.compile();
		if(output_image) {
			s.dumpImage(outfile);
		}
		txt?featuresfile = vals[Options.FEATURE_OUTFILE];
		s.dumpFeatures(outfile, featuresfile);
		return 0;
	}
}

/** @} */
