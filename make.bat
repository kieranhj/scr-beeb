@echo off
if "%PYTHON%"=="" set PYTHON=C:\Home\Python27\python.exe

%PYTHON% bin/png2bbc.py --quiet -o build/scr-beeb-hud.dat -m build/scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 ./graphics/scr-beeb-hud.png 5

rem	%PYTHON% bin/png2bbc.py -o build/scr-beeb-header.dat --160 --palette 0143 ./graphics/scr-beeb-header.png 5

%PYTHON% bin/png2bbc.py --quiet -o build/scr-beeb-title-screen.dat --160 ./graphics/TitleScreen_BBC.png 2
%PYTHON% bin/png2bbc.py --quiet -o build/scr-beeb-menu.dat --palette 0143 ./graphics/scr-beeb-menu.png 1
%PYTHON% bin/flames.py > build/flames-tables.asm
%PYTHON% bin/wheels.py > build/wheels-tables.asm
%PYTHON% bin/hud_font.py > build/hud-font-tables.asm
%PYTHON% bin/dash_icons.py > build/dash-icons.asm
%PYTHON% bin/track_preview.py > build/track-preview.asm
%PYTHON% bin/png2bbc.py --quiet -o build/scr-beeb-credits.dat --160 ./graphics/scr-beeb-credits.png 2
%PYTHON% bin/png2bbc.py --quiet -o build/scr-beeb-hof.dat --palette 0143 ./graphics/HallFame_BBC.png 1

%PYTHON% bin/teletext2bin.py data/trainer.mode7.txt build/trainer.mode7.bin

bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-title-screen.dat" build\scr-beeb-title-screen.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-menu.dat" build\scr-beeb-menu.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-credits.dat" build\scr-beeb-credits.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-preview.dat" build\scr-beeb-preview.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-preview-bg.dat" build\scr-beeb-preview-bg.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "data/keys.mode7.bin" build/keys.mode7.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-hof.dat" build\scr-beeb-hof.pu
bin\pucrunch.exe -5 -d -c0 -l0x1000 "build/trainer.mode7.bin" build/trainer.mode7.pu

..\beebasm\beebasm.exe -i scr-beeb.asm -do scr-beeb.ssd -title "Stunt Car" -boot Loader -v > compile.txt
%PYTHON% bin\crc32.py scr-beeb.ssd
