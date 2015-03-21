using aroop;
using onubodh;

/**
 * \ingroup lib
 * \defgroup markdownparser Markdown Parser
 * \addtogroup markdownparser
 * @{
 */
public enum onubodh.MarkObject {
	PLAIN_OBJECT = 0,
	IMAGE_OBJECT,
	SQUARED_OBJECT,
	BRACED_OBJECT,
	STARRED_OBJECT,
	UNDERSCORED_OBJECT,
	DOUBLE_STARRED_OBJECT,
	DOUBLE_UNDERSCORED_OBJECT,
	LIST_OBJECT,
	HEADER_OBJECT,
	LINEBREAK_OBJECT,
}

public struct onubodh.MarkdownIterator {
	public WordMap*m;
	public extring kernel;
	public extring content;
	public int basePos;
	public int pos;
	public int shift;
	public MarkObject objectType;
	protected MarkdownIterator*inner;
	public MarkdownIterator(WordMap*aM) {
		kernel = extring();
		content = extring();
		pos = 0;
		shift = 0;
		basePos = 0;
		objectType = 0;
		m = aM;
		inner = null;
	}
	public MarkdownIterator.copy_shallow(MarkdownIterator*other) {
		kernel = extring.copy_shallow(&other.kernel);
		content = extring.copy_shallow(&other.content);
		pos = other.pos;
		objectType = other.objectType;
		basePos = other.basePos;
		shift = other.shift;
		m = other.m;
		inner = null;
	}
	public MarkdownIterator.for_kernel(extring*aExtract) {
		kernel = extring.copy_shallow(aExtract);
		content = extring();
		pos = 0;
		objectType = 0;
		basePos = 0;
		shift = 0;
		inner = null;
	}
#if false
	public bool nextAttr(extring*attrKey, extring*attrVal) {
		if((attrEnd - attrShift) < 3/* || attrs.char_at(attrShift+1) != ATTRIBUTE_ASSIGN*/) {
			return false;
		}
		m.getSourceReferenceAs(basePos + shift + attrShift, basePos + shift + attrShift + 1, attrKey);
		m.getSourceReferenceAs(basePos + shift + attrShift + 2, basePos + shift + attrShift + 3, attrVal);
		attrShift+=3;
		return true;
	}
#endif
#if MARKDOWNPARSER_DEBUG
	public void dump(extring*prefix) {
		extring objtypestr = extring();
		if(objectType == MarkObject.SQUARED_OBJECT) {
			objtypestr.rebuild_and_set_static_string("[Squared object]");
		} else if(objectType == MarkObject.BRACED_OBJECT) {
			objtypestr.rebuild_and_set_static_string("(Braced object)");
		} else if(objectType == MarkObject.UNDERSCORED_OBJECT) {
			objtypestr.rebuild_and_set_static_string("_Underscored object_");
		} else if(objectType == MarkObject.STARRED_OBJECT) {
			objtypestr.rebuild_and_set_static_string("*Starred object*");
		} else if(objectType == MarkObject.LIST_OBJECT) {
			objtypestr.rebuild_and_set_static_string("-List object-");
		} else if(objectType == MarkObject.HEADER_OBJECT) {
			objtypestr.rebuild_and_set_static_string("-Header-");
		} else {
			objtypestr.rebuild_and_set_static_string("..Plain object..");
		}

		extring talk = extring.stack(512);
		prefix.zero_terminate();
		talk.printf("%s %s [basePos:%d,shift:%d,pos:%d,clen:%d,klen:%d]\n", prefix.to_string(), objtypestr.to_string(), basePos, shift, pos, content.length(), kernel.length());
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 8, shotodol.Watchdog.Severity.DEBUG, 0, 0, &talk);
	}
#endif
}

public delegate void onubodh.MarkdownTraverser(MarkdownIterator*it);

public errordomain onubodh.MarkdownParserError {
	INVALID_TAG,
}

