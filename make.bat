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

%PYTHON% bin/teletext2bin.py data/keys.mode7.txt build/keys.mode7.bin
%PYTHON% bin/teletext2bin.py data/trainer.mode7.txt build/trainer.mode7.bin

%PYTHON% bin/horizon_table.py

rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-title-screen.dat" build\scr-beeb-title-screen.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-menu.dat" build\scr-beeb-menu.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-credits.dat" build\scr-beeb-credits.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-preview.dat" build\scr-beeb-preview.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-preview-bg.dat" build\scr-beeb-preview-bg.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\keys.mode7.bin" build\keys.mode7.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\scr-beeb-hof.dat" build\scr-beeb-hof.pu
rem bin\pucrunch.exe -5 -d -c0 -l0x1000 "build\trainer.mode7.bin" build\strainer.mode7.pu

bin\exomizer.exe level -c -M256 build/scr-beeb-title-screen.dat@0x3000 -o build/scr-beeb-title-screen.exo
bin\exomizer.exe level -c -M256 build/scr-beeb-menu.dat@0x4000 -o build/scr-beeb-menu.exo
bin\exomizer.exe level -c -M256 build/scr-beeb-credits.dat@0x3000 -o build/scr-beeb-credits.exo
bin\exomizer.exe level -c -M256 build/scr-beeb-preview.dat@0x4000 -o build/scr-beeb-preview.exo
bin\exomizer.exe level -c -M256 build/scr-beeb-preview-bg.dat@0x6280 -o build/scr-beeb-preview-bg.exo
rem bin\exomizer.exe level -c -M256 build/scr-beeb-winner.dat build/scr-beeb-winner.exo
rem bin\exomizer.exe level -c -M256 build/scr-beeb-wrecked.dat build/scr-beeb-wrecked.exo
bin\exomizer.exe level -c -M256 build/keys.mode7.bin@0x7c00 -o build/keys.mode7.exo
bin\exomizer.exe level -c -M256 build/trainer.mode7.bin@0x7c00 -o build/trainer.mode7.exo
bin\exomizer.exe level -c -M256 build/scr-beeb-hof.dat@0x4000 -o build/scr-beeb-hof.exo

..\beebasm\beebasm.exe -i scr-beeb.asm -do scr-beeb.ssd -title "Stunt Car" -opt 2 -v > compile.txt
%PYTHON% bin\crc32.py scr-beeb.ssd
