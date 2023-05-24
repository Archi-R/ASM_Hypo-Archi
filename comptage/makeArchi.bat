@echo off
c:\masm32\bin\ml /c /Zd /coff comptageArchi.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE comptageArchi.obj
comptageArchi.exe
pause