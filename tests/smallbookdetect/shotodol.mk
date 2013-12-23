
all:
	module -load ../../ankhi/cv/plugin.so
	module -load ../../ankhi/convert/plugin.so
	module -load ../../ankhi/scale/plugin.so
	module -load ../../ankhi/imgdiff/plugin.so
	make -t bookdetect
	q
	q

bookdetect:
	#bookdetect -cracklen 8 -continuity 3 -mingrayval 30 -radiusshift 5 -i input.pgm -o output_crack_2_continuity_8_radius_5.pgm
	#bookdetect -cracklen 8 -continuity 3 -radiusshift 5 -heal yes -i input.pgm -o output_crack_2_continuity_8_radius_5_heal.pgm
	bookdetect -cracklen 8 -continuity 8 -heal yes -radiusshift 2 -i input.pgm -o output_crack_8_continuity_8_radius_2_heal.pgm
	#bookdetect -cracklen 2 -continuity 5 -heal yes -radiusshift 4 -i input.pgm -o output_crack_2_continuity_5_radius_4.pgm
	#bookdetect -cracklen 8 -continuity 8 -heal yes -radiusshift 3 -i input.pgm -o output_crack_8_continuity_8_radius_3_heal.pgm
	#bookdetect -cracklen 8 -continuity 3 -mingrayval 30 -radiusshift 4 -i input.pgm -o output_crack_2_continuity_8_radius_4.pgm
	#bookdetect -cracklen 8 -continuity 3 -mingrayval 30 -radiusshift 6 -i input.pgm -o output_crack_2_continuity_8_radius_6.pgm

