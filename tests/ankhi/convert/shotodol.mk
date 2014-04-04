
all:
	module -load ../../../ankhi/cv/plugin.so
	module -load ../../../ankhi/convert/plugin.so
	module -load ../../../ankhi/scale/plugin.so
	module -load ../../../ankhi/imgdiff/plugin.so
	make -t jpegconvert
	q

jpegconvert:
	jpegconvert -i samples/bookshelf1.ppm -o .output.jpeg
	jpegconvert -i .output.jpeg -o .output.back.ppm

