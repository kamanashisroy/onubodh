using aroop;
using shotodol;
using onubodh;

public class onubodh.LineString : StructureString {
	public LineString() {
		base();
	}
	public override int append(ImageMatrix x) {
		// TODO select a line
		if(x.getVal() == 3) {
			base.append(x);
		}
		return 0;
	}
}
