@echo off
c:\masm32\bin\ml /c /Zd /coff diviseurs.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE diviseurs.obj
pause