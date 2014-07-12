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
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input pgm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output pgm file."); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("edgefast");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
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
		etxt dlg = etxt.stack(128);
		dlg.printf("<Edge detect>edge filter:%s -> %s\n", infile.to_string(), outfile.to_string());
		pad.write(&dlg);
		if(shotodol_fastedge.fastedge_filter.filter(infile.to_string(), outfile.to_string(), &ecode) != 0) {
			dlg.printf("<Edge detect> Internal error while filtering %d\n", ecode);
			pad.write(&dlg);
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, It did not work.");
		}
		return 0;
	}
}

/** @} */
