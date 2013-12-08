using aroop;
using shotodol;

public class onubodh.ImageDiffCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE1 = 1,
		INFILE2,
		OUTFILE,
	}
	public ImageDiffCommand() {
		base();
		etxt input1 = etxt.from_static("-i1");
		etxt input_help1 = etxt.from_static("First input file");
		etxt input2 = etxt.from_static("-i2");
		etxt input_help2 = etxt.from_static("Second input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file(The diff file)");
		addOption(&input1, M100Command.OptionType.TXT, Options.INFILE1, &input_help1);
		addOption(&input2, M100Command.OptionType.TXT, Options.INFILE2, &input_help2);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("imgdiff");
		return &prfx;
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

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE1, match_all)) == null) {
				break;
			}
			unowned txt infile1 = mod.get();
			if((mod = vals.search(Options.INFILE2, match_all)) == null) {
				break;
			}
			unowned txt infile2 = mod.get();
			if((mod = vals.search(Options.OUTFILE, match_all)) == null) {
				break;
			}
			unowned txt outfile = mod.get();
			netpbmg firstimg = netpbmg.for_file(infile1.to_string());
			if(firstimg.open(&ecode) != 0) {
				break;
			}
			netpbmg secondimg = netpbmg.for_file(infile2.to_string());
			if(secondimg.open(&ecode) != 0) {
				break;
			}
			// sanity check
			if(firstimg.width != secondimg.width || firstimg.height != secondimg.height || firstimg.type != secondimg.type) {
				break;
			}
			netpbmg oimg = netpbmg.alloc_like(&firstimg);
			diff(&oimg, &firstimg, &secondimg);
			oimg.write(outfile.to_string());
			//pngcoder.encode(outfile.to_string(), &oimg);
			oimg.close();
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}
