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
		Iterator<AroopPointer<ImageMatrixString>> it = Iterator<AroopPointer<ImageMatrixString>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.getUnowned();
			if(y == mat.higherOrderY) {
				continue;
			}
			y = mat.higherOrderY;
			len += can.getUnowned().getFeature(ImageMatrixString.feat.LENGTH);
		}
		it.destroy();
		return len;
	}

	public virtual int getCracksInPixels() {
		int crk = 0;
		/*
		Iterator<AroopPointer<ImageMatrixString>> it = Iterator<AroopPointer<ImageMatrixString>>.EMPTY();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<ImageMatrixString> can = it.get();
			ImageMatrixString mat = can.getUnowned();
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
	
	public void getIterator(Iterator<AroopPointer<ImageMatrix>>*it, int if_set, int if_not_set) {
		strings.iterator_hacked(it, if_set, if_not_set, 0);
	}
	
	public abstract bool pruneMatrix(ImageMatrix mat);
	public virtual int compile() {
		core.assert("Unimplemented" == null);
		return 0;
	}
	
	public virtual int heal() {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			can.getUnowned().heal();
		}
		it.destroy();
		return 0;
	}

	public virtual int thin() {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			can.getUnowned().thin();
		}
		it.destroy();
		return 0;
	}

	public abstract bool overlaps(StringStructure other);
	
	public abstract bool neibor(StringStructure other);
	
	public abstract void merge(StringStructure other);

	public abstract void dumpFeatures(OutputStream os);
	
	public virtual void fill() {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			can.getUnowned().fill();
		}
		it.destroy();
	}

	public virtual void dumpImage(netpbmg*oimg, aroop_uword8 grayVal) {
		Iterator<AroopPointer<ImageMatrix>> it = Iterator<AroopPointer<ImageMatrix>>();
		strings.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		//print("String length:%d(matrices)\n", strings.count_unsafe());
		while(it.next()) {
			AroopPointer<ImageMatrix> can = it.get();
			ImageMatrix mat = can.getUnowned();
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
