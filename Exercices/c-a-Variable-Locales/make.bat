@echo off
c:\masm32\bin\ml /c /Zd /coff variables.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE variables.obj
variables.exe
pause