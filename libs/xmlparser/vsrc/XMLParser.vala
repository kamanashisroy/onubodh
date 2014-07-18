using aroop;
using onubodh;

/**
 * \ingroup lib
 * \defgroup xmlparser XML Parser
 * \addtogroup xmlparser
 * @{
 */
public struct onubodh.XMLIterator {
	public WordMap*m;
	public extring kernel;
	public extring nextTag;
	public extring content;
	public int basePos;
	public int pos;
	public int shift;
	public int attrShift;
	public int attrEnd;
	public bool nextIsText;
	protected XMLIterator*inner;
	public XMLIterator(WordMap*aM) {
		kernel = extring();
		nextTag = extring();
		content = extring();
		pos = 0;
		shift = 0;
		basePos = 0;
		nextIsText = false;
		m = aM;
		attrShift = 0;
		inner = null;
	}
	public XMLIterator.copy_shallow(XMLIterator*other) {
		kernel = extring.copy_shallow(&other.kernel);
		nextTag = extring.copy_shallow(&other.nextTag);
		content = extring.copy_shallow(&other.content);
		pos = other.pos;
		nextIsText = other.nextIsText;
		basePos = other.basePos;
		shift = other.shift;
		m = other.m;
		attrShift = other.attrShift;
		inner = null;
	}
	public XMLIterator.for_kernel(extring*aExtract) {
		kernel = extring.copy_shallow(aExtract);
		nextTag = extring();
		content = extring();
		pos = 0;
		nextIsText = false;
		basePos = 0;
		shift = 0;
		attrShift = 0;
		inner = null;
	}
	public bool nextAttr(extring*attrKey, extring*attrVal) {
		if((attrEnd - attrShift) < 3/* || attrs.char_at(attrShift+1) != ATTRIBUTE_ASSIGN*/) {
			return false;
		}
		m.getSourceReferenceAs(basePos + shift + attrShift, basePos + shift + attrShift + 1, attrKey);
		m.getSourceReferenceAs(basePos + shift + attrShift + 2, basePos + shift + attrShift + 3, attrVal);
		attrShift+=3;
		return true;
	}
#if XMLPARSER_DEBUG
	public void dump(extring*prefix) {
		extring talk = extring.stack(512);
		prefix.zero_terminate();
		talk.printf("%s [basePos:%d,shift:%d,pos:%d,clen:%d,klen:%d]\n", prefix.to_string(), basePos, shift, pos, content.length(), kernel.length());
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 8, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
	}
#endif
}

public delegate void onubodh.XMLTraverser(XMLIterator*it);

public errordomain onubodh.XMLParserError {
	INVALID_TAG,
}

public class onubodh.XMLParser : onubodh.WordTransform {
	int ANGLE_BRACE_OPEN;
	int ANGLE_BRACE_CLOSE;
	int INDICATE_TAG_END;
	int ATTRIBUTE_ASSIGN;
	public XMLParser() {
		extring start = extring.set_static_string("<");
		ANGLE_BRACE_OPEN = addKeyWord(&start);
		extring end = extring.set_static_string(">");
		ANGLE_BRACE_CLOSE = addKeyWord(&end);
		extring indicateEnd = extring.set_static_string("/");
		INDICATE_TAG_END = addKeyWord(&indicateEnd);
		extring attrAssign = extring.set_static_string("=");
		ATTRIBUTE_ASSIGN = addKeyWord(&attrAssign);
	}
	
	public int nextElem(XMLIterator*it) throws XMLParserError.INVALID_TAG {
		core.assert(it != null && nextElem != null);
		it.content.destroy();
		it.nextTag.destroy();
		it.attrShift = 0;
		it.attrEnd = 0;
		//it.shift = 0;
#if XMLPARSER_DEBUG
		extring talk = extring.stack(128);
		talk.printf("nextElem() ");
		it.dump(&talk);
#endif
		if(it.kernel.is_empty() || (it.pos >= it.kernel.length())) {
			return 0;
		}
		if(it.kernel.char_at(it.pos) == ANGLE_BRACE_OPEN) {
			return nextTagElem(it);
		} else {
			return nextTextElem(it);
		}
	}

	protected int nextTextElem(XMLIterator*it) {
		int i;
		int len = it.kernel.length();
		int textEnd = len;
		it.nextTag.destroy();
		// TODO we should use sandbox.indexof(char) function.
		for (i = it.pos;i<len; i++) {
			if(it.kernel.char_at(i) == ANGLE_BRACE_OPEN) {
				textEnd = i;
				break;
			}
		}
		it.content = extring.copy_shallow(&it.kernel);
		if(textEnd != len)it.content.trim_to_length(it.pos+textEnd);
		it.content.shift(it.pos);
		it.shift = it.pos;
		it.pos+=textEnd;
		it.nextIsText = true;
		return 0;
	}

