using aroop;
using shotodol;
using onubodh;

/**
 * \ingroup ankhi
 * \defgroup tangle Detects tangles in the structure
 */

/**
 * \addtogroup tangle
 * @{
 */
public struct onubodh.ZeroTangle {
	public int crack;
	public int adjacent;
	public int cosecsign;
	public int columns;
	public int shift;
	public ZeroTangle(int gColumns) {
		crack = 0;
		adjacent = 0;
		cosecsign = 0;
		shift = 0;
		columns = gColumns;
	}
	public ZeroTangle.byShift(int gShift) {
		crack = 0;
		adjacent = 0;
		cosecsign = 0;
		shift = gShift;
		columns = 1<<gShift;
	}
	public bool detect100(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % columns;
		bool left = ((cosecsign) <= 0 && mod == (columns-1));
		bool right = ((cosecsign) >= 0 && mod == 1);
		if(diff < (columns-1)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?1:-1;
		}
		int div = (diff/columns) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect102(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % columns;
		bool left = ((cosecsign) <= 0 && (mod == (columns-1) || mod == (columns-2)));
		bool right = ((cosecsign) >= 0 && (mod == 1 || mod == 2));
		if(diff < (columns-2)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?1:-1;
		}
		int div = (diff/columns) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect103(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % columns;
		int x = 5;
		bool left = ((cosecsign) <= 0 && (mod+x >= columns && mod != 0));
		bool right = ((cosecsign) >= 0 && (mod <= x && mod != 0));
		if(diff < (columns-x)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?1:-1;
		}
		int div = (diff/columns) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect150(uchar a, uchar b) {
		core.assert(columns == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (columns - 1); // alternative code for diff % size 
		if(diff >= (columns-1) 
			&& (mod == 1 || mod == 0 || mod == (columns-1)) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			int div = (diff >> shift); // alternative code for diff / size
			div--;
			crack+=div;
			return true;
		}
		return false;
	}
	public bool detect162(uchar a, uchar b) {
		core.assert(columns == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (columns - 1); // alternative code for diff % size 
		bool left = ((cosecsign) <= 0 && (mod == (columns-1) || mod == (columns-2)));
		bool right = ((cosecsign) >= 0 && (mod == 1 || mod == 2));
		if(diff < (columns-2)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?1:-1;
		}
		int div = (diff >> shift); // alternative code for diff / size
		div--;
		crack+=div;
		return true;
	}
	public bool detect163(uchar a, uchar b) {
		core.assert(columns == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (columns - 1); // alternative code for diff % size 
		int x = shift;
		bool left = ((cosecsign) <= 0 && (mod+x >= columns && mod != 0));
		bool right = ((cosecsign) >= 0 && (mod <= x && mod != 0));
		if(diff < (columns-x)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?1:-1;
		}
		int div = (diff >> shift); // alternative code for diff / size
		div--;
		crack+=div;
		return true;
	}
}
/** @} */
