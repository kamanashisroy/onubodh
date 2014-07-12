using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup token
 * @{
 */
public class onubodh.XMLTransformCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public XMLTransformCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("xtransform");
		return &prfx;
	}

	void traverseCB(XMLIterator*xit) {
#if XMLPARSER_DEBUG
		etxt talk = etxt.stack(512);
		talk.printf("Node");
		if(xit.nextIsText) talk.concat_string("text"); else talk.concat(&xit.nextTag);
		xit.dump(&talk);
#endif
		if(xit.nextIsText) {
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
#if XMLPARSER_DEBUG
			talk.printf("Text\t\t- content:");
			talk.concat(&tcontent);
			talk.concat_char('\t');talk.concat_char('\t');
			xit.dump(&talk);
#endif
			
		} else {
#if XMLPARSER_DEBUG
			talk.printf("Tag:");
			talk.concat(&xit.nextTag);
			talk.concat_char('\t');talk.concat_char('\t');
			xit.dump(&talk);
#endif
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
#if XMLPARSER_DEBUG
			talk.printf("Content\t\t-content:");
			talk.concat(&tcontent);
			talk.concat_char('\t');talk.concat_char('\t');
			xit.dump(&talk);
#endif
			//xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.attrs.length(), &tcontent);
			//print("Attrs\t\t- pos:%d,clen:%d,attr content:%s\n", xit.pos, xit.attrs.length(), tcontent.to_string());
			etxt attrKey = etxt.EMPTY();
			etxt attrVal = etxt.EMPTY();
			while(xit.nextAttr(&attrKey, &attrVal)) {
#if XMLPARSER_DEBUG
				talk.printf("key:val = ");
				talk.concat(&attrKey);
				talk.concat_char(':');
				talk.concat(&attrVal);
				talk.concat_char('\t');talk.concat_char('\t');
				xit.dump(&talk);
#endif
			}
		}
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = null;
		txt?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
#if XMLPARSER_DEBUG
		etxt talk = etxt.stack(128);
#endif
		FileInputStream?is = null;
		try {
			print("Opening file\n");
			is = new FileInputStream.from_file(infile);
		} catch(IOStreamError.FileInputStreamError e) {
			print("Failed to open file:[%s]\n", infile.to_string());
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
		}
#if XMLPARSER_DEBUG
		talk.printf("Build transform\n");
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		XMLParser parser = new XMLParser();
		WordMap map = WordMap();
		map.kernel = etxt.stack(128);
		map.source = etxt.stack(128);
		map.map = etxt.stack(128);
#if XMLPARSER_DEBUG
		talk.printf("Feeding keywords\n");
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		try {
			do {
				if(is.read(&map.source) == 0) {
					break;
				} 
				parser.transform(&map);
#if XMLPARSER_DEBUG
				talk.printf("Extract length:%d\n", map.kernel.length());
				shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
				parser.traversePreorder(&map, 100, traverseCB);
#if false
				XMLIterator rxit = XMLIterator(&map);
				rxit.kernel = etxt.same_same(&map.kernel);
				parser.traversePreorder2(&rxit, 100, traverseCB);
#endif
			} while(true);
		} catch(IOStreamError.InputStreamError e) {
			// do nothing
		}
		parser = null;
		return 0;
	}
}
/** @} */
