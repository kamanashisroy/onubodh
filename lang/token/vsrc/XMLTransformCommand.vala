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
#if XMLPARSER_DEBUG
		etxt talk = etxt.stack(128);
		//talk.printf("Node:%s\n", xit.nextIsText?"text":xit.nextTag.to_string());
		talk.printf("Node\n");
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		if(xit.nextIsText) {
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
#if XMLPARSER_DEBUG
			talk.printf("Text\t\t- pos:%d,clen:%d,text content:", xit.pos, xit.content.length());
			talk.concat(&tcontent);
			shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
			
		} else {
#if XMLPARSER_DEBUG
			talk.printf("pos:%d,clen:%d,tag:", xit.pos, xit.content.length());
			talk.concat(&xit.nextTag);
			shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
#if XMLPARSER_DEBUG
			talk.printf("Content\t\t- pos:%d,clen:%d,content:", xit.pos, xit.content.length());
			talk.concat(&tcontent);
			shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
			//xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.attrs.length(), &tcontent);
			//print("Attrs\t\t- pos:%d,clen:%d,attr content:%s\n", xit.pos, xit.attrs.length(), tcontent.to_string());
			etxt attrKey = etxt.EMPTY();
			etxt attrVal = etxt.EMPTY();
			while(xit.nextAttr(&attrKey, &attrVal)) {
#if XMLPARSER_DEBUG
				talk.printf("key:[%s],val:[%s]\n", attrKey.to_string(), attrVal.to_string());
				shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
			}
		}
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
#if XMLPARSER_DEBUG
		etxt talk = etxt.stack(128);
#endif
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
					XMLIterator rxit = XMLIterator(&map);
					rxit.kernel = etxt.same_same(&map.kernel);
					parser.traversePreorder2(&rxit, 100, traverseCB);
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
/** @} */
