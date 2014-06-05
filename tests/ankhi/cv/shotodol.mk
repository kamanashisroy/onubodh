
all:
	set -var MODULE_DIR -val ../../../ankhi
	module -load $(MODULE_DIR)/cv/plugin.so
	#set -var JPGFILE -val ../../samples/myshelf/406.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var EDGEFILE -val edge.pgm
	echo $(INFILE)
	#make -t convertimg
	make -t bookdetecttest3
	q
	q

bookdetecttest:
	bookdetect -crk 4 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_mlen2_rshift2.pgm -rshift 2
	bookdetect -crk 4 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_mlen3_rshift3.pgm -rshift 3
	bookdetect -crk 1 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk1_mlen3_rshift4.pgm -rshift 4
	bookdetect -crk 1 -mlen 3 -mgval 30 -i $(EDGEFILE) -o output_small_crk1_mlen3_rshift4_healed.pgm -rshift 4 -heal
	bookdetect -crk 2 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen5_rshift3.pgm -rshift 3
	bookdetect -crk 4 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_mlen5_rshift3.pgm -rshift 3
	bookdetect -crk 4 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk4_mlen5_rshift3.pgm -rshift 3
	bookdetect -crk 2 -mlen 5 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen5_rshift4.pgm -rshift 4
	bookdetect -crk 2 -mlen 7 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen7_rshift4.pgm -rshift 4
	bookdetect -crk 8 -mlen 4 -mgval 30 -i $(EDGEFILE) -o output_small_crk8_mlen4_rshift4.pgm -rshift 4
	bookdetect -crk 5 -mlen 7 -mgval 30 -i $(EDGEFILE) -o output_small_crk5_mlen7_rshift4.pgm -rshift 4
	bookdetect -crk 2 -mlen 9 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen9_rshift4.pgm -rshift 4
	bookdetect -crk 2 -mlen 9 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen9_rshift4_merge_prune.pgm -rshift 4 -merge -prune
	bookdetect -crk 2 -mlen 18 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen18_rshift4.pgm -rshift 4
	bookdetect -crk 2 -mlen 2 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen4_rshift6.pgm -rshift 6
	#bookdetect -crk 4 -cont 9 -mgval 30 -i  $(EDGEFILE) -o output_small_crk4__continuous.pgm

bookdetecttest2:
	bookdetect -crk 2 -mlen 200 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen9_rshift4.pgm -rshift 4
	bookdetect -crk 2 -mlen 200 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen9_rshift4_heal.pgm -rshift 4 -heal
	bookdetect -crk 2 -mlen 200 -mgval 30 -i $(EDGEFILE) -o output_small_crk2_mlen9_rshift4_heal_merge.pgm -rshift 4 -heal -merge

bookdetecttest3:
	bookdetect -crk 20 -mlen 100 -mgval 30 -i $(EDGEFILE) -o output20.pgm -rshift 4 -prune
	bookdetect -crk 10 -mlen 70 -mgval 30 -i $(EDGEFILE) -o output20_rshift2.pgm -rshift 2 -merge


cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i $(INFILE) -o $(EDGEFILE)

