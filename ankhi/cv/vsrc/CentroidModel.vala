using aroop;
using shotodol;

public class shotodol.CentroidModel : Replicable {
	etxt fn;
	netpbmg img;
	public CentroidModel(string filename) {
		fn = etxt.dup_string(filename);
		img = netpbmg.for_file(filename);
	}
	~CentroidModel() {
		fn.destroy();
		img.close();
	}
	public int prepare() {
		int ecode = 0;
		if(img.open(&ecode) != 0) {
			return -1;
		}
		return 0;
	}
	public int findEdges(int x, int y, StandardIO io) {
		// check if the position is inside the image boundary 
		if(x >= img.width || y >= img.height) {
			return -1;
		}
		netpbm_point right,left,top,bottom;
		right = netpbm_point(x,y);
		left = netpbm_point(x,y);
		top = netpbm_point(x,y);
		bottom = netpbm_point(x,y);
		bool allset = false;
		int z = 0;
		aroop_uword8 gval = 0;
		// go right of the point, 
		for(allset = false,z=x;z<=img.width;z++) {
			if(img.grayval(z,y,&gval) != 0) {
				break;
			}
			if(gval == 0) {
				continue;
			}
			// may be it is a point on the edge ..
			right = netpbm_point(z,y);
			allset = true;
			break;
		}
		if(!allset) {
			io.say_static("<Centroid Model>Nothing on right side\n");
			return -1;
		}
		for(allset = false,z=x;z>=0;z--) {
			if(img.grayval(z,y,&gval) != 0) {
				break;
			}
			if(gval == 0) {
				continue;
			}
			// may be it is a point on the edge ..
			left = netpbm_point(z,y);
			allset = true;
			break;
		}
		if(!allset) {
			io.say_static("<Centroid Model>Nothing on left side\n");
			return -1;
		}
		for(allset = false,z=y;z<=img.height;z++) {
			if(img.grayval(x,z,&gval) != 0) {
				break;
			}
			if(gval == 0) {
				continue;
			}
			// may be it is a point on the edge ..
			top = netpbm_point(x,z);
			allset = true;
			break;
		}
		if(!allset) {
			io.say_static("<Centroid Model>Nothing on top side\n");
			return -1;
		}
		for(allset = false,z=y;z>=0;z--) {
			if(img.grayval(x,z,&gval) != 0) {
				break;
			}
			if(gval == 0) {
				continue;
			}
			// may be it is a point on the edge ..
			bottom = netpbm_point(x,z);
			allset = true;
			break;
		}
		if(!allset) {
			io.say_static("<Centroid Model>Nothing on bottom side\n");
			return -1;
		}
		netpbm_rect res = netpbm_rect();
		res.a = top;
		res.b = left;
		res.c = right;
		res.d = bottom;
		netpbmg result = netpbmg.subimage(&img, &res);
		etxt subfn = etxt.stack(128);
		subfn.printf("%s_sub.pgm", fn.to_string());
		subfn.zero_terminate();
		result.write(subfn.to_string());
		result.close();
		return 0;
	}
}
