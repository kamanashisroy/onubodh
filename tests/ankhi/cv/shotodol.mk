
all:
	set -var ANKHI -val ../../../ankhi
	module -load $(ANKHI)/cv/plugin.so
	module -load $(ANKHI)/convert/plugin.so
	module -load $(ANKHI)/scale/plugin.so
	module -load $(ANKHI)/imgdiff/plugin.so
	#set -var INFILE -val ../samples/simple.pgm
	set -var INFILE -val ../../samples/bookshelf1.pgm
	set -var EDGEFILE -val .edge.pgm
	echo $(INFILE)
	make -t cvfastedgetest
	make -t bookdetecttest_small
	#make -t bookdetecttest_big
	#make -t bookdetecttest_small
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

bookdetecttest_twice:
	bookdetect -i output.pgm -o output_twice.pgm

bookdetecttest_mini:
	bookdetect -i samples/rect16_16.pgm -o output.pgm

bookdetecttest_big:
	bookdetect -cracklen 2 -continuity 5 -mingrayval 30 -i books_edge2.pgm -o output.pgm
	bookdetect -cracklen 4 -continuity 9 -mingrayval 30 -i books_edge2.pgm -o output_continuous.pgm

bookdetecttest_small:
	bookdetect -cracklen 2 -continuity 5 -mingrayval 30 -i $(EDGEFILE) -o output_small.pgm
	bookdetect -cracklen 2 -continuity 5 -mingrayval 30 -i $(EDGEFILE) -o output_small_healed.pgm -heal
	bookdetect -cracklen 4 -continuity 9 -mingrayval 30 -i  $(EDGEFILE) -o output_small_continuous.pgm

cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i ../samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i $(INFILE) -o $(EDGEFILE)
