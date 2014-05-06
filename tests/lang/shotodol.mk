
all:
	module -load ../../lang/token/plugin.so
	xtransform -i input.xml
	wa -l 100
	q

