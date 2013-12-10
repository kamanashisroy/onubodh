using aroop;
using shotodol;
using onubodh;

public struct RGB8Pixel {
	public aroop_uword8 r;
	public aroop_uword8 g;
	public aroop_uword8 b;
}

public class onubodh.RawImage : Replicable {
	public enum RawImageType {
		PGM = 5,
		PPM = 6,
		INVALID = 512,
	}
	public int width{public get;private set;}
	public int height{public get;private set;}
	public RawImageType type{public get;private set;}
	mem rawData;
	public RawImage(int aWidth, int aHeight, RawImageType aType) {
		width = aWidth;
		height = aHeight;
		type = aType;
	}
	public RawImage.dup(RawImage aImg) {
		width = aImg.width;
		height = aImg.height;
		type = aImg.type;
	}
	public RawImage.from_stream(InputStream ins) throws IOStreamError.InputStreamError {
		// Fill me
	}
	public int write(OutputStream outs) throws IOStreamError.OutputStreamError {
		// TODO Fill me
		return 0;
	}
	int getGrayVal(int x, int y, aroop_uword8*gval) {
		// TODO Fill me
		return 0;
	}
	int setGrayVal(int x, int y, aroop_uword8 gval) {
		// TODO Fill me
		return 0;
	}
	int getPixel(int x, int y, RGB8Pixel*rgb) {
		// TODO Fill me
		return 0;
	}
	int setPixel(int x, int y, RGB8Pixel*rgb) {
		// TODO Fill me
		return 0;
	}
}
