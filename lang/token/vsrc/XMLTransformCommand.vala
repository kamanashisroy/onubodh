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

	void traverseCB(XMLIterator*xit) {
		print(".. node :\n");
		if(xit.nextIsText) {
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
			print("Text\t\t- pos:%d,clen:%d,text content:%s\n", xit.pos, xit.content.length(), tcontent.to_string());
		} else {
			print("pos:%d,clen:%d,tag:%s\n", xit.pos, xit.content.length(), xit.nextTag.to_string());
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
			print("Content\t\t- pos:%d,clen:%d,content:%s\n", xit.pos, xit.content.length(), tcontent.to_string());
			//xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.attrs.length(), &tcontent);
			//print("Attrs\t\t- pos:%d,clen:%d,attr content:%s\n", xit.pos, xit.attrs.length(), tcontent.to_string());
			etxt attrKey = etxt.EMPTY();
			etxt attrVal = etxt.EMPTY();
			while(xit.nextAttr(&attrKey, &attrVal)) {
				print("key:[%s],val:[%s]\n", attrKey.to_string(), attrVal.to_string());
			}
		}
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
			WordMap map = WordMap();
			map.extract = etxt.stack(128);
			map.source = etxt.stack(128);
			map.map = etxt.stack(128);
			print("Feeding keywords\n");
			try {
				do {
					if(is.read(&map.source) == 0) {
						break;
					} 
					parser.transform(&map);
					print("Extracted length:%d\n", map.extract.length());
					parser.traversePreorder(&map, 100, traverseCB);
				} while(true);
			} catch(IOStreamError.InputStreamError e) {
				break;
			}
			parser = null;
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}
