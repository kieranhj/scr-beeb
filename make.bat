@echo off
set PYTHON=C:\Home\Python27\python.exe

	%PYTHON% bin/png2bbc.py -o build/scr-beeb-hud.dat -m build/scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 ./graphics/scr-beeb-hud.png 5

	%PYTHON% bin/png2bbc.py -o build/scr-beeb-header.dat --160 --palette 0143 ./graphics/scr-beeb-header.png 5

	%PYTHON% bin/png2bbc.py -o build/scr-beeb-title-screen.dat --160 ./graphics/TitleScreen_BBC.png 2

	%PYTHON% bin/png2bbc.py -o build/scr-beeb-menu.dat --palette 0143 ./graphics/scr-beeb-menu.png 1

	%PYTHON% bin/flames.py > build/flames-tables.asm

	%PYTHON% bin/wheels.py > build/wheels-tables.asm

	%PYTHON% bin/hud_font.py > build/hud-font-tables.asm

	%PYTHON% bin/track_preview.py > build/track-preview.asm

	bin\pucrunch.exe -d -c0 -l0x1000 "build\scr-beeb-menu.dat" build\scr-beeb-menu.pu

..\beebasm\beebasm.exe -i scr-beeb.asm -do scr-beeb.ssd -boot Loader -v > compile.txt
%PYTHON% bin\crc32.py scr-beeb.ssd
