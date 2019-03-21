ifeq ($(OS),Windows_NT)
CP:=copy
RM_RF:=-cmd /c rd /s /q
MKDIR_P:=-cmd /c mkdir
BEEBASM?=beebasm
EXO?=bin\exomizer.exe
else
CP:=cp
RM_RF:=rm -Rf
MKDIR_P:=mkdir -p
BEEBASM?=beebasm
EXO?=exomizer
endif

PYTHON?=python

##########################################################################
##########################################################################

PNG2BBC_DEPS:=./bin/png2bbc.py ./bin/bbc.py
EXO_AND_ARGS=$(EXO) level -c -M256

##########################################################################
##########################################################################

# Files required for the game, in the order in which they're loaded.
# This is the list of files that will be copied by the installer, and
# the order in which they'll go on the final disk image.
#
# The SSD that BeebAsm produces can include other files, and they'll
# be included, but the installer will ignore them and be in no
# specific order.
REQUIRED_FILES:=\
	!BOOT\
	Title\
	Loader2\
	Cart\
	Kernel\
	Beebgfx\
	Beebmus\
	Core\
	Hazel\
	Data

##########################################################################
##########################################################################

.PHONY:build
build:\
	./build/scr-beeb-title-screen.exo\
	./build/scr-beeb-menu.exo\
	./build/scr-beeb-credits.exo\
	./build/scr-beeb-hud.dat\
	./build/scr-beeb-preview.exo\
	./build/keys.mode7.exo\
	./build/trainer.mode7.exo\
	./build/scr-beeb-hof.exo\
	./build/track-preview.asm

	$(MKDIR_P) "./build"
	$(PYTHON) bin/flames.py > build/flames-tables.asm
	$(PYTHON) bin/wheels.py > build/wheels-tables.asm
	$(PYTHON) bin/hud_font.py > build/hud-font-tables.asm
	$(PYTHON) bin/dash_icons.py > build/dash-icons.asm
	$(PYTHON) bin/horizon_table.py
	$(BEEBASM) -i scr-beeb.asm -do scr-beeb.ssd -title "Stunt Car" -opt 2 -v > compile.txt

ifneq ($(OS),Windows_NT)
	cat compile.txt | grep -Evi '^\.' | grep -Evi '^    ' | grep -vi 'macro' | grep -vi 'saving file' | grep -vi 'safe to load to' | grep -Evi '^-+'
endif

	$(PYTHON) bin/crc32.py scr-beeb.ssd

	$(MAKE) disc_images

##########################################################################
##########################################################################

.PHONY:disc_images
disc_images:
# generate full text of installer
	$(CP) "data/install.txt" "build/"
	$(PYTHON) bin/add_installer_data.py $(REQUIRED_FILES) >> "build/install.txt"

# get BeebAsm to tokenize the installer

	beebasm -i data\install.asm -do build\install.ssd

# extract the installer

	$(RM_RF) "build/install_files/"
	$(MKDIR_P) "build/install_files/"
	$(PYTHON) bin/scr_ssd_extract.py -o build/install_files/ -0 ./build/install.ssd

# extract BeebAsm output.

	$(RM_RF) "build/files/"
	$(MKDIR_P) "build/files/"
	$(PYTHON) bin/scr_ssd_extract.py -o build/files/ -0 ./scr-beeb.ssd

