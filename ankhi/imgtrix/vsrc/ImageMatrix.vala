using aroop;
using shotodol;
using onubodh;

/**
 * \ingroup ankhi
 * \defgroup imgtrix Image Matrix
 */

/**
 * \addtogroup imgtrix
 * @{
 */
public delegate ImageMatrix? onubodh.FactoryCreatorForMatrix(netpbmg*src, int x, int y, uchar mat_size, aroop_uword8 minGrayVal, FactoryCreatorForMatrix fc);
public abstract class onubodh.ImageMatrix : /*Searchable*/Replicable {
	searchable_ext ext;
	protected netpbmg*img;
	public int top{public get;private set;}
	public int left{public get;private set;}
	protected uchar size;
	protected uchar shift;
	protected int flag;
	public int higherOrderX{public get;private set;}
	public int higherOrderY{public get;private set;}
	public int higherOrderXY{public get;private set;}
	enum MatrixFlags {
		HIGHLIGHT = 1,
		FILL = 1<<1,
	}
	public FactoryCreatorForMatrix fcreate;
	public ImageMatrix?submatrix;
	public void buildMain(netpbmg*src, int x, int y, uchar radiusShift, FactoryCreatorForMatrix fcm) {
		img = src;
		top = y;
		left = x;
		size = 1<<radiusShift;
		shift = radiusShift;
		flag = 0;
		higherOrderX = left>>shift;
		higherOrderY = top>>shift;
		int columns = (src.width >> shift);
		columns += ((src.width & (( 1<< shift)-1)) == 0?0:1);
		higherOrderXY = higherOrderX + higherOrderY*columns;
		fcreate = fcm; 
		submatrix = null;
	}
	public abstract void copyFrom(ImageMatrix other);
	public abstract int heal();
	public abstract int thin();
	public abstract int fill();
	public abstract int highlight();
	public abstract int compile();
	public abstract int drycompile();
	public abstract int getFeature(int feat);
	public abstract void dumpImage(netpbmg*out, aroop_uword8 gval);
	public bool testFlag(int myFlag) {
		return (flag & myFlag) != 0;
	}
	public void flagIt(int myFlag) {
		flag |= myFlag;
	}
	public void unflagIt(int myFlag) {
		flag &= ~myFlag;
	}
}
/** @} */
