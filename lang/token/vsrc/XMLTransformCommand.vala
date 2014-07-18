using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup token
 * @{
 */
public class onubodh.XMLTransformCommand : M100Command {
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public XMLTransformCommand() {
		extring prefix = extring.set_static_string("xtransform");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
	}

	void traverseCB(XMLIterator*xit) {
#if XMLPARSER_DEBUG
		extring talk = extring.stack(512);
		talk.printf("Node");
		if(xit.nextIsText) talk.concat_string("text"); else talk.concat(&xit.nextTag);
		xit.dump(&talk);
#endif
		if(xit.nextIsText) {
			extring tcontent = extring.stack(256);
			xit.m.getSourceReferenceAs(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
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
			extring tcontent = extring.stack(256);
			xit.m.getSourceReferenceAs(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
#if XMLPARSER_DEBUG
			talk.printf("Content\t\t-content:");
			talk.concat(&tcontent);
			talk.concat_char('\t');talk.concat_char('\t');
			xit.dump(&talk);
#endif
			//xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.attrs.length(), &tcontent);
			//print("Attrs\t\t- pos:%d,clen:%d,attr content:%s\n", xit.pos, xit.attrs.length(), tcontent.to_string());
			extring attrKey = extring();
			extring attrVal = extring();
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

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?infile = null;
		xtring?outfile = null;
		if((infile = vals[Options.INFILE]) == null || (outfile = vals[Options.OUTFILE]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
#if XMLPARSER_DEBUG
		extring talk = extring.stack(128);
#endif
		FileInputStream?is = null;
		try {
			print("Opening file\n");
			is = new FileInputStream.from_file(infile);
		} catch(IOStreamError.FileInputStreamError e) {
			print("Failed to open file:[%s]\n", infile.ecast().to_string());
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument, Cannot open input file.");
		}
#if XMLPARSER_DEBUG
		talk.printf("Build transform\n");
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		XMLParser parser = new XMLParser();
		WordMap map = WordMap();
		map.kernel = extring.stack(128);
		map.source = extring.stack(128);
		map.map = extring.stack(128);
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
				rxit.kernel = extring.copy_shallow(&map.kernel);
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
