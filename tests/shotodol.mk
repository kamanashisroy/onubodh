
all:
	module -load ../ankhi/cv/plugin.so
	module -load ../ankhi/convert/plugin.so
	module -load ../ankhi/scale/plugin.so
	module -load ../ankhi/imgdiff/plugin.so

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

jpegconvert:
	jpegconvert -i samples/bookshelf1.ppm -o .output.jpeg
	jpegconvert -i .output.jpeg -o .output.back.ppm

bookdetecttest:
	bookdetect -i .edge.pgm -o .output.pgm

cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i samples/bookshelf1.pgm -o .edge.pgm
