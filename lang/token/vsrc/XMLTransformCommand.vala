using aroop;
using shotodol;
using onubodh;

public class onubodh.XMLTransformCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public XMLTransformCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("xtransform");
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
			FileInputStream?is = null;
			try {
				print("Opening file\n");
				is = new FileInputStream.from_file(infile);
			} catch(IOStreamError.FileInputStreamError e) {
				print("Failed to open file:[%s]\n", infile.to_string());
				break;
			}
			print("Building transform\n");
			WordTransform trans = new WordTransform();
			print("Allocating memory\n");
			etxt keyWords = etxt.from_static("< / >");
			etxt chunk = etxt.stack(512);
			etxt extract = etxt.stack(512);
			print("Feeding keywords\n");
			trans.setTransKeyWordString(&keyWords);
				try {
					do {
						if(is.read(&chunk) == 0) {
							break;
						} 
						trans.transform(&chunk, &extract);
						print("Output:%d\n", extract.length());
					} while(true);
				} catch(IOStreamError.InputStreamError e) {
				}
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}
