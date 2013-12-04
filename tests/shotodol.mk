
all:
	module -load ../ankhi/cv/plugin.so
	module -load ../ankhi/convert/plugin.so

test:
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
