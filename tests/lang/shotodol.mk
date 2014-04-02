
all:
	module -load ../../lang/token/plugin.so
	xtransform -i input.xml
	glide
	wa
	q

