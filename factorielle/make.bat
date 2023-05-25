@echo off
c:\masm32\bin\ml /c /Zd /coff factorielle.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE factorielle.obj
factorielle.exe
pause