@echo off
set PYTHON=C:\Home\Python27\python.exe
%PYTHON% bin/png2bbc.py -o build\scr-beeb-hud.dat -m build\scr-beeb-hud-mask.dat --160 --palette 0143 --transparent-output 3 --transparent-rgb 255 0 255 .\graphics\scr-beeb-hud.png 5
%PYTHON% bin\flames.py > build\flames-tables.asm
..\beebasm\beebasm.exe -i scr-beeb.asm -do scr-beeb.ssd -boot Loader -v > compile.txt
%PYTHON% bin\crc32.py scr-beeb.ssd
