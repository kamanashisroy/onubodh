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
	public etxt kernel;
	public etxt source;
	public etxt map;
	internal int wordIndex;
	internal ArrayList<txt>nonTransKeyWords;
	public WordMap() {
		nonTransKeyWords = ArrayList<txt>();
		kernel = etxt.EMPTY();
		source = etxt.EMPTY();
		map = etxt.EMPTY();
		wordIndex = 0;
	}

	public int getNonKeyWord(int windex, etxt*wd) {
		*wd = etxt.same_same(nonTransKeyWords.get(windex));
		return 0;
	}
	
	public void getSourceReference(int from, int to, etxt*srcref) {
		int shift = 0;
		int len = 0;
		int i = 0;
		for(i=0; i<from;i++) {
			shift+=map.char_at(i);
		}
		for(i=from; i<to;i++) {
			len+=map.char_at(i);
		}
		*srcref = etxt.same_same(&source);
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
	etxt*keyWordArrayMap[32];
	etxt delim;
	int keyCount;
	bool stringLiteralAsWord;
	enum wordTypes {
		NON_KEY_WORD = 255,
		MAX_KEY_INDEX_VALUE = 32,
	}
	public WordTransform() {
		//memclean_raw();
		keyWords = SearchableFactory<TransKeyWord>.for_type();
		keyCount = 0;
		delim = etxt.EMPTY();
		delim.buffer(32);
		stringLiteralAsWord = true;
	}
	~WordTransform() {
		keyWords.destroy();
		delim.destroy();
	}

	public int addKeyWord(etxt*aKeyWord) throws WordTransformError {
		if(keyCount > wordTypes.MAX_KEY_INDEX_VALUE) {
			throw new WordTransformError.MAXIMUM_KEY_LIMIT_EXCEEDED("Maximum keyword limit exceeded");
		}
		TransKeyWord kw = keyWords.alloc_added_size((uint16)(aKeyWord.length()+1));
		kw.word.factory_build_by_memcopy_from_etxt_unsafe_no_length_check(aKeyWord);
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

	public int setTransKeyWordString(etxt*keys) throws WordTransformError {
		etxt inp = etxt.stack_from_etxt(keys);
		delim.buffer(128);
		while(true) {
			etxt next = etxt.EMPTY();
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

	public int getTransKeyWord(int windex, etxt*kw) {
		*kw = etxt.same_same(keyWordArrayMap[windex]);
		return 0;
	}

	uchar getCharValue(WordMap*m, etxt*token) {
		aroop_hash h = token.getStringHash();
		//print("hash:%ld\n", h);
		TransKeyWord?kw = keyWords.search(h, (x) => {/*print("Examining %s\n", ((TransKeyWord)x).word.to_string());*/return ((TransKeyWord)x).word.equals(token)?0:1;});
		if(kw != null) {
			//print("+ key : [%s]\n", kw.word.to_string());
			return kw.index;
		} else {
			txt uWord = new txt.memcopy_etxt(token);
			//print("+ w : [%s]\n", uWord.to_string());
			m.nonTransKeyWords.set(m.wordIndex, uWord);
		}
		return wordTypes.NON_KEY_WORD; 
	}
	
	public int transform(WordMap*m) {
		etxt inp = etxt.same_same(&m.source);
		etxt next = etxt.EMPTY();
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