public class onubodh.MarkdownParser : onubodh.WordTransform {
	int SQUARE_BRACE_OPEN;
	int SQUARE_BRACE_CLOSE;
	int PARENTHESIS_OPEN;
	int PARENTHESIS_CLOSE;
	int DASH;
	int EQUAL;
	int UNDERSCORE;
	int ASTERSIK;
	int CRLF;
	int CARRIAGE_RETURN;
	extring wordSpacing;
	public MarkdownParser() {
		wordSpacing = extring.set_static_string(" ");
		base(&wordSpacing);
		extring entry = extring.set_static_string("[");
		SQUARE_BRACE_OPEN = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("]");
		SQUARE_BRACE_CLOSE = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("(");
		PARENTHESIS_OPEN = addKeyWord(&entry);
		entry.rebuild_and_set_static_string(")");
		PARENTHESIS_CLOSE = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("-");
		DASH = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("=");
		EQUAL = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("_");
		UNDERSCORE = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("*");
		ASTERSIK = addKeyWord(&entry);
		entry.rebuild_and_set_static_string("\n");
		CRLF = addKeyWord(&entry);
	}
	
	public int next(MarkdownIterator*it) throws MarkdownParserError.INVALID_TAG {
		core.assert(it != null);
		it.content.destroy();
		//it.shift = 0;
		print("next [basePos:%d,shift:%d,pos:%d,clen:%d,klen:%d]\n", it.basePos, it.shift, it.pos, it.content.length(), it.kernel.length());
#if MARKDOWNPARSER_DEBUG
		extring talk = extring.stack(128);
		talk.printf("next() ");
		it.dump(&talk);
#endif
		if(it.kernel.is_empty() || (it.pos >= it.kernel.length())) {
			return -1;
		}
		return nextMarkObject(it);
	}

	protected int nextPlainMarkObject(MarkdownIterator*it) {
		int i;
		int len = it.kernel.length();
		int textEnd = len;
		int key = DASH;
		int oldKey = DASH;
		int skiplen = 0;
#if MARKDOWNPARSER_DEBUG
		extring talk = extring.stack(512);
#endif
		// TODO we should use sandbox.indexof(char) function.
		for (i = it.pos;i<len; i++) {
			oldKey = key;
			key = it.kernel.char_at(i);
			if(key == SQUARE_BRACE_OPEN
			 || key == PARENTHESIS_OPEN
			 || key == UNDERSCORE
			 || key == ASTERSIK) {
				textEnd = i;
				break;
			} else if(key == DASH && (oldKey == CRLF)) { // Parsing header --------------------
				int headlineStart = i;
				int ch = 0;
				for (i++;i<len; i++) {
					if((ch = it.kernel.char_at(i)) != DASH) {
						break;
					}
				}
				int headlineEnd = i;
				if((headlineEnd - headlineStart) == 1 && ch != CRLF) {
					textEnd = headlineStart;
					break;
				}
				if((headlineEnd - headlineStart) == 1) 
					continue;
				if(ch != CRLF) { // skip the line
					i = headlineStart;
					continue;
				}
				textEnd = headlineStart;
				textEnd = textEnd < it.pos ? it.pos : textEnd;
				it.objectType = MarkObject.HEADER_OBJECT;
				skiplen = headlineEnd - textEnd;
				break;
			} else if(key == EQUAL && (oldKey == CRLF)) { // parsing header ======================
				int headlineStart = i;
				int ch = 0;
#if MARKDOWNPARSER_DEBUG
				talk.printf("header\n");
				it.dump(&talk);
#endif
				for (i++;i<len; i++) {
					if((ch = it.kernel.char_at(i)) != EQUAL) {
						break;
					}
				}
				int headlineEnd = i;
				if((headlineEnd - headlineStart == 1) || (ch != CRLF)) {
					i = headlineStart;
#if MARKDOWNPARSER_DEBUG
					talk.printf("no, not header\n");
					it.dump(&talk);
#endif
					continue;
				}
#if MARKDOWNPARSER_DEBUG
				talk.printf("yes, it is header\n");
				it.dump(&talk);
#endif
				textEnd = headlineStart;
				textEnd = textEnd < it.pos ? it.pos : textEnd;
				it.objectType = MarkObject.HEADER_OBJECT;
				skiplen = headlineEnd - textEnd;
				break;
			}
		}
		if(textEnd > it.pos) { // trim
			int delim = it.kernel.char_at(textEnd-1);
			if((delim == CRLF)) {
				textEnd--;
				skiplen++;
				if(textEnd > it.pos) {
					delim = it.kernel.char_at(textEnd-1);
					if((delim == CRLF) && textEnd > it.pos) {
						textEnd--;
						skiplen++;
					}
				}
			}
		}
		it.content = extring.copy_shallow(&it.kernel);
		if(textEnd != len)it.content.truncate(textEnd);
		it.content.shift(it.pos);
		it.shift = it.pos;
		it.pos = textEnd+skiplen;
#if MARKDOWNPARSER_DEBUG
		talk.printf("text: %d,%d ", textEnd, skiplen);
		it.dump(&talk);
#endif
		return 0;
	}

