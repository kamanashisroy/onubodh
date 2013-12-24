using aroop;
using shotodol;
using onubodh;


public class shotodol.OpencvCannyCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public OpencvCannyCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input pgm file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output pgm file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("edgecanny");
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
			etxt dlg = etxt.stack(128);
			dlg.printf("<Edge detect>edge filter:%s -> %s\n", infile.to_string(), outfile.to_string());
			pad.write(&dlg);
			netpbmg iimg = netpbmg.for_file(infile.to_string());
			int ecode = 0;
			if(iimg.open(&ecode) != 0) {
				return -1;
			}
			netpbmg oimg = netpbmg.alloc_like(&iimg);
			shotodol_opencv.ArrayImage iAimg = shotodol_opencv.ArrayImage.from(iimg.width, iimg.height, iimg.grayData);
			shotodol_opencv.ArrayImage oAimg = shotodol_opencv.ArrayImage.from(oimg.width, oimg.height, oimg.grayData);
			shotodol_opencv.EdgeDetect.canny(&iAimg, &oAimg, 100, 200);
			oimg.write(outfile.to_string());
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}

