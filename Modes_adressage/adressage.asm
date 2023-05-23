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
; variables initialisees
Phrase     db    "phrasewENwmaj",10,0
strCommand db "Pause",13,10,0 ; on va garder ça c'est pas une bete idée

.DATA?
; variables non-initialisees (bss)

.CODE
start:
	; itérer sur une string
	mov esi, offset Phrase
	; boucle
	boucle:
		mov al, [esi] 		; on charge le caractere courant
		or al, al		; si c'est la fin de chaine
		jz fin			; alors on quitte
		
		; ET sur le 6e bit : ça le met à 0 peu importe la casse, => minuscule
		and al,0DFh ; 1101 1111
		mov [esi],al ; on remplace le caractere

		inc esi ; passer au caractère suivant
		jnz boucle
	
	fin:
		; On place l'argument de la fonction appelée sur la pile
        push offset Phrase
        ; call printf
        call crt_printf

		invoke crt_system, offset strCommand
		mov eax, 0
	    invoke	ExitProcess,eax
end start