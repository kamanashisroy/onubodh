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
			XMLParser parser = new XMLParser();
			print("Allocating memory\n");
			etxt chunk = etxt.stack(512);
			etxt extract = etxt.stack(512);
			print("Feeding keywords\n");
			try {
				do {
					if(is.read(&chunk) == 0) {
						break;
					} 
					parser.transform(&chunk, &extract);
					print("Extracted length:%d\n", extract.length());
					XMLIterator xit = XMLIterator.for_extract(&extract);
					parser.nextElem(&xit);
					print("tag:%s\n", xit.nextTag.to_string());
					XMLIterator inner = XMLIterator();
					parser.peelCapsule(&inner, &xit);
					parser.nextElem(&inner);
					print("inner text:%s\n", inner.content.to_string());
				} while(true);
			} catch(IOStreamError.InputStreamError e) {
				break;
			}
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}
