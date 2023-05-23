@echo off
c:\masm32\bin\ml /c /Zd /coff HelloBitches.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE HelloBitches.obj
pause