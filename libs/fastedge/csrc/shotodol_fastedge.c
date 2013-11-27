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
#include "fast-edge.h"

int shotodol_fastedge_filter(char *infile, char *outfile, int*ecode)
{
	struct netpbm_image img, img_gauss, img_out;
	netpbm_init_img(&img);
	netpbm_init_img(&img_gauss);
	netpbm_init_img(&img_out);
	img.filename = infile;
	img_out.filename = outfile;
	if(!outfile || !infile) {
		*ecode = 526;
		return -1;
	}

	if(netpbm_open_and_read(&img, ecode) == -1) {
		return -1;
	}

	if(img.type != NETPBM_IMAGE_TYPE_PGM) {
		*ecode = 527;
		netpbm_destroy(&img);
		return -1;
	}
	
	if(netpbm_alloc_from_src(&img_out, &img) || netpbm_alloc_from_src(&img_gauss, &img)) {
		goto cleanup_memory;
	}
	gaussian_noise_reduce(&img, &img_gauss);
	//printf("*** performing morphological closing ***\n");
	//morph_close(&img, &img_scratch, &img_scratch2, &img_gauss);
	canny_edge_detect(&img_gauss, &img_out);
	netpbm_write(&img_out, NULL);
cleanup_memory:
	netpbm_destroy(&img);
	netpbm_destroy(&img_out);
	netpbm_destroy(&img_gauss);
	return 0;
}
