using aroop;
using shotodol;


/**
 * \addtogroup edgedetect
 * @{
 */
public class shotodol.FastEdgeCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public FastEdgeCommand() {
		estr prefix = estr.set_static_string("edgefast");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input pgm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output pgm file."); 
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int ecode = 0;
		ArrayList<str> vals = ArrayList<str>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		str?infile = null;
		str?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		estr dlg = estr.stack(128);
		dlg.printf("<Edge detect>edge filter:%s -> %s\n", infile.ecast().to_string(), outfile.ecast().to_string());
		pad.write(&dlg);
		if(shotodol_fastedge.fastedge_filter.filter(infile.ecast().to_string(), outfile.ecast().to_string(), &ecode) != 0) {
			dlg.printf("<Edge detect> Internal error while filtering %d\n", ecode);
			pad.write(&dlg);
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, It did not work.");
		}
		return 0;
	}
}

/** @} */
