using aroop;
using shotodol;

public class onubodh.ImageConvertCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public ImageConvertCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("convert");
		return &prfx;
	}

	bool is_jpeg_filename(etxt*fn) {
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

	bool is_ppm_filename(etxt*fn) {
		int len = fn.length();
		return (fn.char_at(len-1) == 'm')
			&& (fn.char_at(len-2) == 'p')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == '.');
	}

	bool is_pgm_filename(etxt*fn) {
		int len = fn.length();
		return (fn.char_at(len-1) == 'm')
			&& (fn.char_at(len-2) == 'g')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == '.');
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
			if(is_jpeg_filename(infile)) {
				netpbmg oimg = netpbmg.for_file(outfile.to_string());
				jpegimg iimg = jpegimg.from_netpbm(&oimg);
				iimg.read(infile.to_string());
				oimg.write();
				oimg.close();
				bye(pad, true);
				return 0;
			} else if(is_jpeg_filename(outfile)) {
				netpbmg img = netpbmg.for_file(infile.to_string());
				if(img.open(&ecode) != 0) {
					break;
				}
				jpegimg oimg = jpegimg.from_netpbm(&img);
				oimg.write(9, outfile.to_string());
				img.close();
				bye(pad, true);
				return 0;
			} else if(is_pgm_filename(outfile) && is_ppm_filename(infile)) {
				netpbmg iimg = netpbmg.for_file(infile.to_string());
				if(iimg.open(&ecode) != 0) {
					break;
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
				oimg.write(outfile.to_string());
				iimg.close();
				oimg.close();
				bye(pad, true);
				return 0;
			}
		} while(false);
		bye(pad, false);
		return 0;
	}
}
