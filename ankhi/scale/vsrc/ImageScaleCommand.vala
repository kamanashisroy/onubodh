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
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		etxt up = etxt.from_static("-up");
		etxt up_help = etxt.from_static("Upsample to a multiple, say '-up 2' means sampling it to twice");
		etxt down = etxt.from_static("-down");
		etxt down_help = etxt.from_static("Downsample to a multiple, say '-down 2' means sampling it to half");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
		addOption(&up, M100Command.OptionType.TXT, Options.UPSAMPLE, &up_help);
		addOption(&down, M100Command.OptionType.TXT, Options.DOWNSAMPLE, &down_help);
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

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
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
			if((mod = vals.search(Options.UPSAMPLE, match_all)) != null) {
				int up = mod.get().to_int();
				if(up == 0) {
					break;
				}
				netpbmg iimg = netpbmg.for_file(infile.to_string());
				if(iimg.open(&ecode) != 0) {
					break;
				}
				netpbmg oimg = netpbmg.alloc_full(iimg.width*up, iimg.height*up, iimg.type);
				upsample(oimg, iimg, up);
				oimg.write(outfile.to_string());
				bye(pad, true);
				return 0;
			} else if((mod = vals.search(Options.DOWNSAMPLE, match_all)) != null) {
				int down = mod.get().to_int();
				if(down == 0) {
					break;
				}
				netpbmg iimg = netpbmg.for_file(infile.to_string());
				if(iimg.open(&ecode) != 0) {
					break;
				}
				netpbmg oimg = netpbmg.alloc_full(iimg.width/down, iimg.height/down, iimg.type);
				downsample(oimg, iimg, down);
				oimg.write(outfile.to_string());
				bye(pad, true);
				return 0;
			}
		} while(false);
		bye(pad, false);
		return 0;
	}
}
/** @} */
