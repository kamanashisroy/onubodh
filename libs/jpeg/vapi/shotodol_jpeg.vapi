using aroop;

/**
 * \ingroup lib
 * \defgroup jpeg JPEG encoder/decoder
 * \addtogroup jpeg
 * @{
 */
namespace onubodh {
	[CCode (cname="struct jpeg_image", cheader_filename = "jpegimage.h")]
	public struct jpegimg {
		[CCode (cname="jpeg_image_reset")]
		public int jpegimg();
		[CCode (cname="jpeg_image_from_netpbm")]
		public jpegimg.from_netpbm(netpbmg*img);
		//[CCode (cname="jpeg_image_for_netpbm")]
		//public jpegimg.for_netpbm(netpbmg*img);
		[CCode (cname="jpeg_image_write")]
		public int write(int quality, string?filename = null);
		[CCode (cname="jpeg_image_read")]
		public int read(string?filename = null);
		[CCode (cname="jpeg_image_error_code")]
		public unowned string getError();
	}
}
/** @} */
