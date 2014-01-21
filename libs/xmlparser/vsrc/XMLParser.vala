using aroop;
using onubodh;

public struct onubodh.XMLIterator {
	public etxt extract;
	public etxt nextTag;
	public etxt content;
	public int pos;
	public bool nextIsText;
	public XMLIterator() {
		extract = etxt.EMPTY();
		nextTag = etxt.EMPTY();
		content = etxt.EMPTY();
		pos = 0;
		nextIsText = false;
	}
	public XMLIterator.same_same(XMLIterator*other) {
		extract = etxt.same_same(&other.extract);
		nextTag = etxt.same_same(&other.nextTag);
		content = etxt.same_same(&other.content);
		pos = other.pos;
		nextIsText = other.nextIsText;
	}
	public XMLIterator.for_extract(etxt*aExtract) {
		extract = etxt.same_same(aExtract);
		nextTag = etxt.EMPTY();
		content = etxt.EMPTY();
		pos = 0;
		nextIsText = false;
	}
}

public class onubodh.XMLParser : onubodh.WordTransform {
	int ANGLE_BRACE_OPEN;
	int ANGLE_BRACE_CLOSE;
	int INDICATE_TAG_END;
	public XMLParser() {
		etxt start = etxt.from_static("<");
		ANGLE_BRACE_OPEN = addKeyWord(&start);
		etxt end = etxt.from_static(">");
		ANGLE_BRACE_CLOSE = addKeyWord(&end);
		etxt indicateEnd = etxt.from_static("/");
		INDICATE_TAG_END = addKeyWord(&indicateEnd);
	}
	
	public int nextElem(XMLIterator*it) {
		core.assert(it != null && nextElem != null);
		if(it.extract.is_empty()) {
			it.content = etxt.EMPTY();
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
		int len = it.extract.length() - it.pos;
		int textEnd = len;
		it.nextTag.destroy();
		// TODO we should use sandbox.indexof(char) function.
		for (i = 0;i<len; i++) {
			if(it.extract.char_at(it.pos+i) == ANGLE_BRACE_OPEN) {
				textEnd = i;
				it.content = etxt.same_same(&it.extract);
				if(textEnd != len)it.content.trim_to_length(it.pos+textEnd);
				it.content.shift(it.pos);
				it.pos++;
				it.nextIsText = true;
				return 0;
			}
		}
		return 0;
	}

	public int nextTagElem(XMLIterator*it) {
		int i;
		int len = it.extract.length();
		int angleBraceStart = -1;
		it.nextTag.destroy();
		it.nextIsText = false;
		int depth = 0;
		// TODO we should use sandbox.indexof(char) function.
		for (i = it.pos;i<len; i++) {
			if(it.extract.char_at(i) == ANGLE_BRACE_OPEN) {
				if(depth == 0) {
					angleBraceStart = i;
				}
				depth++;
				if(i+1 < len) {
					if(it.nextTag.is_empty()) {
						etxt currentTag = etxt.EMPTY();
						getNonKeyWord(i+1, &currentTag);
						it.nextTag = etxt.same_same(&currentTag);
						//print("tag:%s\n", currentTag.to_string());
					}
				}
			} else if(it.extract.char_at(i) == ANGLE_BRACE_CLOSE) {
				if(i != 0 && it.extract.char_at(i-1) == INDICATE_TAG_END) {
					depth-=2;
				}
				if(depth == 0) {
					it.content = etxt.EMPTY();
					it.content = etxt.same_same(&it.extract);
					it.content.trim_to_length(i);
					it.content.shift(angleBraceStart);
					return 0;
				}
			} else if(it.extract.char_at(i) == INDICATE_TAG_END) {
				if(i != 0 && it.extract.char_at(i-1) == ANGLE_BRACE_OPEN) {
					depth-=2;
				}
			}
		}
		return 0;
	}

	public void peelCapsule(XMLIterator*dst, XMLIterator*src) {
		// sanity check
		if(src.extract.char_at(0) != ANGLE_BRACE_OPEN || src.extract.char_at(src.extract.length()-1) != ANGLE_BRACE_CLOSE) {
			print("Could not peel capsule\n");
			return;
		}
		int i;
		int nextCapsule = 0;
		int len = src.extract.length();
		for (i = 0;i<len; i++) {
			if(src.extract.char_at(i) == ANGLE_BRACE_CLOSE) {
				nextCapsule = i;
				break;
			}
		}
		if(nextCapsule == 0 || nextCapsule == len - 1) { // There is no internal capsule
			print("Could not peel capsule2\n");
			return;
		}
		int nextCapsuleEnd = 0;
		for (i = len-1;i != 0; i--) {
			if(src.extract.char_at(i) == ANGLE_BRACE_OPEN) {
				nextCapsuleEnd = i;
				break;
			}
		}
		if(nextCapsuleEnd <= nextCapsule) { // There is no internal capsule
			print("Could not peel capsule3\n");
			return;
		}
		dst.extract = etxt.same_same(&src.extract);
		dst.extract.trim_to_length(nextCapsuleEnd-1);
		dst.extract.shift(nextCapsule+1);
		print("Peeled\n");
	}
}
