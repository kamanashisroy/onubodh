
all:
	set -var MODULE_DIR -val ../../../ankhi
	module -load $(MODULE_DIR)/cv/plugin.so
	#set -var JPGFILE -val ../../samples/b4.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var EDGEFILE -val edge.pgm
	echo $(INFILE)
	#make -t convertimg
	make -t bookdetecttest
	q
	q

bookdetecttest:
	bookdetect -crk 2 -cont 3 -mgval 30 -i $(EDGEFILE) -o output_small2.pgm -rshift 2
	bookdetect -crk 2 -cont 3 -mgval 30 -i $(EDGEFILE) -o output_small3.pgm -rshift 3
	bookdetect -crk 2 -cont 3 -mgval 30 -i $(EDGEFILE) -o output_small4.pgm -rshift 4
	bookdetect -crk 2 -cont 5 -mgval 30 -i $(EDGEFILE) -o output_small_healed.pgm -heal
	bookdetect -crk 4 -cont 9 -mgval 30 -i  $(EDGEFILE) -o output_small_continuous.pgm

cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i $(INFILE) -o $(EDGEFILE)

