using aroop;
using shotodol;
using onubodh;

public errordomain onubodh.WordTransformError {
	MAXIMUM_KEY_LIMIT_EXCEEDED,
}

public class onubodh.WordTransform : Replicable {
	ArrayList<txt>unknownWords;
	SearchableFactory<txt> keyWords;
	txt keyWordArrayMap[240];
	int keyCount;
	enum wordTypes {
		NON_KEY_WORD,
	}
	public WordTransform() {
		unknown_words = ArrayList<txt>();
		keyWords = SearchableFactory<txt>.for_type();
		keyCount = 0;
	}
	~WordTransform() {
		unknown_words.destroy();
		keyWords.destroy();
	}

	int setKeywords(etxt*keys) throws WordTransformError {
		etxt inp = etxt.stack_from_etxt(keys);
		etxt next = etxt.EMPTY();
		keyCount = 0;
		while(true) {
			LineAlign.next_token(&inp, &next);
			if(next.empty()) {
				break;
			}
			txt kw = keyWords.alloc_full(sizeof(txt)+next.length()+1)
				.factory_build_by_memcopy_from_etxt_unsafe_no_length_check(&next);
			keyWordArrayMap[keyCount++] = kw;
			Hashable hkw = (Hashable)kw;
			hkw.set_hash(keyCount);
		}
		// TODO create map
		return 0;
	}
	
	int getCharValue(etxt*token) {
		aroop_hash h = token.get_hash();
		txt contains = kw.search(h, token);
		if(contains != null) {
			Hashable hkw = (Hashable)kw;
			int h = hkw.get_hash();
			return h;
		}
		return NON_KEY_WORD; 
	}
	
	int transform(etxt*src,etxt*trans) {
		unknown_words = new txt.given_length(src.length()*2);
		etxt inp = etxt.stack_from_etxt(src);
		etxt next = etxt.EMPTY();
		while(true) {
			LineAlign.next_token(&inp, &next);
			if(next.empty()) {
				break;
			}
			trans.concat_char(getCharValue(&next));
		}
	}
}
