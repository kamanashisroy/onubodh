using aroop;

/**
 * \ingroup lib
 * \defgroup opencv OpenCV
 * \addtogroup opencv
 * @{
 */
namespace shotodol_opencv {
	[CCode (cname="CvMat", cheader_filename = "shotodol_opencv.h")]
	public struct ArrayImage {
		[CCode (cname="shotodol_opencv_array_image_create")]
		public ArrayImage.from(int width, int height, mem input);
	}
	[CCode (cname="char", cheader_filename = "shotodol_opencv.h")]
	public class EdgeDetect {
		[CCode (cname="shotodol_opencv_edge_detect_canny")]
		public static void canny(ArrayImage*inImg, ArrayImage* outImg, double threshold1, double threshold2, int aperture = 3);
	}
}
/** @} */
