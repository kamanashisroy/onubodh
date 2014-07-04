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
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input ppm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output ppm file."); 
		addOptionString("-k", M100Command.OptionType.INT, Options.K_VAL, "value of k");
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("cvkmeans");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = null;
		txt?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int kval = 30;
		txt?arg = null;
		if((arg = vals[Options.K_VAL]) != null) {
			kval = arg.to_int();
		}
		int ecode = 0;
		etxt dlg = etxt.stack(128);
		dlg.printf("<Computer Vision>kmeans cluster:%s -> %s\n", infile.to_string(), outfile.to_string());
		pad.write(&dlg);
		if(shotodol_dryman_kmeans.dryman_kmeans.cluster(infile.to_string(), outfile.to_string(), kval, &ecode) != 0) {
			dlg.printf("<Computer Vision> Internal error while filtering %d\n", ecode);
			pad.write(&dlg);
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		return 0;
	}
}

/** @} */
