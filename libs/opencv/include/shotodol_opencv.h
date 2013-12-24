#ifndef SHOTODOL_OPENCV_H
#define SHOTODOL_OPENCV_H

#include "opencv2/imgproc/imgproc_c.h"

#define shotodol_opencv_array_image_create(x, width, height, dptr) ({ \
	(x)->rows = height; \
	(x)->cols = width; \
	(x)->data.ptr = dptr; \
;})

#define shotodol_opencv_edge_detect_canny(x,y,p1,p2,ap) ({cvCanny(x,y,p1,p2,ap);})


#endif // SHOTODOL_OPENCV_H
