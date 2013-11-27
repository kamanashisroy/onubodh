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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#include "imageio.h"

static int skipcomment(FILE *fp)
{
	int i;
	if((i = getc(fp)) == '#') {
		while((i = getc(fp)) != '\n' && i != EOF);
	}
	return(ungetc(i, fp));
}

static int read_netpbm_hdr(FILE *fp, struct netpbm_image*img, int*ecode) {
	char filetype[4];
	if(skipcomment(fp) == EOF || fscanf(fp, "%2s\n", filetype) != 1) {
		*ecode = 5;
		return -1;
	}
	if(!strcmp(filetype, "P6")) {
		img->type = NETPBM_IMAGE_TYPE_PPM;
	} else if(!strcmp(filetype, "P5")) {
		img->type = NETPBM_IMAGE_TYPE_PGM;
	} else {
		*ecode = 6;
		img->type = NETPBM_IMAGE_TYPE_INVALID;
		return -1;
	}
	if( skipcomment(fp) == EOF || fscanf(fp, "%d", &img->width) != 1 || skipcomment(fp) == EOF || fscanf(fp, "%d", &img->height) != 1 || skipcomment(fp) == EOF || fscanf(fp, "%d%*c", &img->maxval) != 1 || img->maxval > 255) {
		*ecode = 7;
		return(-1);
	} else { 
		return(0);
	}
}

static int read_pgm_data(FILE *fp, struct netpbm_image*img) {
	int i;
	int total = img->width * img->height;
	for (i = 0; i < total; i++) {
		*((img->pixels.gray)+i) = fgetc(fp);
	}
	return 0;
}

static int read_ppm_data(FILE *fp, struct netpbm_image*img) {
	int i;
	int total = img->width * img->height;
	for (i = 0; i < total; i++) {
		((img->pixels.color)+i)->r = fgetc(fp);
		((img->pixels.color)+i)->g = fgetc(fp);
		((img->pixels.color)+i)->b = fgetc(fp);
	}
	return 0;
}


int netpbm_alloc(struct netpbm_image*img) {
	img->pixels.color = NULL;
	img->pixels.gray = NULL;
	if(img->type == NETPBM_IMAGE_TYPE_PGM) {
		img->pixels.gray = malloc(img->width * img->height * sizeof(char));
		if(!img->pixels.gray) {
			return -1;
		}
	} else if(img->type == NETPBM_IMAGE_TYPE_PPM) {
		img->pixels.color = malloc(img->width * img->height * sizeof(struct rgb_pixel));
		if(!img->pixels.color) {
			return -1;
		}
	}
	return 0;
}

char*netpbm_error_code(int ecode) {
	switch (ecode) {
		case 3:
			return "can't open file!";
		case 5:
			return "unable to read file type!";
		case 6:
			return "cannot handle this file type!";
		case 7:
			return "error reading file header!";
		default:
			break;
	}
	return "no error";
}

int netpbm_open_and_read(struct netpbm_image*img, int*ecode) {
	FILE *fp;
	img->pixels.color = NULL;
	img->pixels.gray = NULL;
	if (!img->filename || (fp = fopen(img->filename, "r")) == NULL) {
		*ecode = 3;
		return -1;
	}
	if (read_netpbm_hdr(fp, img, ecode) == -1) {
		return -1;
	}
	if(netpbm_alloc(img)) {
		goto error_close_fp;
	}
	if(img->type == NETPBM_IMAGE_TYPE_PGM) {
		read_pgm_data(fp, img);
	} else if(img->type == NETPBM_IMAGE_TYPE_PPM) {
		read_ppm_data(fp, img);
	}
	close(fp);
	return 0;
error_close_fp:
	close(fp);
	return -1;
}

int netpbm_alloc_from_src(struct netpbm_image*dst, struct netpbm_image*src) {
	dst->width = src->width;
	dst->height = src->height;
	dst->maxval = src->maxval;
	dst->type = src->type;
	return netpbm_alloc(dst);
}

int netpbm_destroy(struct netpbm_image*img) {
	if(img->pixels.color) {
		free(img->pixels.color);
		img->pixels.color = NULL;
	}
	if(img->pixels.gray) {
		free(img->pixels.gray);
		img->pixels.gray = NULL;
	}
	return 0;
}

int netpbm_write(struct netpbm_image*img, char*newfilename) {
	FILE *fp_out;
	int i = 0;
	int total = img->width * img->height;
	if(!img->filename && !(img->filename = newfilename)) {
		printf("Error opening output file.");
		return -1;
	}
	if(img->type == NETPBM_IMAGE_TYPE_PGM) {
		// TODO add pgm suffix
	} else if(img->type == NETPBM_IMAGE_TYPE_PPM) {
		// TODO add pbm suffix
	} else {
		return -1;
	}
	
	if((fp_out =fopen(newfilename?newfilename:img->filename,"w"))== NULL) {
		printf("Error opening output file.");
		return -1;
	}
	fprintf(fp_out, "P%d\n#shotodol\n%d %d\n255\n", img->type, img->width, img->height);
	if(img->type == NETPBM_IMAGE_TYPE_PGM) {
		for(i = 0; i < total; i++) {
			fputc(img->pixels.gray[i], fp_out);
		}
	} else {
		for(i = 0; i < total; i++) {
			fputc(img->pixels.color[i].r, fp_out);
			fputc(img->pixels.color[i].g, fp_out);
			fputc(img->pixels.color[i].b, fp_out);
		}
	}
	fclose(fp_out);
	return 0;
}

int netpbm_subimage(struct netpbm_image*img, struct netpbm_image*src, struct netpbm_rect*rect) {
	int maxx = 0;
	int maxy = 0;
	int minx = 0;
	int miny = 0;
	if(rect->a.y > rect->b.y) {
		miny = rect->b.y;
		maxy = rect->a.y;
	}
	if(maxy > rect->c.y) {
		miny = (rect->c.y < miny) ? rect->c.y: miny;
	} else {
		maxy = rect->c.y;
	}
	if(maxy > rect->d.y) {
		miny = (rect->d.y < miny) ? rect->d.y: miny;
	} else {
		maxy = rect->d.y;
	}
	if(rect->a.x > rect->b.x) {
			minx = rect->b.x;
			maxx = rect->a.x;
	}
	if(maxx > rect->c.x) {
		minx = (rect->c.x < minx) ? rect->c.x: minx;
	} else {
		maxx = rect->c.x;
	}
	if(maxx > rect->d.x) {
		minx = (rect->d.x < minx) ? rect->d.x: minx;
	} else {
		maxx = rect->d.x;
	}

	(img)->width = maxx - minx;
	(img)->height = maxy - miny;
	img->pixels.gray = malloc(img->width * img->height * sizeof(char));
	int y,n,i,j,k;
	for(y = miny,n=0; y < maxy; y++,n++) {
		for(j = n*img->width,k = y*src->width,i=0;i<img->width;i++) {
			img->pixels.gray[j+i] = src->pixels.gray[k+i];
		}
	}
	img->type = src->type;
	img->maxval = src->maxval;
	return 0;
}
