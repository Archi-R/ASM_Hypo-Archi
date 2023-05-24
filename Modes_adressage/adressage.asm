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
Phrase     db    "ptn ca marche",10,0
strCommand db "Pause",13,10,0 ; on va garder ça c'est pas une bete idée

.DATA?
; variables non-initialisees (bss)

.CODE
start:
	push offset Phrase ; on donne la le l'adresse de la cheu-chaine
	mov esi, offset Phrase
	
	call metsEnMajuscule ;appel sous programme
	
	invoke crt_system, offset strCommand
	mov eax, 0
	invoke	ExitProcess,eax

	metsEnMajuscule proc
		mov esi, [esp+4] ; on recupere l'adresse de la chaine qui se trouve sur la pile
		boucle:
			mov al, [esi] 		; on charge le caractere courant
			or al, al		; si le zero flag est à 1, c'est la fin de chaine
			jz fin			; alors on quitte

			cmp al, ' ' ; si c'est un espace
			je espace
			
			; ET sur le 6e bit : ça le met à 0 peu importe la casse, => minuscule
			and al,0DFh ; 1101 1111
			mov [esi],al ; on remplace le caractere

			inc esi ; passer au caractère suivant
			jnz boucle
		
		espace:
			inc esi ; passer au caractère suivant
			jnz boucle 
		fin:
			invoke crt_printf, offset Phrase

	metsEnMajuscule endp

end start