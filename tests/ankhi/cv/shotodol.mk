
all:
	set -var ANKHI -val ../../../ankhi
	module -load $(ANKHI)/cv/plugin.so
	module -load $(ANKHI)/convert/plugin.so
	module -load $(ANKHI)/scale/plugin.so
	module -load $(ANKHI)/imgdiff/plugin.so
	#set -var JPGFILE -val ../../samples/b4.jpg
	set -var INFILE -val ../../samples/b4.pgm
	set -var EDGEFILE -val edge.pgm
	echo $(INFILE)
	make -t convertimg
	make -t bookdetecttest
	q
	q

hi:
	scale -i samples/bookshelf1.ppm -o .output.down.ppm -down 2
	scale -i .output.down.ppm -o .output.up.ppm -up 2
	imgdiff -i1 samples/bookshelf1.ppm -i2 .output.up.ppm -o output_resample.diff
	scale -i .output.down.ppm -o .output.up.ppm -up 2
	imgpatch -i1 .output.up.ppm -i2 output_resample.diff -o output_resample.ppm
	quit

scale:
	scale -i samples/bookshelf1.ppm -o .output.down.ppm -down 2
	scale -i .output.down.ppm -o .output.up.ppm -up 2

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

convertimg:
	convert -i $(JPGFILE) -o input.ppm
	convert -i input.ppm -o intermediate.pgm
	#cvfastedge -i intermediate.pgm -o $(EDGEFILE)
	#edgefast -i intermediate.pgm -o input.pgm
	edgecanny -i intermediate.pgm -o $(EDGEFILE)
