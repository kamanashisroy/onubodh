
all:
	module -load ../ankhi/cv/plugin.so

test:
	cvstrucstr -i .edge.pgm -o .strucstr.txt

cvkmeanstest:
	cvkmeans -i samples/bookshelf1.ppm -o .kmeans.ppm -k 30

cvcentroidtest:
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 10 -y 12
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 100 -y 100
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 350 -y 100
	cvcentroid -i samples/simple.pgm -o .output.pgm -x 350 -y 200

cvfastedgetest:
	cvfastedge -i samples/bookshelf1.pgm -o .edge.pgm
