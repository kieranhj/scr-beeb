##########################################################################
##########################################################################

.PHONY:build
build:
	mkdir -p ./build

	python bin/png2bbc.py -o build/scr-beeb-hud.dat -m build/scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 ./graphics/scr-beeb-hud.png 5

	python bin/png2bbc.py -o build/scr-beeb-header.dat --160 --palette 0143 ./graphics/scr-beeb-header.png 5

	python bin/png2bbc.py -o build/scr-beeb-title-screen.dat --160 ./graphics/TitleScreen_BBC.png 2

	python bin/flames.py > build/flames-tables.asm

	python bin/wheels.py > build/wheels-tables.asm

	beebasm -i scr-beeb.asm -do scr-beeb.ssd -boot Loader -v > compile.txt

	cat compile.txt | grep -Evi '^\.' | grep -Evi '^    ' | grep -vi 'macro' | grep -vi 'saving file' | grep -vi 'align lost' | grep -vi 'safe to load to' | grep -Evi '^-+'

	python bin/crc32.py scr-beeb.ssd

##########################################################################
##########################################################################

.PHONY:b2_test
b2_test:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file 'scr-beeb.ssd' 'http://localhost:48075/run/b2?name=scr-beeb.ssd'
