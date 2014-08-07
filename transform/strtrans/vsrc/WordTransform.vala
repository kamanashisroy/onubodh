using aroop;
using shotodol;
using onubodh;

/** \defgroup transform Transform */
/**
 * \ingroup transform
 * \defgroup strtrans String Transform
 */
/**
 * \addtogroup strtrans
 * @{
 */

public errordomain onubodh.WordTransformError {
	MAXIMUM_KEY_LIMIT_EXCEEDED,
}


public struct onubodh.WordMap {
	public extring kernel;
	public extring source;
	public extring map;
	internal int wordIndex;
	internal ArrayList<xtring>nonTransKeyWords;
	public WordMap() {
		nonTransKeyWords = ArrayList<xtring>();
		kernel = extring();
		source = extring();
		map = extring();
		wordIndex = 0;
	}

	public int getNonKeyWordAs(int windex, extring*wd) {
		wd.rebuild_and_copy_shallow(nonTransKeyWords.get(windex));
		return 0;
	}
	
	public void getSourceReferenceAs(int from, int to, extring*srcref) {
		int shift = 0;
		int len = 0;
		int i = 0;
		for(i=0; i<from;i++) {
			shift+=map.char_at(i);
		}
		for(i=from; i<to;i++) {
			len+=map.char_at(i);
		}
		srcref.rebuild_and_copy_shallow(&source);
		srcref.shift(shift);
		srcref.trim_to_length(len);
	}

	public void addChar(uchar c, int shift) {
		kernel.concat_char(c);
		map.concat_char((uchar)shift);
	}

	public void destroy() {
		source.destroy();
		map.destroy();
		kernel.destroy();
		nonTransKeyWords.destroy();
	}
}

public class onubodh.WordTransform : Replicable {
	SearchableFactory<TransKeyWord> keyWords;
	extring*keyWordArrayMap[64];
	extring delim;
	int keyCount;
	bool stringLiteralAsWord;
	enum wordTypes {
		NON_KEY_WORD = 255,
		MAX_KEY_INDEX_VALUE = 64,
	}
	public WordTransform() {
		//memclean_raw();
		keyWords = SearchableFactory<TransKeyWord>.for_type();
		keyCount = 0;
		delim = extring();
		delim.buffer(wordTypes.MAX_KEY_INDEX_VALUE);
		stringLiteralAsWord = true;
	}
	~WordTransform() {
		keyWords.destroy();
		delim.destroy();
	}

	public int addKeyWord(extring*aKeyWord) throws WordTransformError {
		if(keyCount > wordTypes.MAX_KEY_INDEX_VALUE) {
			throw new WordTransformError.MAXIMUM_KEY_LIMIT_EXCEEDED("Maximum keyword limit exceeded");
		}
		TransKeyWord kw = keyWords.alloc_added_size((uint16)(aKeyWord.length()+1));
		kw.word.factory_build_and_copy_on_tail_no_length_check(aKeyWord);
		kw.word.zero_terminate();
		//print("+ Adding key,len : [%s,%d]\n", kw.word.to_string(), kw.word.length());
		keyWordArrayMap[keyCount] = &kw.word;
		//print("+ Building key,len : [%s,%d]\n", kw.word.to_string(), kw.word.length());
		kw.rehash();
		kw.index = (uchar)keyCount;
		//print("+ Hashing key,len : [%s,%d]\n", kw.word.to_string(),  kw.word.length());
		kw.pin();
		if(kw.word.length() == 1) {
			delim.concat_char(kw.word.char_at(0));
			//print("+  Delimiters : [%s]\n", delim.to_string());
		}
		keyCount++;
		return kw.index;
	}

	public int setTransKeyWordString(extring*keys) throws WordTransformError {
		extring inp = extring.stack_copy_deep(keys);
		delim.buffer(128);
		while(true) {
			extring next = extring();
			//print("Looling for token in [%s]\n", inp.to_string());
			LineAlign.next_token(&inp, &next);
			if(next.is_empty()) {
				break;
			}
			uint16 len = (uint16)next.length()+1;
			//print("+ key,len : [%s,%d]\n", next.to_string(), len);
			addKeyWord(&next);
		}
		//print("We are done with keys\n");
		return 0;
	}

	public int getTransKeyWordAs(int windex, extring*kw) {
		kw.rebuild_and_copy_shallow(keyWordArrayMap[windex]);
		return 0;
	}

	uchar getCharValue(WordMap*m, extring*token) {
		aroop_hash h = token.getStringHash();
		//print("hash:%ld\n", h);
		TransKeyWord?kw = keyWords.search(h, (x) => {/*print("Examining %s\n", ((TransKeyWord)x).word.to_string());*/return ((TransKeyWord)x).word.equals(token)?0:1;});
		if(kw != null) {
			//print("+ key : [%s]\n", kw.word.to_string());
			return kw.index;
		} else {
			xtring uWord = new xtring.copy_on_demand(token);
			//print("+ w : [%s]\n", uWord.to_string());
			m.nonTransKeyWords.set(m.wordIndex, uWord);
		}
		return wordTypes.NON_KEY_WORD; 
	}
	
	public int transform(WordMap*m) {
		extring inp = extring.copy_shallow(&m.source);
		extring next = extring();
		while(true) {
			int shift = inp.length();
			if(stringLiteralAsWord) {
				LineAlign.next_token_delimitered_sliteral(&inp, &next, &delim);
			} else {
				LineAlign.next_token_delimitered(&inp, &next, &delim);
			}
			shift = shift - inp.length() ;
			if(next.is_empty()) {
				break;
			}
			m.addChar(getCharValue(m, &next), shift);
			m.wordIndex++;
		}
		return 0;
	}
	
}


/** @} */
