using aroop;

namespace shotodol_fastedge {
	[CCode (cname="char", cheader_filename = "shotodol_fastedge.h")]
	public class fastedge_filter {
		[CCode (cname="shotodol_fastedge_filter")]
		public static int filter(string infile, string outfile, int*ecode);
	}
}
