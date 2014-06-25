
SHOTODOL=../../../shotodol.bin

include ./test.mk

backup:
	mkdir -p .backup
	mv *.pgm .backup/

clean:backup
	$(RM) *.pgm
	

features.html:features_output.pgm.txt
	php genfeatures.php > features.html

