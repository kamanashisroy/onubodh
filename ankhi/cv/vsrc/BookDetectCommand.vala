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
		CRACKLEN,
		CONTINUITY,
		MIN_GRAY_VAL,
		RADIUS_SHIFT,
		HEAL,
	}
	public BookDetectCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		etxt crackLen = etxt.from_static("-crk");
		etxt crackLen_help = etxt.from_static("Crack lengths allowed in lines");
		etxt continuity = etxt.from_static("-cont");
		etxt continuity_help = etxt.from_static("Required continuity(value) in lines");
		etxt mingrayval = etxt.from_static("-mgval");
		etxt mingrayval_help = etxt.from_static("Required grayval(value) in lines");
		etxt radius_shift = etxt.from_static("-rshift");
		etxt radius_shift_help = etxt.from_static("Matrix radius by power of 2");
		etxt heal = etxt.from_static("-heal");
		etxt heal_help = etxt.from_static("enable healing the lines with points");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help);
		addOption(&crackLen, M100Command.OptionType.TXT, Options.CRACKLEN, &crackLen_help);
		addOption(&continuity, M100Command.OptionType.TXT, Options.CONTINUITY, &continuity_help); 
		addOption(&mingrayval, M100Command.OptionType.TXT, Options.MIN_GRAY_VAL, &mingrayval_help); 
		addOption(&radius_shift, M100Command.OptionType.TXT, Options.RADIUS_SHIFT, &radius_shift_help); 
		addOption(&heal, M100Command.OptionType.NONE, Options.HEAL, &heal_help); 
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
			int allowedCrackLen = 2;
			if((mod = vals.search(Options.CRACKLEN, match_all)) != null) {
				allowedCrackLen = mod.get().to_int();
			}
			int lineContinuity = 10;
			if((mod = vals.search(Options.CONTINUITY, match_all)) != null) {
				lineContinuity = mod.get().to_int();
			}
			int minGrayVal = 10;
			if((mod = vals.search(Options.MIN_GRAY_VAL, match_all)) != null) {
				minGrayVal = mod.get().to_int();
			}
			int radius_shift = 4;
			if((mod = vals.search(Options.RADIUS_SHIFT, match_all)) != null) {
				radius_shift = mod.get().to_int();
			}
			//FileOutputStream fos = new FileOutputStream.from_file(outfile);
			BookDetect s = new BookDetect(&img, allowedCrackLen, lineContinuity, minGrayVal, radius_shift);
			s.compile();
			if((mod = vals.search(Options.HEAL, match_all)) != null) {
				s.heal();
			}
			//s.dump(fos);
			s.dumpImage(outfile);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

/** @} */
