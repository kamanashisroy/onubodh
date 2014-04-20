using aroop;

/**
 * \ingroup lib
 * \defgroup drymankmeans Dryman Kmeans
 * \addtogroup drymankmeans
 * @{
 */
namespace shotodol_dryman_kmeans {
	[CCode (cname="char", cheader_filename = "dryman_kmeans.h")]
	public class dryman_kmeans {
		[CCode (cname="shotodol_kmeans_cluster")]
		public static int cluster(string infile, string outfile, int kval, int*ecode);
	}
}
/** @} */
