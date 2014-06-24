
all:
	set -var MODULE_DIR -val ../../../ankhi
	module -load $(MODULE_DIR)/cv/plugin.so
	module -load $(MODULE_DIR)/convert/plugin.so
	#set -var JPGFILE -val ../../samples/myshelf/406.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var INPUTFILE -val edge.pgm
	echo $(INFILE)
	#make -t convertimg
	#make -t barcodedetect
	make -t bookdetecttest
	q
	q

bookdetecttest:
	bookdetect -mgval 30 -i $(INPUTFILE) -o output.pgm -rshift 4 -features ">15,,,,,=15,<5"
	convert -i output.pgm -o output.jpg
	convert -i $(INPUTFILE) -o input.jpg


cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i $(INFILE) -o $(INPUTFILE)

barcodedetect:
	barcodedetect -features ",,,,,>10" -mgval 60 -i $(INPUTFILE) -o output_small_msp10_rshift3.pgm -rshift 3
	convert -i output_small_msp10_rshift3.pgm -o output.jpg
	convert -i $(INPUTFILE) -o input.jpg

