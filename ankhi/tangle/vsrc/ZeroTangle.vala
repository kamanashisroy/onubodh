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
	/** \brief Number of pixels missing in the target line  */
	public int crack;
	/** \brief Adjacent is the projection of the line to the x-axis  */
	public int adjacent;
	/** \brief Sign value of the cosec triganomatric function associated with the line  */
	public int cosecsign;
	/** \brief Number of pixels or number of matrices available horizontally */
	public int width;
	/** \brief This is a value to perform specific tasks, width = (1<<shift) */
	public int shift;
	public ZeroTangle(int gwidth) {
		crack = 0;
		adjacent = 0;
		cosecsign = 0;
		shift = 0;
		width = gwidth;
	}
	public ZeroTangle.forShift(int gShift) {
		crack = 0;
		adjacent = 0;
		cosecsign = 0;
		shift = gShift;
		width = 1<<gShift;
	}
	public bool detect100(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % width;
		bool left = ((cosecsign >= 0) && mod == (width-1));
		bool right = ((cosecsign <= 0) && mod == 1);
		if(diff < (width-1)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?-1:1;
		}
		int div = (diff/width) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect102(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % width;
		bool left = ((cosecsign >= 0) && (mod == (width-1) || mod == (width-2)));
		bool right = ((cosecsign <= 0) && (mod == 1 || mod == 2));
		if(diff < (width-2)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?-1:1;
		}
		int div = (diff/width) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect103(int a, int b) {
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff % width;
		int x = 5;
		bool left = ((cosecsign >= 0) && (mod+x >= width && mod != 0));
		bool right = ((cosecsign <= 0) && (mod <= x && mod != 0));
		if(diff < (width-x)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?-1:1;
		}
		int div = (diff/width) - 1;
		if(div > 0)crack+=div;
		return true;
	}
	public bool detect150(uchar a, uchar b) {
		core.assert(width == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (width - 1); // alternative code for diff % size 
		if(diff >= (width-1) 
			&& (mod == 1 || mod == 0 || mod == (width-1)) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			int div = (diff >> shift); // alternative code for diff / size
			div--;
			crack+=div;
			return true;
		}
		return false;
	}
	public bool detect162(uchar a, uchar b) {
		core.assert(width == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (width - 1); // alternative code for diff % size 
		bool left = ((cosecsign >= 0) && (mod == (width-1) || mod == (width-2)));
		bool right = ((cosecsign <= 0) && (mod == 1 || mod == 2));
		if(diff < (width-2)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?-1:1;
		}
		int div = (diff >> shift); // alternative code for diff / size
		div--;
		crack+=div;
		return true;
	}
	public bool detect163(uchar a, uchar b) {
		core.assert(width == (1<<shift));
		int diff = b - a; // cumulative distance of the points in the matrix
		int mod = diff & (width - 1); // alternative code for diff % size 
		int x = shift;
		bool left = ((cosecsign >= 0) && (mod+x >= width && mod != 0));
		bool right = ((cosecsign <= 0) && (mod <= x && mod != 0));
		if(diff < (width-x)
			|| !(left  || mod == 0 || right) /* allow one pixel shifted points as well as perfect linear pixels  */
			) {
			return false;
		}
		if(right || left) {
			adjacent = adjacent+1;
			if(cosecsign == 0)
				cosecsign = right?-1:1;
		}
		int div = (diff >> shift); // alternative code for diff / size
		div--;
		crack+=div;
		return true;
	}
}
/** @} */
