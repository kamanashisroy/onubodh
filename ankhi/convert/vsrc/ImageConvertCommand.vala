using aroop;
using shotodol;

/**
 * \ingroup ankhi
 * \defgroup imgconvert Image Converter
 */

/**
 * \addtogroup imgconvert
 * @{
 */
public class onubodh.ImageConvertCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public ImageConvertCommand() {
		extring prefix = extring.set_static_string("convert");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file"); 
	}

	bool is_jpeg_filename(extring*fn) {
		int len = fn.length();
		return ((fn.char_at(len-1) == 'g')
			&& (fn.char_at(len-2) == 'e')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == 'j')
			&& (fn.char_at(len-5) == '.'))
			|| ((fn.char_at(len-1) == 'g')
			&& (fn.char_at(len-2) == 'p')
			&& (fn.char_at(len-3) == 'j')
			&& (fn.char_at(len-4) == '.'));
	}

	bool is_ppm_filename(extring*fn) {
		int len = fn.length();
		return (fn.char_at(len-1) == 'm')
			&& (fn.char_at(len-2) == 'p')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == '.');
	}

	bool is_pgm_filename(extring*fn) {
		int len = fn.length();
		return (fn.char_at(len-1) == 'm')
			&& (fn.char_at(len-2) == 'g')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == '.');
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
		if(is_jpeg_filename(infile)) {
			netpbmg oimg = netpbmg.for_file(outfile.ecast().to_string());
			jpegimg iimg = jpegimg.from_netpbm(&oimg);
			iimg.read(infile.ecast().to_string());
			oimg.write();
			oimg.close();
			return 0;
		} else if(is_jpeg_filename(outfile)) {
			netpbmg img = netpbmg.for_file(infile.ecast().to_string());
			if(img.open(&ecode) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
			}
			jpegimg oimg = jpegimg.from_netpbm(&img);
			oimg.write(9, outfile.ecast().to_string());
			img.close();
			return 0;
		} else if(is_pgm_filename(outfile) && is_ppm_filename(infile)) {
			netpbmg iimg = netpbmg.for_file(infile.ecast().to_string());
			if(iimg.open(&ecode) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
			}
			netpbmg oimg = netpbmg.alloc_full(iimg.width, iimg.height, netpbm_type.PGM);
			oimg.maxval = 255;
			int x,y;
			for(y = 0; y < oimg.height; y++) {
				for(x = 0; x < iimg.width; x++) {
					netpbm_rgb color = netpbm_rgb();
					iimg.getPixel(x, y, &color);
					aroop_uword8 gval = (color.r >> 4) + (color.g >> 4) + (color.b >> 4);
					oimg.setGrayVal(x, y, gval);
				}
			}
			oimg.write(outfile.ecast().to_string());
			iimg.close();
			oimg.close();
			return 0;
		}
		return 0;
	}
}
/** @} */
