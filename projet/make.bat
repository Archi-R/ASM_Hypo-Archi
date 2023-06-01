@echo off
c:\masm32\bin\ml /c /Zd /coff our_dir.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE our_dir.obj
our_dir.exe
pause