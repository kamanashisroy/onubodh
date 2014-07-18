using aroop;
using shotodol;
using onubodh;


/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CentroidModelCVCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
		X_VAL,
		Y_VAL,
	}
	public CentroidModelCVCommand() {
		extring prefix = extring.set_static_string("cvcentroid");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		addOptionString("-x", M100Command.OptionType.INT, Options.X_VAL, "x coordinate value of the point");
		addOptionString("-y", M100Command.OptionType.INT, Options.Y_VAL, "y coordinate value of the point"); 
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
		xtring?arg = null;
		if((arg = vals[Options.X_VAL]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int x = arg.ecast().to_int();
		if((arg = vals[Options.Y_VAL]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int y = arg.ecast().to_int();
		{
			extring dlg = extring.stack(128);
			dlg.printf("<Computer Vision> Applying centroid method on:%s, at point (%d,%d)\n", infile.ecast().to_string(), x, y);
			pad.write(&dlg);
		}
		CentroidModel cm = new CentroidModel(infile.ecast().to_string());
		cm.prepare();
		if(cm.findEdges(x,y,pad) == 0) {
			extring dlg = extring.set_static_string("<Computer Vision>Found something interesting\n");
			pad.write(&dlg);
		}
		return 0;
	}
}

/** @} */