	protected int nextTagElem(XMLIterator*it) throws XMLParserError.INVALID_TAG {
		int i;
		int len = it.kernel.length();
		int angleBraceStart = -1;
		it.nextTag.destroy();
		it.nextIsText = false;
		int depth = 0;
		bool attrGrabbed = false;
		it.attrShift = 0;
		it.attrEnd = 0;
		// TODO we should use sandbox.indexof(char) function.
		core.assert(it.kernel.char_at(it.pos) == ANGLE_BRACE_OPEN);
		angleBraceStart = it.pos;
#if XMLPARSER_DEBUG
		extring talkative = extring.stack(100);
#endif
		for (i = it.pos;i<len; i++) {
			if(it.kernel.char_at(i) == ANGLE_BRACE_OPEN) {
				depth++;
				if((i+1) < len && it.kernel.char_at(i+1) == INDICATE_TAG_END) {
					depth-=2;
				}
				if(i+1 < len) {
					if(it.nextTag.is_empty()) {
						extring currentTag = extring();
						it.m.getNonKeyWordAs(it.basePos + i+1, &currentTag);
						it.nextTag = extring.copy_shallow(&currentTag);
						//print("start tag:%s:depth:%d\n", currentTag.to_string(), depth);
#if XMLPARSER_DEBUG
						talkative.printf("< - ");talkative.concat(&currentTag);it.dump(&talkative);
#endif
					}
				}
			} else if(it.kernel.char_at(i) == ANGLE_BRACE_CLOSE) {
				if(!attrGrabbed) {
					core.assert(depth == 1);
					attrGrabbed = true;
					it.attrShift = 2;
					it.attrEnd = i - angleBraceStart;
				}
				if(i != 0 && it.kernel.char_at(i-1) == INDICATE_TAG_END) {
					depth--;
				}
				if(depth == 0) {
					extring currentTag = extring();
					it.m.getNonKeyWordAs(it.basePos + i-1, &currentTag);
					if(!currentTag.equals(&it.nextTag)) {
						core.assert(4==8);
						throw new XMLParserError.INVALID_TAG("Invalid tag end");
					}
#if XMLPARSER_DEBUG
					talkative.printf("> - ");talkative.concat(&currentTag);it.dump(&talkative);
#endif
					it.content = extring();
					it.content = extring.copy_shallow(&it.kernel);
					it.content.trim_to_length(i+1);
					it.content.shift(angleBraceStart);
					it.shift = angleBraceStart;
					it.pos = i+1;
#if XMLPARSER_DEBUG
					talkative.printf("> - ");talkative.concat(&currentTag);it.dump(&talkative);
#endif
					//it.pos += i;
					return 0;
				}
			}
		}
#if XMLPARSER_DEBUG
		talkative.printf("Unreachable code ");it.dump(&talkative);
		//core.assert(0==1); // it should not be reached for valid xml
#endif
		it.pos = len;
		return 0;
	}

	public int peelCapsule(XMLIterator*dst, XMLIterator*src) {
		// sanity check
		int len = src.content.length();
		if(src.content.char_at(0) != ANGLE_BRACE_OPEN || src.content.char_at(len-1) != ANGLE_BRACE_CLOSE) {
			//print("Could not peel capsule\n");
			return -1;
		}
		int i;
		int nextCapsule = 0;
		for (i = 0;i<len; i++) {
			if(src.content.char_at(i) == ANGLE_BRACE_CLOSE) {
				nextCapsule = i;
				break;
			}
		}
		if(nextCapsule == len - 1) { // There is no internal capsule
			//print("Could not peel capsule2\n");
			return -1;
		}
		int nextCapsuleEnd = 0;
		for (i = len-1;i >= 0; i--) {
			if(src.content.char_at(i) == ANGLE_BRACE_OPEN) {
				nextCapsuleEnd = i;
				break;
			}
		}
		if(nextCapsuleEnd <= nextCapsule) { // There is no internal capsule
			//print("Could not peel capsule3\n");
			return -1;
		}
		dst.kernel = extring.copy_shallow(&src.content);
		dst.kernel.trim_to_length(nextCapsuleEnd);
		dst.kernel.shift(nextCapsule+1);
		core.assert(dst.kernel.char_at(0) != ANGLE_BRACE_CLOSE);
		dst.basePos = src.basePos + src.shift + nextCapsule + 1;
		dst.shift = 0;
		dst.pos = 0;
		src.inner = dst;
		//print("Peeled\n");
		return 0;
	}

