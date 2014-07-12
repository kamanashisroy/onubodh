using aroop;
using shotodol;

/**
 * \addtogroup imgscale
 * @{
 */
public class onubodh.ImageScaleCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
		UPSAMPLE,
		DOWNSAMPLE,
	}
	public ImageScaleCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file"); 
		addOptionString("-up", M100Command.OptionType.TXT, Options.UPSAMPLE, "Upsample to a multiple, say '-up 2' means sampling it to twice");
		addOptionString("-down", M100Command.OptionType.TXT, Options.DOWNSAMPLE, "Downsample to a multiple, say '-down 2' means sampling it to half");
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("scale");
		return &prfx;
	}

	public int upsample(netpbmg dst, netpbmg src, int up) {
		int x,y;
		if(up == 0) {
			up = 1;
		}
		for(y=0;y<dst.height;y++) {
			int srcyval = y/up;
			for(x=0;x<dst.width;x++) {
				netpbm_rgb color = netpbm_rgb();
				src.getPixel(x/up,srcyval,&color);
				dst.setPixel(x,y,&color);
			}
		}
		return 0;
	}
	public int downsample(netpbmg dst, netpbmg src, int down) {
		int x,y;
		if(down == 0) {
			down = 1;
		}
		for(y=0;y<dst.height;y++) {
			int srcyval = y*down;
			for(x=0;x<dst.width;x++) {
				netpbm_rgb color = netpbm_rgb();
				src.getPixel(x*down,srcyval,&color);
				dst.setPixel(x,y,&color);
			}
		}
		return 0;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int ecode = 0;
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = vals[Options.INFILE];
		txt?outfile = vals[Options.OUTFILE];
		if(infile == null || outfile == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		netpbmg iimg = netpbmg.for_file(infile.to_string());
		if(iimg.open(&ecode) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument: cannot open input file.");
		}
		txt?arg = vals[Options.UPSAMPLE];
		if(arg != null) {
			int up = arg.to_int();
			if(up == 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument: upsample ratio cannot be 0.");
			}
			netpbmg oimg = netpbmg.alloc_full(iimg.width*up, iimg.height*up, iimg.type);
			upsample(oimg, iimg, up);
			oimg.write(outfile.to_string());
			return 0;
		}
		arg = vals[Options.DOWNSAMPLE];
		if(arg != null) {
			int down = arg.to_int();
			if(down == 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument: downsample ratio cannot be 0.");
			}
			netpbmg oimg = netpbmg.alloc_full(iimg.width/down, iimg.height/down, iimg.type);
			downsample(oimg, iimg, down);
			oimg.write(outfile.to_string());
			return 0;
		}
		return 0;
	}
}
/** @} */
