using aroop;
using shotodol;
using onubodh;

public errordomain onubodh.WordTransformError {
	MAXIMUM_KEY_LIMIT_EXCEEDED,
}


#if false
public class onubodh.WordMap : HashTable {
	hashable_ext ext;
	int index;
	etxt extract;
	etxt source;
}
#endif

public class onubodh.WordTransform : Replicable {
	ArrayList<txt>nonTransKeyWords;
	SearchableFactory<TransKeyWord> keyWords;
	etxt*keyWordArrayMap[32];
	etxt delim;
	int keyCount;
	int wordCount;
	enum wordTypes {
		NON_KEY_WORD,
	}
	public WordTransform() {
		//memclean_raw();
		nonTransKeyWords = ArrayList<txt>();
		keyWords = SearchableFactory<TransKeyWord>.for_type();
		keyCount = 0;
		wordCount = 0;
		delim = etxt.EMPTY();
	}
	~WordTransform() {
		nonTransKeyWords.destroy();
		keyWords.destroy();
		delim.destroy();
	}

	public int setTransKeyWordString(etxt*keys) throws WordTransformError {
		etxt inp = etxt.stack_from_etxt(keys);
		keyCount = 0;
		delim.buffer(128);
		while(true) {
			etxt next = etxt.EMPTY();
			print("Looling for token in [%s]\n", inp.to_string());
			LineAlign.next_token(&inp, &next);
			if(next.is_empty()) {
				break;
			}
			uint16 len = (uint16)next.length()+1;
			print("+ key,len : [%s,%d]\n", next.to_string(), len);
			TransKeyWord kw = keyWords.alloc_added_size(len); // TODO make sure that sizeof(htxt) is not the size of the pointer but the size of the aroop_hashable_txt structure.
			kw.word.factory_build_by_memcopy_from_etxt_unsafe_no_length_check(&next);
			kw.word.zero_terminate();
			print("+ Adding key,len : [%s,%d]\n", kw.word.to_string(), len);
			keyWordArrayMap[keyCount++] = &kw.word;
			print("+ Building key,len : [%s,%d]\n", kw.word.to_string(), len);
			kw.rehash();
			kw.index = (uchar)keyCount;
			print("+ Hashing key,len : [%s,%d]\n", kw.word.to_string(), len);
			kw.pin();
			if(kw.word.length() == 1) {
				delim.concat_char(kw.word.char_at(0));
				print("+  Delimiters : [%s]\n", delim.to_string());
			}
		}
		print("We are done with keys\n");
		// TODO create map
		return 0;
	}

	int getTransKeyWord(int ref, etxt*kw) {
		*kw = etxt.same_same(keyWordArrayMap[ref]);
		return 0;
	}
	
	uchar getCharValue(etxt*token) {
		aroop_hash h = token.get_hash();
		print("hash:%ld\n", h);
		TransKeyWord?kw = keyWords.search(h, (x) => {print("Examining %s\n", ((TransKeyWord)x).word.to_string());return ((TransKeyWord)x).word.equals(token)?0:1;});
		if(kw != null) {
			print("+ key : [%s]\n", kw.word.to_string());
			return kw.index;
		} else {
			txt uWord = new txt.memcopy_etxt(token);
			print("+ w : [%s]\n", uWord.to_string());
			nonTransKeyWords.set(wordCount++, uWord);
		}
		return wordTypes.NON_KEY_WORD; 
	}
	
	public int transform(etxt*src,etxt*trans) {
		etxt inp = etxt.stack_from_etxt(src);
		etxt next = etxt.EMPTY();
		while(true) {
			LineAlign.next_token_delimitered(&inp, &next, &delim);
			if(next.is_empty()) {
				break;
			}
			trans.concat_char(getCharValue(&next));
		}
		return 0;
	}
}


