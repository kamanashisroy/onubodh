using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class shotodol.BookDetectCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		FEATURES,
		MIN_GRAY_VAL,
		RADIUS_SHIFT,
		HEAL,
		MERGE,
	}
	public BookDetectCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		etxt features = etxt.from_static("-features");
		etxt features_help = etxt.from_static("Features mask for matrices");
		etxt mingrayval = etxt.from_static("-mgval");
		etxt mingrayval_help = etxt.from_static("Required grayval(value) in lines");
		etxt radius_shift = etxt.from_static("-rshift");
		etxt radius_shift_help = etxt.from_static("Matrix radius by power of 2");
		etxt heal = etxt.from_static("-heal");
		etxt heal_help = etxt.from_static("enable healing the lines with points");
		etxt merge = etxt.from_static("-merge");
		etxt merge_help = etxt.from_static("merge the lines");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help);
		addOption(&features, M100Command.OptionType.TXT, Options.FEATURES, &features_help);
		addOption(&mingrayval, M100Command.OptionType.TXT, Options.MIN_GRAY_VAL, &mingrayval_help); 
		addOption(&radius_shift, M100Command.OptionType.TXT, Options.RADIUS_SHIFT, &radius_shift_help); 
		addOption(&heal, M100Command.OptionType.NONE, Options.HEAL, &heal_help); 
		addOption(&merge, M100Command.OptionType.NONE, Options.MERGE, &merge_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("bookdetect");
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
			int minGrayVal = 10;
			if((mod = vals.search(Options.MIN_GRAY_VAL, match_all)) != null) {
				minGrayVal = mod.get().to_int();
			}
			int radius_shift = 4;
			if((mod = vals.search(Options.RADIUS_SHIFT, match_all)) != null) {
				radius_shift = mod.get().to_int();
			}
			int featureVals[8];
			int featureOps[8];
			int i = 0;
			for(i = 0; i < 8; i++) {
				featureVals[i] = 0;
				featureOps[i] = 0;
			}
			if((mod = vals.search(Options.FEATURES, match_all)) != null) {
				unowned txt fstring = mod.get();
				ImageMatrixUtils.parseFeatures(fstring, featureVals, featureOps);
			}
			BookDetect s = new BookDetect(&img, minGrayVal, radius_shift, featureVals, featureOps);
			s.compile();
			if((mod = vals.search(Options.MERGE, match_all)) != null) {
				s.merge();
			}
			if((mod = vals.search(Options.HEAL, match_all)) != null) {
				s.heal();
			}
			//FileOutputStream fos = new FileOutputStream.from_file(outfile);
			//s.dump(fos);
			s.dumpImage(outfile);
			s.dumpFeatures(outfile);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

/** @} */
