using aroop;
using shotodol;
using onubodh;

public class onubodh.StructureString : Replicable {
	ImageManipulateAvg img;
	public StructureString(netpbmg*src) {
		img = new ImageManipulateAvg(src);
	}

	public int compile() {
		img.compile4();
		img.mark(4);
		return 0;
	}

	public void dump(OutputStream os) {
		img.dump(os);
	}
}
