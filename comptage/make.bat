@echo off
c:\masm32\bin\ml /c /Zd /coff comptage.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE comptage.obj
pause