	protected int nextMarkObject(MarkdownIterator*it) throws MarkdownParserError.INVALID_TAG {
		int i;
		int len = it.kernel.length();
		int angleBraceStart = -1;
		angleBraceStart = it.pos;
#if MARKDOWNPARSER_DEBUG
		extring talkative = extring.stack(100);
#endif

		int key = it.kernel.char_at(it.pos);
		int delimiter = key;
		if(key == SQUARE_BRACE_OPEN) {
			it.objectType = MarkObject.SQUARED_OBJECT;
			delimiter = SQUARE_BRACE_CLOSE;
		} else if(key == PARENTHESIS_OPEN) {
			it.objectType = MarkObject.BRACED_OBJECT;
			delimiter = PARENTHESIS_CLOSE;
		} else if(key == UNDERSCORE) {
			it.objectType = MarkObject.UNDERSCORED_OBJECT;
		} else if(key == ASTERSIK) {
			it.objectType = MarkObject.STARRED_OBJECT;
		} else if(key == DASH) {
			it.objectType = MarkObject.LIST_OBJECT;
			delimiter = CRLF;
		} else {
			it.objectType = MarkObject.PLAIN_OBJECT;
			return nextPlainMarkObject(it);
		}
#if MARKDOWNPARSER_DEBUG
		it.dump(&talkative);
#endif
		int depth = 1;
		int doubledelimit = 0;
		for (i = it.pos+1;i<len; i++) {
			int current = it.kernel.char_at(i);
			if(current == key && (i-1) == it.pos) {
				depth++;
				doubledelimit = 1;
				if(it.objectType == MarkObject.UNDERSCORED_OBJECT)
					it.objectType = MarkObject.DOUBLE_UNDERSCORED_OBJECT;
				else if(it.objectType == MarkObject.STARRED_OBJECT)
					it.objectType = MarkObject.DOUBLE_STARRED_OBJECT;
			} if(current != delimiter && current == key) {
				depth++;
			} else if(current == delimiter) {
#if MARKDOWNPARSER_DEBUG
				talkative.printf("closed:%c, by %c\n", key, delimiter);it.dump(&talkative);
#endif
				depth--;
				if(depth == 0) {
					it.content = extring();
					it.content = extring.copy_shallow(&it.kernel);
					it.content.truncate(i-doubledelimit);
					it.content.shift(it.pos+1+doubledelimit);
					it.shift = it.pos+1+doubledelimit;
					
					it.pos = i+1;
					return 0;
				}
			}
		}
#if MARKDOWNPARSER_DEBUG
		talkative.printf("Unreachable code ");it.dump(&talkative);
		//core.assert(0==1); // it should not be reached for valid xml
#endif
		it.pos = len;
		return 0;
	}

	public int peelCapsule(MarkdownIterator*dst, MarkdownIterator*src) {
		dst.kernel = extring.copy_shallow(&src.content);
		dst.basePos = src.basePos + src.shift;
		dst.shift = 0;
		dst.pos = 0;
		src.inner = dst;
		//print("Peeled\n");
		return 0;
	}

