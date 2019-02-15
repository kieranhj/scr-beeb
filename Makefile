PUCRUNCH?=pucrunch
PYTHON?=python
BEEBASM?=beebasm

##########################################################################
##########################################################################

.PHONY:build
build:
	mkdir -p ./build

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-hud.dat -m build/scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 ./graphics/scr-beeb-hud.png 5

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-header.dat --160 --palette 0143 ./graphics/scr-beeb-header.png 5

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-title-screen.dat --160 ./graphics/TitleScreen_BBC.png 2

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-menu.dat --palette 0143 ./graphics/scr-beeb-menu.png 1

	$(PYTHON) bin/flames.py > build/flames-tables.asm

	$(PYTHON) bin/wheels.py > build/wheels-tables.asm

	$(PYTHON) bin/hud_font.py > build/hud-font-tables.asm

	$(PYTHON) bin/dash_icons.py > build/dash-icons.asm

	$(PYTHON) bin/track_preview.py > build/track-preview.asm

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-credits.dat --160 ./graphics/scr-beeb-credits.png 2

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-wrecked.dat --160 ./graphics/scr-beeb-wrecked.png 5 --palette 0143

	$(PYTHON) bin/png2bbc.py -o build/scr-beeb-winner.dat --160 ./graphics/scr-beeb-winner.png 5 --palette 0124

	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-title-screen.dat" build/scr-beeb-title-screen.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-menu.dat" build/scr-beeb-menu.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-credits.dat" build/scr-beeb-credits.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-preview.dat" build/scr-beeb-preview.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-preview-bg.dat" build/scr-beeb-preview-bg.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-winner.dat" build/scr-beeb-winner.pu
	$(PUCRUNCH) -5 -d -c0 -l0x1000 "build/scr-beeb-wrecked.dat" build/scr-beeb-wrecked.pu

	$(BEEBASM) -i scr-beeb.asm -do scr-beeb.ssd -title "Stunt Car" -boot Loader -v > compile.txt

	cat compile.txt | grep -Evi '^\.' | grep -Evi '^    ' | grep -vi 'macro' | grep -vi 'saving file' | grep -vi 'safe to load to' | grep -Evi '^-+'

	$(PYTHON) bin/crc32.py scr-beeb.ssd

##########################################################################
##########################################################################

.PHONY:b2_test
b2_test:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file 'scr-beeb.ssd' 'http://localhost:48075/run/b2?name=scr-beeb.ssd'
