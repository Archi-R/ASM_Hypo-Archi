.386
.model flat,stdcall
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\gdi32.inc
include c:\masm32\include\gdiplus.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc

includelib c:\masm32\lib\gdi32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\msvcrt.lib

.DATA
; faire un hello bitches
leTxt db "PRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",0
leTtr db "YEET !EKIREY!",0
strCommand db "Pause",13,10,0

.CODE
start:
	;code
	push 0
	push offset leTxt ;MessageBoxA ne prends que des adresses
	push offset leTtr
	push 0

	call MessageBoxA
	add esp, 16

	mov eax, 0 ;on met un 0 dans la pile
	invoke	ExitProcess,eax ;on calll la fin de prog avec le 0 mis au dessus
end start