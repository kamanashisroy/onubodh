#ifndef SHOTODOL
#SHOTODOL=shotodol.bin
#endif

testcv:
	$(SHOTODOL)

canny:
	python ../cannyopencv.py

