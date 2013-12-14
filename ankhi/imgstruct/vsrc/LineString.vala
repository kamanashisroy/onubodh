using aroop;
using shotodol;
using onubodh;

public class onubodh.LineString : MatrixStringStructure4 {
	public LineString(netpbmg*src) {
		base(src);
	}
	public override ImageMatrix createMatrix(netpbmg*src, int x, int y, uchar mat_size) {
		return new ImageMatrixStringNearLinear(src, x, y, mat_size);
	}
	public int parseLines() {
		// TODO parse lines
#if false
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			strings.append(can.get());
		}
#endif
		return 0;
	}
	public void dumpString(OutputStream os) {
		//strings.dump(os, mat_width, mat_height);
	}
}
