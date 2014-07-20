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
		extring prefix = extring.set_static_string("edgefast");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input pgm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output pgm file."); 
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
		extring dlg = extring.stack(128);
		dlg.printf("<Edge detect>edge filter:%s -> %s\n", infile.fly().to_string(), outfile.fly().to_string());
		pad.write(&dlg);
		if(shotodol_fastedge.fastedge_filter.filter(infile.fly().to_string(), outfile.fly().to_string(), &ecode) != 0) {
			dlg.printf("<Edge detect> Internal error while filtering %d\n", ecode);
			pad.write(&dlg);
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, It did not work.");
		}
		return 0;
	}
}

/** @} */
