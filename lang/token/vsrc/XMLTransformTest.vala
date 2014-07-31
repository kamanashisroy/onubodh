using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup token
 * @{
 */

internal class onubodh.XMLTransformTest : UnitTest {
	bool success;
	public XMLTransformTest() {
		extring tname = extring.set_static_string("XMLTransformTest");
		base(&tname);
		success = true;
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
			talk.printf("Tag:[");
			talk.concat(&xit.nextTag);
			talk.concat_char(']');
			talk.concat_char('\t');talk.concat_char('\t');
			xit.dump(&talk);
#endif
			if(!xit.nextTag.equals_static_string("a") && !xit.nextTag.equals_static_string("b")) {
				Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.ERROR,0,0,"Searched for tag a/b, but not found\n");
				success = false;
			}
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
				if(xit.nextTag.equals_static_string("a") && !attrVal.equals_static_string("\"la la\"")) {
					Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.ERROR,0,0,"_a_ tag must have '\"la la\"' attribute value\n");
					success = false;
				}
				if(xit.nextTag.equals_static_string("b") && !attrVal.equals_static_string("hola")) {
					Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.ERROR,0,0,"_b_ tag must have 'hola' attribute value\n");
					success = false;
				}
			}
		}
	}


	public int testXtringHelper(extring*input) throws UnitTestError {
		XMLParser parser = new XMLParser();
		WordMap map = WordMap();
		map.kernel = extring.stack(128);
		map.source = extring.copy_deep(input);
		map.map = extring.stack(128);
#if XMLPARSER_DEBUG
		extring talk = extring.stack(512);
		talk.printf("Feeding keywords\n");
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 2, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
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
		parser = null;
		return 0;
	}
	public override int test() throws UnitTestError {
		extring teststr = extring.set_static_string("<a href=\"la la\">La la</a><b href=hola label=hola></b>");
		testXtringHelper(&teststr);
		// check value
		extring dlg = extring.stack(128);
		dlg.concat_string("XMLTransform Test");
		dlg.concat_char(':');
		if(success) {
			dlg.concat_string("Success");
		} else {
			dlg.concat_string("Fail");
		}
		dlg.concat_char('\n');
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,success?Watchdog.WatchdogSeverity.LOG:Watchdog.WatchdogSeverity.ERROR,0,0,&dlg);
		return 0;
	}
}
/** @} */
