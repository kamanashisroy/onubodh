using aroop;
using shotodol;


/**
 * \addtogroup bookdetect
 * @{
 */
public class shotodol.KmeansCVCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		K_VAL,
	}
	public KmeansCVCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input ppm file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output ppm file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
		etxt k = etxt.from_static("-k");
		etxt k_help = etxt.from_static("value of k");
		addOption(&k, M100Command.OptionType.TXT, Options.K_VAL, &k_help);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("cvkmeans");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
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
			unowned txt outfile = mod.get();
			int kval = 30;
			if((mod = vals.search(Options.K_VAL, match_all)) != null) {
				kval = mod.get().to_int();
			}
			int ecode = 0;
			etxt dlg = etxt.stack(128);
			dlg.printf("<Computer Vision>kmeans cluster:%s -> %s\n", infile.to_string(), outfile.to_string());
			pad.write(&dlg);
			if(shotodol_dryman_kmeans.dryman_kmeans.cluster(infile.to_string(), outfile.to_string(), kval, &ecode) != 0) {
				dlg.printf("<Computer Vision> Internal error while filtering %d\n", ecode);
				pad.write(&dlg);
			}
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

/** @} */