	public void traverseDeep(MarkdownIterator*xit, int depth, MarkdownTraverser cb) throws MarkdownParserError.INVALID_TAG {
#if MARKDOWNPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("~)/[~~Peeling ");xit.dump(&talkative);
#endif
		MarkdownIterator pl = MarkdownIterator(xit.m);
		if(peelCapsule(&pl, xit) == 0) {
			if(!pl.kernel.is_empty())traversePreorder2(&pl, depth, cb);
			xit.inner = null;
			//xit.pos--;
#if MARKDOWNPARSER_DEBUG
			talkative.printf("--Next ");xit.dump(&talkative);
#endif
		}
	}

	public void traversePreorder(WordMap*m, int depth, MarkdownTraverser cb, extring*content = null, int basePos = 0) throws MarkdownParserError.INVALID_TAG {
		MarkdownIterator xit = MarkdownIterator(m);
		if(content != null) {
			xit.kernel = extring.copy_shallow(content);
		} else {
			xit.kernel = extring.copy_shallow(&m.kernel);
		}
		xit.basePos = basePos;
		
#if MARKDOWNPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("++traversing %s", xit.content.to_string());xit.dump(&talkative);
#endif
		do {
#if MARKDOWNPARSER_DEBUG
			talkative.printf("~~next");
			xit.dump(&talkative);
#endif
			if(next(&xit) == -1)
				break;
			//if(xit.content.is_empty()) {
			//	break;
			//}
			cb(&xit);

			if((xit.objectType != MarkObject.PLAIN_OBJECT && xit.objectType != MarkObject.HEADER_OBJECT) && (depth-1) != 0) {
#if MARKDOWNPARSER_DEBUG
				talkative.printf("getting inside");
				xit.dump(&talkative);
#endif
				//core.assert(xit.kernel.char_at(xit.pos) == ANGLE_BRACE_OPEN);
				//core.assert(xit.kernel.char_at(xit.pos+xit.content.length()-1) == ANGLE_BRACE_CLOSE);
				MarkdownIterator pl = MarkdownIterator(xit.m);
				if(peelCapsule(&pl, &xit) == 0) {
					//core.assert(pl.kernel.char_at(pl.pos) == ANGLE_BRACE_OPEN);
#if MARKDOWNPARSER_DEBUG
					talkative.printf("~)/[~~Peeling ");xit.dump(&talkative);
#endif
					if(!pl.kernel.is_empty())traversePreorder(m, depth-1, cb, &pl.kernel, pl.basePos);
					xit.inner = null;
				}
			}
		} while(true);
#if MARKDOWNPARSER_DEBUG
		talkative.printf("--traversing");xit.dump(&talkative);
#endif
	}

	public void traversePreorder2(MarkdownIterator*xit, int depth, MarkdownTraverser cb) throws MarkdownParserError.INVALID_TAG {
		if(xit.inner != null) {
			traversePreorder2(xit.inner, depth, cb);
			xit.inner = null;
			return;
		}
#if MARKDOWNPARSER_DEBUG
		extring talkative = extring.stack(100);
		talkative.printf("--> --> -->Going deep");xit.dump(&talkative);
#endif
		if(xit.content.is_empty()) {
#if MARKDOWNPARSER_DEBUG
			talkative.printf("--Next");xit.dump(&talkative);
#endif
			if(next(xit) == -1)
				return;
		} else {
			if(xit.objectType != MarkObject.PLAIN_OBJECT && xit.objectType != MarkObject.HEADER_OBJECT) {
				traverseDeep(xit, depth, cb);
				return;
			}
		}
		do {
			if(xit.content.is_empty()) {
#if MARKDOWNPARSER_DEBUG
				talkative.printf("||Dead end");xit.dump(&talkative);
#endif
				return;
			}
#if MARKDOWNPARSER_DEBUG
			talkative.printf("((++cb");xit.dump(&talkative);
#endif
			cb(xit);
#if MARKDOWNPARSER_DEBUG
			talkative.printf("((--cb");xit.dump(&talkative);
#endif
			if(xit.content.is_empty()) {
#if MARKDOWNPARSER_DEBUG
				talkative.printf("||Dead end");xit.dump(&talkative);
#endif
				return;
			}
#if MARKDOWNPARSER_DEBUG
			talkative.printf("--Next");xit.dump(&talkative);
#endif
			if(next(xit) == -1)
				return;
		} while(true);
	}


}
/** @} */
