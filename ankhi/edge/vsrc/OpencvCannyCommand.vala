using aroop;
using shotodol;
using onubodh;


/**
 * \addtogroup edgedetect
 * @{
 */
public class shotodol.OpencvCannyCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public OpencvCannyCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input pgm file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output pgm file."); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("edgecanny");
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
		netpbmg iimg = netpbmg.for_file(infile.to_string());
		if(iimg.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
		}
		netpbmg oimg = netpbmg.alloc_like(&iimg);
#if false
		shotodol_opencv.ArrayImage iAimg = shotodol_opencv.ArrayImage.from(iimg.width, iimg.height, iimg.grayData);
		shotodol_opencv.ArrayImage oAimg = shotodol_opencv.ArrayImage.from(oimg.width, oimg.height, oimg.grayData);
		shotodol_opencv.EdgeDetect.canny(&iAimg, &oAimg, 100, 200);
#else
		core.assert("Opencv is not working" == null);
#endif
		oimg.write(outfile.to_string());
		return 0;
	}
}

/** @} */
