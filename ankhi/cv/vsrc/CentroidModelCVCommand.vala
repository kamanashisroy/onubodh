using aroop;
using shotodol;


public class shotodol.CentroidModelCVCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		X_VAL,
		Y_VAL,
	}
	public CentroidModelCVCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
		etxt x = etxt.from_static("-x");
		etxt x_help = etxt.from_static("x coordinate value of the point");
		etxt y = etxt.from_static("-y");
		etxt y_help = etxt.from_static("y coordinate value of the point");
		addOption(&x, M100Command.OptionType.TXT, Options.X_VAL, &x_help);
		addOption(&y, M100Command.OptionType.TXT, Options.Y_VAL, &y_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("cvcentroid");
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
			if((mod = vals.search(Options.X_VAL, match_all)) == null) {
				break;
			}
			int x = mod.get().to_int();
			if((mod = vals.search(Options.Y_VAL, match_all)) == null) {
				break;
			}
			int y = mod.get().to_int();
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
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

