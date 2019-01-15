##########################################################################
##########################################################################

.PHONY:build
build:
	beebasm -i scr-beeb.asm -do scr-beeb.ssd -boot Loader -v > compile.txt
	python bin/crc32.py scr-beeb.ssd

##########################################################################
##########################################################################

.PHONY:b2_test
b2_test:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file 'scr-beeb.ssd' 'http://localhost:48075/run/b2?name=scr-beeb.ssd'
