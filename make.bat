
@echo off
set PYTHON=C:\Home\Python27\python.exe
..\..\Bin\beebasm.exe -i scr-beeb.asm -do scr-beeb.ssd -boot Loader -v > compile.txt
%PYTHON% bin\crc32.py scr-beeb.ssd
