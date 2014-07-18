using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup strtrans
 * @{
 */
public class onubodh.TransKeyWord : Searchable {
	public uchar index;
	public extring word;
	public void rehash() {
		aroop_hash h = word.getStringHash();
		//print("+ hash:%ld\n", h);
		set_hash(h);
	}
}
/** @} */
