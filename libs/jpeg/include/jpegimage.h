#ifndef _JPEGIMAGE
#define _JPEGIMAGE

#include "imageio.h"
#include "jpeglib.h"

enum jpeg_image_error_code {
	JPEG_IMAGE_NO_ERROR = 0,
	JPEG_IMAGE_ERROR_COULD_NOT_OPEN_FILE,
	JPEG_IMAGE_ERROR_INVALID_ARGUMENT,
};
struct jpeg_image {
	char*filename;
	enum jpeg_image_error_code ecode;
	union {
  	struct jpeg_compress_struct c;
  	struct jpeg_decompress_struct dc;
	} impl;
	struct netpbm_image*raw;
};

#define jpeg_image_init_img(x) aroop_memset2(x)
#define jpeg_image_from_netpbm(x,y) ({aroop_memclean_raw2(x);(x)->raw=y;})
int jpeg_image_write (struct jpeg_image*img, int quality, char * filename);
char*jpeg_image_error(struct jpeg_image*img);

#endif
