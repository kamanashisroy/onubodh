using aroop;
using onubodh;

public struct onubodh.XMLIterator {
	public WordMap*m;
	public etxt extract;
	public etxt nextTag;
	public etxt content;
	public int basePos;
	public int pos;
	public int shift;
	public int attrShift;
	public int attrEnd;
	public bool nextIsText;
	protected XMLIterator*inner;
	public XMLIterator(WordMap*aM) {
		extract = etxt.EMPTY();
		nextTag = etxt.EMPTY();
		content = etxt.EMPTY();
		pos = 0;
		shift = 0;
		basePos = 0;
		nextIsText = false;
		m = aM;
		attrShift = 0;
		inner = null;
	}
	public XMLIterator.same_same(XMLIterator*other) {
		extract = etxt.same_same(&other.extract);
		nextTag = etxt.same_same(&other.nextTag);
		content = etxt.same_same(&other.content);
		pos = other.pos;
		nextIsText = other.nextIsText;
		basePos = other.basePos;
		shift = other.shift;
		m = other.m;
		attrShift = other.attrShift;
		inner = null;
	}
	public XMLIterator.for_extract(etxt*aExtract) {
		extract = etxt.same_same(aExtract);
		nextTag = etxt.EMPTY();
		content = etxt.EMPTY();
		pos = 0;
		nextIsText = false;
		basePos = 0;
		shift = 0;
		attrShift = 0;
		inner = null;
	}
	public bool nextAttr(etxt*attrKey, etxt*attrVal) {
		if((attrEnd - attrShift) < 3/* || attrs.char_at(attrShift+1) != ATTRIBUTE_ASSIGN*/) {
			return false;
		}
		m.getSourceReference(basePos + shift + attrShift, basePos + shift + attrShift + 1, attrKey);
		m.getSourceReference(basePos + shift + attrShift + 2, basePos + shift + attrShift + 3, attrVal);
		attrShift+=3;
		return true;
	}
#if XMLPARSER_DEBUG
	public void dump(etxt*prefix) {
		etxt talk = etxt.stack(128);
		talk.printf("%s [basePos:%d,shift:%d,pos:%d,clen:%d]\n", prefix.to_string(), basePos, shift, pos, content.length());
		shotodol.Watchdog.watchit(0, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
	}
#endif
}

public delegate void onubodh.XMLTraverser(XMLIterator*it);

public class onubodh.XMLParser : onubodh.WordTransform {
	int ANGLE_BRACE_OPEN;
	int ANGLE_BRACE_CLOSE;
	int INDICATE_TAG_END;
	int ATTRIBUTE_ASSIGN;
	public XMLParser() {
		etxt start = etxt.from_static("<");
		ANGLE_BRACE_OPEN = addKeyWord(&start);
		etxt end = etxt.from_static(">");
		ANGLE_BRACE_CLOSE = addKeyWord(&end);
		etxt indicateEnd = etxt.from_static("/");
		INDICATE_TAG_END = addKeyWord(&indicateEnd);
		etxt attrAssign = etxt.from_static("=");
		ATTRIBUTE_ASSIGN = addKeyWord(&attrAssign);
	}
	
