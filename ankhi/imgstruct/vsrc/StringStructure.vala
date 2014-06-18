using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup imgstruct
 * @{
 */
public abstract class onubodh.StringStructure : Replicable {
	searchable_ext ext;
	ArrayList<ImageMatrix> strings;
	public int cracks;
	public int adjacent;
	public StringStructure() {
		buildStringStructure();
	}
	public void buildStringStructure() {
		strings = ArrayList<ImageMatrix>();
		flag = 0;
	}
	
	~StringStructure() {
		strings.destroy();
	}
	
	public int getLengthInPixels() {
		int len = 0;
		int y = -1;
		Iterator<container<ImageMatrixString>> it = Iterator<container<ImageMatrixString>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.get();
			if(y == mat.higherOrderY) {
				continue;
			}
			y = mat.higherOrderY;
			len += can.get().getFeature(ImageMatrixString.feat.LENGTH);
		}
		it.destroy();
		return len;
	}

	public virtual int getCracksInPixels() {
		int crk = 0;
		/*
		Iterator<container<ImageMatrixString>> it = Iterator<container<ImageMatrixString>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.get();
			crk += mat.getCracks();
		}
		it.destroy();
		crk += cracks*mtsize;*/
		return crk;
	}
	
	public int getLength() {
		return strings.count_unsafe();
	}

	public virtual int appendMatrix(ImageMatrix x) {
		strings.set(x.higherOrderXY, x);
		return 0;
	}

	public virtual int removeMatrixAT(int higherOrderXY) {
		strings.set(higherOrderXY, null);
		return 0;
	}
	
	public virtual ImageMatrix getMatrixAt(int xy) {
		return strings.get(xy);
	}
	
	public void getIterator(Iterator<container<ImageMatrix>>*it, int if_set, int if_not_set) {
		strings.iterator_hacked(it, if_set, if_not_set, 0);
	}
	
	public abstract bool pruneMatrix(ImageMatrix mat);
	public virtual int compile() {
		core.assert("Unimplemented" == null);
		return 0;
	}
	
	public virtual int heal() {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			can.get().heal();
		}
		it.destroy();
		return 0;
	}

	public virtual int thin() {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			can.get().thin();
		}
		it.destroy();
		return 0;
	}

	public abstract bool overlaps(StringStructure other);
	
	public abstract bool neibor(StringStructure other);
	
	public abstract void merge(StringStructure other);

	public abstract void dumpFeatures(OutputStream os);
	
	public virtual void fill() {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			can.get().fill();
		}
		it.destroy();
	}

	public virtual void dumpImage(netpbmg*oimg, aroop_uword8 grayVal) {
		Iterator<container<ImageMatrix>> it = Iterator<container<ImageMatrix>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			container<ImageMatrix> can = it.get();
			ImageMatrix mat = can.get();
			mat.dumpImage(oimg, grayVal);
		}
		it.destroy();
	}
	
	int flag;
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
