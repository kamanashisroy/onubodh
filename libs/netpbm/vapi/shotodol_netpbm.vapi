using aroop;

namespace onubodh {
	[CCode (cname="struct netpbm_point", cheader_filename = "imageio.h")]
	public struct netpbm_point {
		[CCode (cname="x")]
		public int x;
		[CCode (cname="y")]
		public int y;
		[CCode (cname="netpbm_init_point")]
		public netpbm_point(int ax, int ay);
	}

	[CCode (cname="struct rgb_pixel", cheader_filename = "imageio.h")]
	public struct netpbm_rgb {
		[CCode (cname="r")]
		uchar r;
		[CCode (cname="g")]
		uchar g;
		[CCode (cname="b")]
		uchar b;
	}
	[CCode (cname="struct netpbm_rect", cheader_filename = "imageio.h")]
	public struct netpbm_rect {
		[CCode (cname="a")]
		public netpbm_point a;
		[CCode (cname="b")]
		public netpbm_point b;
		[CCode (cname="c")]
		public netpbm_point c;
		[CCode (cname="d")]
		public netpbm_point d;
	}

	[CCode (lower_case_cprefix = "NETPBM_IMAGE_TYPE_")]
	public enum netpbm_type {
		PGM = 5,
		PPM = 6,
		INVALID = 512,
	}

	[CCode (cname="struct netpbm_image", cheader_filename = "imageio.h", has_copy_function=false, copy_function="netpbm_cpy_or_destroy")]
	public struct netpbmg {
		[CCode (cname="netpbm_init_img")]
		public netpbmg();
		[CCode (cname="netpbm_init_img_with_filename")]
		public netpbmg.for_file(string filename);
		[CCode (cname="netpbm_subimage")]
		public netpbmg.subimage(netpbmg*src, netpbm_rect*rect);
		[CCode (cname="netpbm_alloc_from_src")]
		public netpbmg.alloc_like(netpbmg*src);
		[CCode (cname="netpbm_alloc_full")]
		public netpbmg.alloc_full(int width, int height, netpbm_type type);
		//[CCode (cname="netpbm_set_filename")]
		//public int set_filename(string filename);
		[CCode (cname="netpbm_open_and_read")]
		public int open(int*ecode);
		[CCode (cname="netpbm_write")]
		public int write(string?filename = null);
		[CCode (cname="netpbm_destroy")]
		public int close();
		[CCode (cname="maxval")]
		int maxval;
		[CCode (cname="width")]
		int width;
		[CCode (cname="height")]
		int height;
		[CCode (cname="type")]
		netpbm_type type;
		//[CCode (cname="pixels.color")]
		//netpbm_rgb color_pixels[];
		[CCode (cname="netpbm_getpixel")]
		public int getPixel(int x, int y, netpbm_rgb*color);
		[CCode (cname="netpbm_setpixel")]
		public int setPixel(int x, int y, netpbm_rgb*color);
		[CCode (cname="netpbm_grayval")]
		public int getGrayVal(int x, int y, aroop_uword8*gval);
		[CCode (cname="netpbm_set_grayval")]
		public int setGrayVal(int x, int y, aroop_uword8 gval);
	}
}
