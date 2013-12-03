/* shotodol_imgtrix.vapi generated by lt-aroopc 0.14.0.133-a9f7-dirty, do not modify. */

namespace onubodh {
	[CCode (cheader_filename = "shotodol_imgtrix.h")]
	public class ImageManipulateAvg : onubodh.ImageMatrixManipulate {
		public ImageManipulateAvg (shotodol.netpbmg* src);
		public override onubodh.ImageMatrix createMatrix (shotodol.netpbmg* src, int x, int y, uchar mat_size);
	}
	[CCode (cheader_filename = "shotodol_imgtrix.h")]
	public abstract class ImageMatrix : aroop.Replicable {
		protected shotodol.netpbmg* img;
		protected int left;
		protected uchar size;
		protected int top;
		public ImageMatrix (shotodol.netpbmg* src, int x, int y, uchar mat_size);
		public abstract int compile ();
		public abstract int getVal ();
	}
	[CCode (cheader_filename = "shotodol_imgtrix.h")]
	public abstract class ImageMatrixManipulate : aroop.Replicable {
		public ImageMatrixManipulate (shotodol.netpbmg* src);
		public int compile4 ();
		public abstract onubodh.ImageMatrix createMatrix (shotodol.netpbmg* src, int x, int y, uchar mat_size);
		public int dump (shotodol.OutputStream os);
		public int mark (int val);
	}
	[CCode (cheader_filename = "shotodol_imgtrix.h")]
	public abstract class ImageMatrixString : onubodh.ImageMatrix {
		protected aroop.etxt points;
		public ImageMatrixString (shotodol.netpbmg* src, int x, int y, uchar mat_size);
		public override int compile ();
	}
	[CCode (cheader_filename = "shotodol_imgtrix.h")]
	public class ImageMatrixStringAvg : onubodh.ImageMatrixString {
		protected int avg;
		public ImageMatrixStringAvg (shotodol.netpbmg* src, int x, int y, uchar mat_size);
		public override int compile ();
		public override int getVal ();
	}
}