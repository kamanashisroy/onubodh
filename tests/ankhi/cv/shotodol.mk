
all:
	set -var MODULE_DIR -val ../../../ankhi
	module -load $(MODULE_DIR)/cv/plugin.so
	#set -var JPGFILE -val ../../samples/myshelf/406.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var EDGEFILE -val edge.pgm
	echo $(INFILE)
	#make -t convertimg
	make -t bookdetecttest
	q
	q

bookdetecttest:
	bookdetect -crk 4 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_2.pgm -rshift 2
	bookdetect -crk 4 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_3.pgm -rshift 3
	bookdetect -crk 1 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk1_4.pgm -rshift 4
	bookdetect -crk 2 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_3.pgm -rshift 3
	bookdetect -crk 4 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_5.pgm -rshift 3
	bookdetect -crk 4 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_5_heal.pgm -rshift 3 -heal
	bookdetect -crk 2 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_4.pgm -rshift 4
	bookdetect -crk 2 -mlen 7 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_4_7.pgm -rshift 4
	bookdetect -crk 8 -mlen 7 -mgval 30 -i $(EDGEFILE) -o output_small_crk8_4_7.pgm -rshift 4
	bookdetect -crk 5 -mlen 7 -mgval 30 -i $(EDGEFILE) -o output_small_crk5_4_7.pgm -rshift 4
	bookdetect -crk 2 -mlen 9 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_4_9.pgm -rshift 4
	bookdetect -crk 2 -mlen 18 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_4_18.pgm -rshift 4
	#bookdetect -crk 2 -cont 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk2__healed.pgm -heal
	#bookdetect -crk 4 -cont 9 -mgval 30 -i  $(EDGEFILE) -o output_small_crk4__continuous.pgm

cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i $(INFILE) -o $(EDGEFILE)

