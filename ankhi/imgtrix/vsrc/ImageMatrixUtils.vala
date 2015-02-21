using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageMatrixUtils : Replicable {
	public enum feature_ops {
		GT = 1,
		LT,
		EQ,
	}
	public static void parseFeatures(extring*input, int[] outputFeatureVal, int[] outputFeatureOps) {
		int i = 0;
		int findex = 0;
		for(findex = 0; findex < ImageMatrixString.MAX_FEATURES; findex++) {
			outputFeatureVal[findex] = 0;
			outputFeatureOps[findex] = 0;
		}

		findex = 0;
		for(i = 0; i < input.length() && findex < ImageMatrixString.MAX_FEATURES; i++) {
			uchar c = input.char_at(i);
			if(c == ',') {
				findex++;
			} else if(c == '>') {
				outputFeatureOps[findex] = feature_ops.GT;
			} else if(c == '<') {
				outputFeatureOps[findex] = feature_ops.LT;
			} else if(c == '=') {
				outputFeatureOps[findex] = feature_ops.EQ;
			} else if(c >= '0' && c <= '9') {
				outputFeatureVal[findex] *= 10;
				outputFeatureVal[findex] += (c-'0');
			}
		}
	}
}
