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
		prfx = etxt.from_static("jpegconvert");
		return &prfx;
	}

	bool is_jpeg_filename(etxt*fn) {
		int len = fn.length();
		return (fn.char_at(len-1) == 'g')
			&& (fn.char_at(len-2) == 'e')
			&& (fn.char_at(len-3) == 'p')
			&& (fn.char_at(len-4) == 'j')
			&& (fn.char_at(len-5) == '.');
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
				netpbmg img = netpbmg.for_file(outfile.to_string());
				jpegimg oimg = jpegimg.from_netpbm(&img);
				oimg.read(infile.to_string());
				img.write();
				img.close();
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
			}
		} while(false);
		bye(pad, false);
		return 0;
	}
}
