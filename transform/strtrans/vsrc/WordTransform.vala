using aroop;
using shotodol;
using onubodh;

error onubodh.WordTransformError {
	MAXIMUM_KEY_LIMIT_EXCEEDED,
}

public class onubodh.WordTransform : Replicable {
	txt?unkonwnWords;
	etxt keywords[128];
	int keycount;
	public WordTransform() {
		unknown_words = null;
	}
	~WordTransform() {
		unknown_words = null;
	}

	int setKeywords(etxt*keys) throws WordTransformError {
		etxt inp = etxt.stack_from_etxt(keys);
		etxt next = etxt.EMPTY();
		keycount = 0;
		while(true) {
			LineAlign.next_token(&inp, &next);
			if(next.empty()) {
				break;
			}
			keywords[keycount++] = etxt.dup_etxt(&next);
			if(keycount > 126) {
				throw new WordTransformError.MAXIMUM_KEY_LIMIT_EXCEEDED("key limit exceeded");
			}
		}
		// TODO create map
		return 0;
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
		}
	}
}
