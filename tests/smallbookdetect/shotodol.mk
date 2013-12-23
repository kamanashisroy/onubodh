
all:
	module -load ../../ankhi/cv/plugin.so
	module -load ../../ankhi/convert/plugin.so
	module -load ../../ankhi/scale/plugin.so
	module -load ../../ankhi/imgdiff/plugin.so
	make -t bookdetect
	q
	q

bookdetect:
	bookdetect -cracklen 2 -continuity 8 -mingrayval 30 -radiusshift 5 -i input.pgm -o output_crack_2_continuity_8_radius_5.pgm

