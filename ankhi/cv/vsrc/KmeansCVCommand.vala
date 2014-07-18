using aroop;
using shotodol;


/**
 * \addtogroup bookdetect
 * @{
 */
public class shotodol.KmeansCVCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
		K_VAL,
	}
	public KmeansCVCommand() {
		extring prefix = extring.set_static_string("cvkmeans");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input ppm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output ppm file."); 
		addOptionString("-k", M100Command.OptionType.INT, Options.K_VAL, "value of k");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?infile = null;
		xtring?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int kval = 30;
		xtring?arg = null;
		if((arg = vals[Options.K_VAL]) != null) {
			kval = arg.ecast().to_int();
		}
		int ecode = 0;
		extring dlg = extring.stack(128);
		dlg.printf("<Computer Vision>kmeans cluster:%s -> %s\n", infile.ecast().to_string(), outfile.ecast().to_string());
		pad.write(&dlg);
		if(shotodol_dryman_kmeans.dryman_kmeans.cluster(infile.ecast().to_string(), outfile.ecast().to_string(), kval, &ecode) != 0) {
			dlg.printf("<Computer Vision> Internal error while filtering %d\n", ecode);
			pad.write(&dlg);
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		return 0;
	}
}

/** @} */
