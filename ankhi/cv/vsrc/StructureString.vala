using aroop;
using shotodol;
using onubodh;

public class onubodh.StructureString : Replicable {
	ImageString img;
	public StructureString(netpbmg*src) {
		img = new ImageString(src);
	}

	public int compile() {
		img.compile4();
		return 0;
	}

	/*public void dump(OutputStream os) {
		int i = 0;
		etxt dlg = etxt.stack(16);
		for(i = 0;i<length;i++) {
			dlg.printf("%d,", buf[i]);
			os.write(&dlg);
		}
	}*/
}
