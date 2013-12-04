using aroop;
using shotodol;
using onubodh;

public class onubodh.ImageManipulateLineString : ImageManipulateAvg {
	LineString? ls;
	public ImageManipulateLineString(netpbmg*src) {
		base(src);
	}
	public int parseLines() {
		// TODO parse lines
		ls = new LineString();
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ls.append(can.get());
		}
		return 0;
	}
	public void dumpString(OutputStream os) {
		if(ls != null) {
			ls.dump(os, mat_width, mat_height);
		}
	}
}
