
all:
	module -load ../../ankhi/cv/plugin.so
	module -load ../../ankhi/convert/plugin.so
	module -load ../../ankhi/scale/plugin.so
	module -load ../../ankhi/imgdiff/plugin.so
	make -t bookdetect
	q
	q

bookdetect:
	#bookdetect -cracklen 8 -continuity 8 -heal yes -radiusshift 2 -i input.pgm -o output_crack_8_continuity_8_radius_2_heal.pgm
	bookdetect -cracklen 4 -continuity 12 -heal yes -radiusshift 3 -i input.pgm -o output_crack_4_continuity_12_radius_3_heal.pgm

