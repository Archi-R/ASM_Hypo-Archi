@echo off
c:\masm32\bin\ml /c /Zd /coff adressage.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE adressage.obj
pause