	public void traverseDeep(XMLIterator*xit, int depth, XMLTraverser cb) throws XMLParserError.INVALID_TAG {
#if XMLPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("~)/[~~Peeling %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
		XMLIterator pl = XMLIterator(xit.m);
		if(peelCapsule(&pl, xit) == 0) {
			if(!pl.kernel.is_empty())traversePreorder2(&pl, depth, cb);
			xit.inner = null;
			//xit.pos--;
#if XMLPARSER_DEBUG
			talkative.printf("--Next after %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
		}
	}

	public void traversePreorder2(XMLIterator*xit, int depth, XMLTraverser cb) throws XMLParserError.INVALID_TAG {
		if(xit.inner != null) {
			traversePreorder2(xit.inner, depth, cb);
			xit.inner = null;
			return;
		}
#if XMLPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("--> --> -->Going deep");xit.dump(&talkative);
#endif
		if(xit.content.is_empty() && xit.nextTag.is_empty()) {
#if XMLPARSER_DEBUG
			talkative.printf("--Next");xit.dump(&talkative);
#endif
			nextElem(xit);
		} else {
			if(!xit.nextIsText) {
				traverseDeep(xit, depth, cb);
				return;
			}
		}
		do {
			if(xit.content.is_empty() && xit.nextTag.is_empty()) {
#if XMLPARSER_DEBUG
				talkative.printf("||Dead end");xit.dump(&talkative);
#endif
				return;
			}
#if XMLPARSER_DEBUG
			talkative.printf("((++cb");xit.dump(&talkative);
#endif
			cb(xit);
#if XMLPARSER_DEBUG
			talkative.printf("((--cb");xit.dump(&talkative);
#endif
			if(xit.content.is_empty() && xit.nextTag.is_empty()) {
#if XMLPARSER_DEBUG
				talkative.printf("||Dead end");xit.dump(&talkative);
#endif
				return;
			}
#if XMLPARSER_DEBUG
			talkative.printf("--Next");xit.dump(&talkative);
#endif
			nextElem(xit);
		} while(true);
	}

	public void traversePreorder(WordMap*m, int depth, XMLTraverser cb, extring*content = null, int basePos = 0) throws XMLParserError.INVALID_TAG {
		XMLIterator xit = XMLIterator(m);
		if(content != null) {
			xit.kernel = extring.copy_shallow(content);
		} else {
			xit.kernel = extring.copy_shallow(&m.kernel);
		}
		xit.basePos = basePos;
		
#if XMLPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("++traversing %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
		do {
#if XMLPARSER_DEBUG
			talkative.printf("~~next after:");
			if(xit.nextIsText) {
				talkative.concat(&xit.content);
			} else {
				talkative.concat(&xit.nextTag);
			}
			xit.dump(&talkative);
#endif
			nextElem(&xit);
			if(xit.content.is_empty() && xit.nextTag.is_empty()) {
				break;
			}
			cb(&xit);

			if(!xit.nextIsText && (depth-1) != 0) {
#if XMLPARSER_DEBUG
				talkative.printf("getting inside tag :");
				talkative.concat(&xit.nextTag);
				xit.dump(&talkative);
#endif
				core.assert(xit.kernel.char_at(xit.pos) == ANGLE_BRACE_OPEN);
				//core.assert(xit.kernel.char_at(xit.pos+xit.content.length()-1) == ANGLE_BRACE_CLOSE);
				XMLIterator pl = XMLIterator(xit.m);
				if(peelCapsule(&pl, &xit) == 0) {
					//core.assert(pl.kernel.char_at(pl.pos) == ANGLE_BRACE_OPEN);
#if XMLPARSER_DEBUG
					talkative.printf("~)/[~~Peeling %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
					if(!pl.kernel.is_empty())traversePreorder(m, depth-1, cb, &pl.kernel, pl.basePos);
					xit.inner = null;
				}
				core.assert(xit.kernel.char_at(xit.pos) == ANGLE_BRACE_OPEN);
				//core.assert(xit.kernel.char_at(xit.pos+xit.content.length()-1) == ANGLE_BRACE_CLOSE);
			}
		} while(true);
#if XMLPARSER_DEBUG
		talkative.printf("--traversing");xit.dump(&talkative);
#endif
	}
}
/** @} */
