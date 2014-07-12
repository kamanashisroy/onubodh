using aroop;
using shotodol;
using onubodh;


/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CentroidModelCVCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		X_VAL,
		Y_VAL,
	}
	public CentroidModelCVCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		addOptionString("-x", M100Command.OptionType.INT, Options.X_VAL, "x coordinate value of the point");
		addOptionString("-y", M100Command.OptionType.INT, Options.Y_VAL, "y coordinate value of the point"); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("cvcentroid");
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
		txt?arg = null;
		if((arg = vals[Options.X_VAL]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int x = arg.to_int();
		if((arg = vals[Options.Y_VAL]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int y = arg.to_int();
		{
			etxt dlg = etxt.stack(128);
			dlg.printf("<Computer Vision> Applying centroid method on:%s, at point (%d,%d)\n", infile.to_string(), x, y);
			pad.write(&dlg);
		}
		CentroidModel cm = new CentroidModel(infile.to_string());
		cm.prepare();
		if(cm.findEdges(x,y,pad) == 0) {
			etxt dlg = etxt.from_static("<Computer Vision>Found something interesting\n");
			pad.write(&dlg);
		}
		return 0;
	}
}

/** @} */
