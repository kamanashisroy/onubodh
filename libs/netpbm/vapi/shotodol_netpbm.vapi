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

	[CCode (cname="struct netpbm_image", cheader_filename = "imageio.h")]
	public struct netpbmg {
		[CCode (cname="netpbm_init_img")]
		public netpbmg();
		[CCode (cname="netpbm_init_img_with_filename")]
		public netpbmg.for_file(string filename);
		[CCode (cname="netpbm_subimage")]
		public netpbmg.subimage(netpbmg*src, netpbm_rect*rect);
		[CCode (cname="netpbm_alloc_from_src")]
		public netpbmg.alloc_like(netpbmg*src);
		//[CCode (cname="netpbm_set_filename")]
		//public int set_filename(string filename);
		[CCode (cname="netpbm_open_and_read")]
		public int open(int*ecode);
		[CCode (cname="netpbm_write")]
		public int write(string?filename = null);
		[CCode (cname="netpbm_destroy")]
		public int close();
		[CCode (cname="width")]
		int width;
		[CCode (cname="height")]
		int height;
		[CCode (cname="netpbm_grayval")]
		public int getGrayVal(int x, int y, aroop_uword8*gval);
		[CCode (cname="netpbm_set_grayval")]
		public int setGrayVal(int x, int y, aroop_uword8 gval);
	}
}