	public int nextElem(XMLIterator*it) {
		core.assert(it != null && nextElem != null);
		it.content.destroy();
		it.nextTag.destroy();
		it.attrShift = 0;
		it.attrEnd = 0;
#if XMLPARSER_DEBUG
		etxt talk = etxt.stack(128);
		talk.printf("nextElem() len:%d,pos:%d\n", it.extract.length(), it.pos);
		shotodol.Watchdog.watchit(0, shotodol.Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		if(it.extract.is_empty() || (it.pos >= it.extract.length())) {
			return 0;
		}
		if(it.extract.char_at(it.pos) == ANGLE_BRACE_OPEN) {
			return nextTagElem(it);
		} else {
			return nextTextElem(it);
		}
	}

	public int nextTextElem(XMLIterator*it) {
		int i;
		int len = it.extract.length();
		int textEnd = len;
		it.nextTag.destroy();
		// TODO we should use sandbox.indexof(char) function.
		for (i = it.pos;i<len; i++) {
			if(it.extract.char_at(i) == ANGLE_BRACE_OPEN) {
				textEnd = i;
				break;
			}
		}
		it.content = etxt.same_same(&it.extract);
		if(textEnd != len)it.content.trim_to_length(it.pos+textEnd);
		it.content.shift(it.pos);
		it.shift = it.pos;
		it.pos+=textEnd;
		it.nextIsText = true;
		return 0;
	}

	public int nextTagElem(XMLIterator*it) {
		int i;
		int len = it.extract.length();
		int angleBraceStart = -1;
		it.nextTag.destroy();
		it.nextIsText = false;
		int depth = 0;
		bool attrGrabbed = false;
		it.attrShift = 0;
		it.attrEnd = 0;
		// TODO we should use sandbox.indexof(char) function.
		for (i = it.pos;i<len; i++) {
			if(it.extract.char_at(i) == ANGLE_BRACE_OPEN) {
				if(depth == 0) {
					angleBraceStart = i;
				}
				depth++;
				if((i+1) < len && it.extract.char_at(i+1) == INDICATE_TAG_END) {
					depth-=2;
				}
				if(i+1 < len) {
					if(it.nextTag.is_empty()) {
						etxt currentTag = etxt.EMPTY();
						it.m.getNonKeyWord(it.basePos + i+1, &currentTag);
						it.nextTag = etxt.same_same(&currentTag);
						//print("start tag:%s:depth:%d\n", currentTag.to_string(), depth);
					}
				}
			} else if(it.extract.char_at(i) == ANGLE_BRACE_CLOSE) {
#if false
				/* enable for debug */
				etxt currentTag = etxt.EMPTY();
				it.m.getNonKeyWord(it.basePos + i-1, &currentTag);
				print("end tag:%s:depth:%d\n", currentTag.to_string(), depth);
#endif
				if(!attrGrabbed) {
					core.assert(depth == 1);
					attrGrabbed = true;
					it.attrShift = angleBraceStart+2;
					it.attrEnd = i;
				}
				if(i != 0 && it.extract.char_at(i-1) == INDICATE_TAG_END) {
					depth--;
				}
				if(depth == 0) {
					it.content = etxt.EMPTY();
					it.content = etxt.same_same(&it.extract);
					it.content.trim_to_length(i+1);
					it.content.shift(angleBraceStart);
					it.shift = angleBraceStart;
					//it.pos += i+1;
					it.pos += i;
					return 0;
				}
			}
		}
		it.pos += len;
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
		dst.extract = etxt.same_same(&src.content);
		dst.extract.trim_to_length(nextCapsuleEnd);
		dst.extract.shift(nextCapsule+1);
		dst.basePos = src.basePos + src.shift + nextCapsule + 1;
		dst.shift = 0;
		dst.pos = 0;
		src.inner = dst;
		//print("Peeled\n");
		return 0;
	}

	public void traverseDeep(XMLIterator*xit, int depth, XMLTraverser cb) {
#if XMLPARSER_DEBUG
		etxt talkative = etxt.stack(100);
		talkative.printf("~)/[~~Peeling %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
		XMLIterator pl = XMLIterator(xit.m);
		if(peelCapsule(&pl, xit) == 0) {
			if(!pl.extract.is_empty())traversePreorder2(&pl, depth, cb);
			xit.inner = null;
#if XMLPARSER_DEBUG
			talkative.printf("--Next after %s", xit.nextTag.to_string());xit.dump(&talkative);
#endif
		}
	}

	public void traversePreorder2(XMLIterator*xit, int depth, XMLTraverser cb) {
		if(xit.inner != null) {
			traversePreorder2(xit.inner, depth, cb);
			xit.inner = null;
			return;
		}
#if XMLPARSER_DEBUG
		etxt talkative = etxt.stack(100);
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

	public void traversePreorder(WordMap*m, int depth, XMLTraverser cb, etxt*content = null, int basePos = 0) {
		XMLIterator xit = XMLIterator(m);
		if(content != null) {
			xit.extract = etxt.same_same(content);
		} else {
			xit.extract = etxt.same_same(&m.extract);
		}
		xit.basePos = basePos;
		
		do {
			//print("-- depth:%d\n", depth);
			nextElem(&xit);
			if(xit.content.is_empty() && xit.nextTag.is_empty()) {
				break;
			}
			cb(&xit);
			if(!xit.nextIsText && (depth-1) != 0) {
				XMLIterator pl = XMLIterator(m);
				peelCapsule(&pl, &xit);
				if(!pl.extract.is_empty())traversePreorder(m, depth-1, cb, &pl.extract, pl.basePos);
			}
		} while(true);
	}
}