# include installer on DFS copy.

	$(PYTHON) bin/scr_ssd_create.py --dir=build/files/ -o build/scr-beeb.ssd $(addprefix build/files/$$.,$(REQUIRED_FILES)) build/files/* build/install_files/$$.INSTALL

# don't include installer on ADFS - it assumes DFS, and there's no
# point to it anyway, as you can just use *COPY.

	$(PYTHON) bin/scr_adf_create.py --dir=build/files/ --type=L -o build/scr-beeb.adl $(addprefix build/files/$$.,$(REQUIRED_FILES)) build/files/*

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(RM_RF) "build"

##########################################################################
##########################################################################

./build/scr-beeb-title-screen.exo:\
	./graphics/TitleScreen_BBC.png\
	$(PNG2BBC_DEPS)

	$(MKDIR_P) "./build"
	$(PYTHON) bin/png2bbc.py --quiet -o build/scr-beeb-title-screen.dat --160 ./graphics/TitleScreen_BBC.png 2
	$(EXO_AND_ARGS) build/scr-beeb-title-screen.dat@0x3000 -o build/scr-beeb-title-screen.exo

##########################################################################
##########################################################################

./build/scr-beeb-menu.exo:\
	./graphics/scr-beeb-menu.png\
	$(PNG2BBC_DEPS)

	$(MKDIR_P) "./build"
	$(PYTHON) bin/png2bbc.py --quiet -o build/scr-beeb-menu.dat --palette 0143 ./graphics/scr-beeb-menu.png 1
	$(EXO_AND_ARGS) build/scr-beeb-menu.dat@0x4000 -o build/scr-beeb-menu.exo

##########################################################################
##########################################################################

./build/scr-beeb-credits.exo:\
	./graphics/scr-beeb-credits.png

	$(MKDIR_P) "./build"
	$(PYTHON) bin/png2bbc.py --quiet -o build/scr-beeb-credits.dat --160 ./graphics/scr-beeb-credits.png 2
	$(EXO_AND_ARGS) build/scr-beeb-credits.dat@0x3000 -o build/scr-beeb-credits.exo

##########################################################################
##########################################################################

./build/scr-beeb-hud.dat:\
	./graphics/scr-beeb-hud.png\
	$(PNG2BBC_DEPS)

	$(MKDIR_P) "./build"
	$(PYTHON) bin/png2bbc.py --quiet -o build/scr-beeb-hud.dat -m build/scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 ./graphics/scr-beeb-hud.png 5

##########################################################################
##########################################################################

./build/scr-beeb-preview-bg.exo\
./build/scr-beeb-preview.exo\
./build/track-preview.asm\
	:\
	./graphics/scr-beeb-preview.png\
	./build/scr-beeb-hud.dat\
	./bin/track_preview.py\
	./bin/bbc.py

	$(PYTHON) bin/track_preview.py > build/track-preview.asm
	$(EXO_AND_ARGS) build/scr-beeb-preview.dat@0x4000 -o build/scr-beeb-preview.exo
	$(EXO_AND_ARGS) build/scr-beeb-preview-bg.dat@0x6280 -o build/scr-beeb-preview-bg.exo

##########################################################################
##########################################################################

./build/keys.mode7.exo:\
	./data/keys.mode7.txt\
	./bin/teletext2bin.py

	$(PYTHON) bin/teletext2bin.py data/keys.mode7.txt build/keys.mode7.bin
	$(EXO_AND_ARGS) build/keys.mode7.bin@0x7c00 -o build/keys.mode7.exo

##########################################################################
##########################################################################

./build/trainer.mode7.exo:\
	./data/trainer.mode7.txt\
	./bin/teletext2bin.py

	$(PYTHON) bin/teletext2bin.py data/trainer.mode7.txt build/trainer.mode7.bin
	$(EXO_AND_ARGS) build/trainer.mode7.bin@0x7c00 -o build/trainer.mode7.exo

##########################################################################
##########################################################################

./build/scr-beeb-hof.exo:\
	./graphics/HallFame_BBC.png

	$(PYTHON) bin/png2bbc.py --quiet -o build/scr-beeb-hof.dat --palette 0143 ./graphics/HallFame_BBC.png 1
	$(EXO_AND_ARGS) build/scr-beeb-hof.dat@0x4000 -o build/scr-beeb-hof.exo

##########################################################################
##########################################################################

.PHONY:b2_test
b2_test:
	-$(MAKE) _b2_dfs_test

##########################################################################
##########################################################################

.PHONY:_b2_dfs_test
_b2_dfs_test:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file 'scr-beeb.ssd' 'http://localhost:48075/run/b2?name=scr-beeb.ssd'

##########################################################################
##########################################################################

.PHONY:_b2_adfs_test
_b2_adfs_test:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file 'build/scr-beeb.adl' 'http://localhost:48075/run/b2?name=scr-beeb.adl'


##########################################################################
##########################################################################

.PHONY:tom_beeblink
tom_beeblink: DEST=~/beeb/beeb-files/stuff
tom_beeblink:
	cp ./build/scr-beeb.ssd $(DEST)/ssds/0/s.scr-beeb
	touch $(DEST)/ssds/0/s.scr-beeb.inf

	rm -Rf $(DEST)/scr-beeb/0
	ssd_extract --not-emacs -o $(DEST)/scr-beeb/0/ -0 ./scr-beeb.ssd

# Add files with new ASCII chars in their names.
	touch $(DEST)/scr-beeb/0/ugh1
	echo '$$.{|}~ ffffffff ffffffff' > $(DEST)/scr-beeb/0/ugh1.inf

	touch $(DEST)/scr-beeb/0/ugh2
	echo '$$.[\\]^_` ffffffff ffffffff' > $(DEST)/scr-beeb/0/ugh2.inf

# Add more files to induce scrolling.
	@touch $(DEST)/scr-beeb/0/_.00 && touch $(DEST)/scr-beeb/0/_.00.inf
	@touch $(DEST)/scr-beeb/0/_.01 && touch $(DEST)/scr-beeb/0/_.01.inf
	@touch $(DEST)/scr-beeb/0/_.02 && touch $(DEST)/scr-beeb/0/_.02.inf
	@touch $(DEST)/scr-beeb/0/_.03 && touch $(DEST)/scr-beeb/0/_.03.inf
	@touch $(DEST)/scr-beeb/0/_.04 && touch $(DEST)/scr-beeb/0/_.04.inf
	@touch $(DEST)/scr-beeb/0/_.05 && touch $(DEST)/scr-beeb/0/_.05.inf
	@touch $(DEST)/scr-beeb/0/_.06 && touch $(DEST)/scr-beeb/0/_.06.inf
	@touch $(DEST)/scr-beeb/0/_.07 && touch $(DEST)/scr-beeb/0/_.07.inf
	@touch $(DEST)/scr-beeb/0/_.08 && touch $(DEST)/scr-beeb/0/_.08.inf
	@touch $(DEST)/scr-beeb/0/_.09 && touch $(DEST)/scr-beeb/0/_.09.inf
	@touch $(DEST)/scr-beeb/0/_.10 && touch $(DEST)/scr-beeb/0/_.10.inf
	@touch $(DEST)/scr-beeb/0/_.11 && touch $(DEST)/scr-beeb/0/_.11.inf
	@touch $(DEST)/scr-beeb/0/_.12 && touch $(DEST)/scr-beeb/0/_.12.inf
	@touch $(DEST)/scr-beeb/0/_.13 && touch $(DEST)/scr-beeb/0/_.13.inf
	@touch $(DEST)/scr-beeb/0/_.14 && touch $(DEST)/scr-beeb/0/_.14.inf
	@touch $(DEST)/scr-beeb/0/_.15 && touch $(DEST)/scr-beeb/0/_.15.inf
	@touch $(DEST)/scr-beeb/0/_.16 && touch $(DEST)/scr-beeb/0/_.16.inf
	@touch $(DEST)/scr-beeb/0/_.17 && touch $(DEST)/scr-beeb/0/_.17.inf
	@touch $(DEST)/scr-beeb/0/_.18 && touch $(DEST)/scr-beeb/0/_.18.inf
	@touch $(DEST)/scr-beeb/0/_.19 && touch $(DEST)/scr-beeb/0/_.19.inf

	touch $(DEST)/ssds/0/l.scr-beeb.inf
	cp build/scr-beeb.adl $(DEST)/ssds/0/l.scr-beeb
