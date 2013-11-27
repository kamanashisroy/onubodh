// https://github.com/dryman/homework-image-clustering

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <memory.h>
#include "dryman_kmeans.h"

typedef struct {
  int r;
  int g;
  int b;
  int r_sum;
  int g_sum;
  int b_sum;
  unsigned int count;
} Cluster;


void kmean (unsigned char* imgHead, int steps, Cluster* clHead, int cl_num){
	unsigned char* img;
  for(img = imgHead; img != imgHead+steps*3; img+=3){
    int r = (int) img[0];
    int g = (int) img[1];
    int b = (int) img[2];
    int sum = INT32_MAX;
    Cluster* cl = NULL;
    Cluster* c = NULL;
    for (c = clHead; c!=clHead+cl_num; c++){
      int _sum = abs(c->r-r) + abs(c->g-g) + abs(c->b-b);
      if (_sum < sum) {
        sum = _sum;
        cl = c;
      }
    }
    cl->r_sum += r;
    cl->g_sum += g;
    cl->b_sum += b;
    cl->count ++;
  }
	Cluster* c;
  for (c = clHead; c != clHead+cl_num; c++){
    if (c->count !=0){
      c->r = c->r_sum/ c->count;
      c->g = c->g_sum/ c->count;
      c->b = c->b_sum/ c->count;
      c->r_sum = 0;
      c->g_sum = 0;
      c->b_sum = 0;
      c->count = 0;
    }
  }
}

void kmeanApply(unsigned char* dst, const unsigned char* src, int steps, Cluster* clHead, int cl_num){
	int i;
  for(i=0;i<steps*3;i++){
    unsigned char* img = (unsigned char*)(src+i);
    unsigned char* img_apply = (unsigned char*)(dst+i);
    int r = (int) img[0];
    int g = (int) img[1];
    int b = (int) img[2];
    int sum = INT32_MAX;
    Cluster* cl = NULL;
    Cluster* c = NULL;
    for (c = clHead; c!=clHead+cl_num; c++){
      int _sum = abs(c->r-r) + abs(c->g-g) + abs(c->b-b);
      if (_sum < sum) {
        sum = _sum;
        cl = c;
      }
    }
    img_apply[0]=(unsigned char)cl->r;
    img_apply[1]=(unsigned char)cl->g;
    img_apply[2]=(unsigned char)cl->b;
  }
}

void dumpCluster(Cluster* clHead, int cl_num){
#if 0
	Cluster* c;
  for (c = clHead; c!=clHead+cl_num; c++){
    printf("Cluster [%d]:\n",(int)(c-clHead));
    printf("r = %d\ng = %d\nb = %d\n",c->r,c->g,c->b);
  }
  printf("\n");
#endif
}

int initCluster(Cluster** cluster, int cl_num){
  if (cl_num == 0){
    cl_num = 5;
    *cluster = (Cluster*)malloc(sizeof(Cluster)*cl_num);
		Cluster* c;
    for (c = *cluster; c!=*cluster+cl_num; c++){
      c->r=0;
      c->g=0;
      c->b=0;
      c->r_sum=0;
      c->g_sum=0;
      c->b_sum=0;
      c->count=0;
    }
    (*cluster)[0].r=255;
    (*cluster)[1].r=255;
    (*cluster)[1].g=255;
    (*cluster)[2].r=100;
    (*cluster)[2].g=100;
    (*cluster)[2].b=100;
    (*cluster)[3].r=255;
    (*cluster)[3].g=255;
    (*cluster)[3].b=255;
    return cl_num;
  }
  else {
    *cluster = (Cluster*)malloc(sizeof(Cluster)*cl_num);
		Cluster*c;
    for (c = *cluster; c!=*cluster+cl_num; c++){
      c->r=rand() % 256;
      c->g=rand() % 256;
      c->b=rand() % 256;
      c->r_sum=0;
      c->g_sum=0;
      c->b_sum=0;
      c->count=0;
    }
    return cl_num;
  }
}


#if 0    

int main(int argc, char** argv){
  IplImage* img = cvLoadImage(argv[1],CV_LOAD_IMAGE_COLOR);
  IplImage* img_apply = cvCreateImage(cvSize(img->width,img->height),8,3);
  cvNamedWindow("cluster demo",1);
  unsigned char* imgData = (unsigned char*)img->imageData;
  unsigned char* img_apply_data = (unsigned char*)img_apply->imageData;

  Cluster* cluster=NULL;
  int cl_num = initCluster(&cluster,atoi(argv[2]));
  for (int i=0;i<30;i++){
    kmean(imgData,img->width*img->height,cluster, cl_num);
    dumpCluster(cluster,5);
    kmeanApply(img_apply_data,imgData,img->width*img->height,cluster,cl_num);
    cvShowImage("cluster demo",img_apply);
    cvWaitKey(100);
  }
  cvWaitKey(0);
  
  return 0;
}

#else
#include "imageio.h"

int shotodol_kmeans_cluster(char*infile, char*outfile, int kval, int*ecode) {
	struct netpbm_image img, img_out;
	netpbm_init_img(&img);
	netpbm_init_img(&img_out);
	int i;
	img.filename = infile;
	img_out.filename = outfile;
	if(outfile == NULL || infile == NULL) {
		*ecode = 526;
		return -1;
	}

	if(netpbm_open_and_read(&img, ecode) == -1) {
		return -1;
	}

	if(img.type != NETPBM_IMAGE_TYPE_PPM) {
		*ecode = 512;
		netpbm_destroy(&img);
		return -1;
	}
	
	if(netpbm_alloc_from_src(&img_out, &img)) {
		goto cleanup_memory;
	}
	//printf("*** performing kmeans cluster ***\n");
	Cluster* cluster=NULL;
	int cl_num = initCluster(&cluster, kval);
	int total = img.width*img.height;
	for (i=0;i<30;i++){
		kmean(img.pixels.color, total, cluster, cl_num);
		dumpCluster(cluster,5);
		kmeanApply(img_out.pixels.color, img.pixels.color, total,cluster,cl_num);
	}
	netpbm_write(&img_out, NULL);
cleanup_memory:
	netpbm_destroy(&img);
	netpbm_destroy(&img_out);
	return 0;
}

#endif
