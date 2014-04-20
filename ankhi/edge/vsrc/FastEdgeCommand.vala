using aroop;
using shotodol;


/**
 * \addtogroup edgedetect
 * @{
 */
public class shotodol.FastEdgeCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public FastEdgeCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input pgm file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output pgm file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("edgefast");
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
			unowned txt outfile = mod.get(); // should be pgm file
			int ecode = 0;
			etxt dlg = etxt.stack(128);
			dlg.printf("<Edge detect>edge filter:%s -> %s\n", infile.to_string(), outfile.to_string());
			pad.write(&dlg);
			if(shotodol_fastedge.fastedge_filter.filter(infile.to_string(), outfile.to_string(), &ecode) != 0) {
				dlg.printf("<Edge detect> Internal error while filtering %d\n", ecode);
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
