using aroop;
using shotodol;

/**
 * \ingroup ankhi
 * \defgroup imgdiff Image Diff Command
 */
/**
 * \addtogroup imgdiff
 * @{
 */
/** @} */
public class onubodh.ImageDiffCommand : M100Command {
	enum Options {
		INFILE1 = 1,
		INFILE2,
		OUTFILE,
	}
	public ImageDiffCommand() {
		extring prefix = extring.set_static_string("imgdiff");
		base(&prefix);
		addOptionString("-i1", M100Command.OptionType.TXT, Options.INFILE1, "First input file");
		addOptionString("-i2", M100Command.OptionType.TXT, Options.INFILE2, "Second input file");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file(The diff file)"); 
	}

	public int diff(netpbmg*dst, netpbmg*first, netpbmg*second) {
		int x,y;
		for(y=0;y<dst.height;y++) {
			for(x=0;x<dst.width;x++) {
				netpbm_rgb fcolor = netpbm_rgb();
				netpbm_rgb scolor = netpbm_rgb();
				netpbm_rgb dcolor = netpbm_rgb();
				first.getPixel(x,y,&fcolor);
				second.getPixel(x,y,&scolor);
				dcolor.r = fcolor.r-scolor.r;
				dcolor.g = fcolor.g-scolor.g;
				dcolor.b = fcolor.b-scolor.b;
				dst.setPixel(x,y,&dcolor);
			}
		}
		return 0;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int ecode = 0;
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?x = null;
		xtring?y = null;
		xtring?z = null;
		if((x = vals[Options.INFILE1]) == null || (y = vals[Options.INFILE2]) == null || (z = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		netpbmg firstimg = netpbmg.for_file(x.ecast().to_string());
		if(firstimg.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open first input.");
		}
		netpbmg secondimg = netpbmg.for_file(y.ecast().to_string());
		if(secondimg.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open second input.");
		}
		// sanity check
		if(firstimg.width != secondimg.width || firstimg.height != secondimg.height || firstimg.type != secondimg.type) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, The two input files are of different size/type.");
		}
		netpbmg oimg = netpbmg.alloc_like(&firstimg);
		diff(&oimg, &firstimg, &secondimg);
		oimg.write(z.ecast().to_string());
		//pngcoder.encode(outfile.to_string(), &oimg);
		oimg.close();
		return 0;
	}
}
