using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
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
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		etxt foutput = etxt.from_static("-fo");
		etxt foutput_help = etxt.from_static("Feature output file");
		etxt features = etxt.from_static("-features");
		etxt features_help = etxt.from_static("Required features. Comma separated values.");
		etxt mingrayval = etxt.from_static("-mgval");
		etxt mingrayval_help = etxt.from_static("Required grayval(value) in lines");
		etxt radius_shift = etxt.from_static("-rshift");
		etxt radius_shift_help = etxt.from_static("Matrix radius by power of 2");
		etxt structType = etxt.from_static("-st");
		etxt structType_help = etxt.from_static("Specify which structure to use, 0 for line, 1 for block");
		etxt noimgout = etxt.from_static("-noimgout");
		etxt noimgout_help = etxt.from_static("Do not dump image");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help);
		addOption(&foutput, M100Command.OptionType.TXT, Options.FEATURE_OUTFILE, &foutput_help);
		addOption(&features, M100Command.OptionType.TXT, Options.FEATURES, &features_help);
		addOption(&mingrayval, M100Command.OptionType.TXT, Options.MIN_GRAY_VAL, &mingrayval_help); 
		addOption(&radius_shift, M100Command.OptionType.TXT, Options.RADIUS_SHIFT, &radius_shift_help); 
		addOption(&structType, M100Command.OptionType.TXT, Options.STRUCTURE_TYPE, &structType_help); 
		addOption(&noimgout, M100Command.OptionType.NONE, Options.NO_IMAGE_OUTPUT, &noimgout_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("structdetect");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE, match_all)) == null) {
				break;
			}
			unowned txt infile = mod.get();
			if((mod = vals.search(Options.OUTFILE, match_all)) == null) {
				break;
			}
			netpbmg img = netpbmg.for_file(infile.to_string());
			if(img.open(&ecode) != 0) {
				break;
			}
			unowned txt outfile = mod.get();
			int featureVals[ImageMatrixString.feat.MAX_FEATURES];
			int featureOps[ImageMatrixString.feat.MAX_FEATURES];
			int i = 0;
			for(i = 0; i < ImageMatrixString.feat.MAX_FEATURES; i++) {
				featureVals[i] = 0;
				featureOps[i] = 0;
			}
			if((mod = vals.search(Options.FEATURES, match_all)) != null) {
				unowned txt fstring = mod.get();
				ImageMatrixUtils.parseFeatures(fstring, featureVals, featureOps);
			}
			int minGrayVal = 10;
			if((mod = vals.search(Options.MIN_GRAY_VAL, match_all)) != null) {
				minGrayVal = mod.get().to_int();
			}
			int radius_shift = 4;
			if((mod = vals.search(Options.RADIUS_SHIFT, match_all)) != null) {
				radius_shift = mod.get().to_int();
			}
			int tp = 0;
			if((mod = vals.search(Options.STRUCTURE_TYPE, match_all)) != null) {
				tp = mod.get().to_int();
			}
			StructureDetect s = new StructureDetect(&img, tp, minGrayVal, radius_shift, featureVals, featureOps);
			s.compile();
			bool output_image = true;
			if((mod = vals.search(Options.NO_IMAGE_OUTPUT, match_all)) != null) {
				output_image = false;
			}
			if(output_image) {
				s.dumpImage(outfile);
			}
			unowned txt?featuresfile = null;
			if((mod = vals.search(Options.FEATURE_OUTFILE, match_all)) != null) {
				featuresfile = mod.get();
			}
			s.dumpFeatures(outfile, featuresfile);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

/** @} */
