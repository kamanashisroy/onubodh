/*
	FAST-EDGE
	Copyright (c) 2009 Benjamin C. Haynor

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef _IMAGEIO
#define _IMAGEIO

struct netpbm_point {
	int x,y;
};
#define netpbm_init_point(p,xx,yy) ({(p)->x = xx;(p)->y = yy;})
struct netpbm_rect {
	struct netpbm_point a,b,c,d;
};
enum NETPBM_IMAGE_TYPE {
	NETPBM_IMAGE_TYPE_PGM = 5,
	NETPBM_IMAGE_TYPE_PPM = 6,
	NETPBM_IMAGE_TYPE_INVALID = 512,
};
struct netpbm_image {
	int width;
	int height;
	int maxval;
	char*filename;
	enum NETPBM_IMAGE_TYPE type;
	union {
		unsigned char * gray;
		struct rgb_pixel {
			unsigned char r,g,b;
		}*color;
	} pixels;
};

char*netpbm_error_code(int ecode);
int netpbm_open_and_read(struct netpbm_image*img, int*ecode);
int netpbm_write(struct netpbm_image*img, char*newfilename);
int netpbm_destroy(struct netpbm_image*img);
int netpbm_alloc_from_src(struct netpbm_image*dst, struct netpbm_image*src);
int netpbm_subimage(struct netpbm_image*img, struct netpbm_image*src, struct netpbm_rect*rect);

#define netpbm_init_img_with_filename(x,fn) ({(x)->pixels.color=NULL,(x)->pixels.gray=NULL,(x)->filename=fn;})
#define netpbm_init_img(x) netpbm_init_img_with_filename(x,NULL)
#define netpbm_grayval(img,x,y,v) ({*(v) = (img)->pixels.gray[(x) + (y) * (img)->width];0;})

#endif
