
all:
	set -var MODULE_DIR -val ../../../ankhi
	module -load $(MODULE_DIR)/cv/plugin.so
	module -load $(MODULE_DIR)/convert/plugin.so
	#set -var JPGFILE -val ../../samples/myshelf/406.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var INPUTFILE -val edge.pgm
	echo $(INFILE)
	make -t barcodedetect
	#make -t bookdetecttest
	q
	q

bookdetecttest:
	structdetect -mgval 30 -i $(INPUTFILE) -o output.pgm -rshift 4 -features ">15,,,,,=15,<5"
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
	structdetect -st 2 -features ",,,,,,,>10" -mgval 60 -i $(INPUTFILE) -o output.pgm -rshift 3
	convert -i output.pgm -o output.jpg
	convert -i $(INPUTFILE) -o input.jpg

