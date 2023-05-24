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
mot db "acbabcbbabcbabcb",0

nba db "nombre de a : %d, ", 0
nbb db "nombre de b : %d, ", 0
nbc db "nombre de c : %d", 0

.DATA?
; variables non-initialisees (bss)

.CODE
;code

countletters PROC
    push ebp
    mov ebp, esp
    pushad

    ; initialisation des 3 compteurs :
    mov eax, 0 
    mov ebx, 0
    mov ecx, 0

    mov esi, offset mot

loop_start: 
    mov al, [esi]
    or al, al; si le zero flag est à 1, c'est la fin de chaine
	jz loop_end			; alors on quitte

    cmp al, 'a'
    je increment_a
    cmp al, 'b'
    je increment_b
    cmp al, 'c'
    je increment_c

    inc esi ; on passe au caractère suivla boucle

loop_end:
    popad ; clear les registres
    pop ebp ; clear de ebp 
    ret ; return 

increment_a:
    inc eax ; incrementation de a 
    inc esi
    jmp loop_start ; retour a la boucle principale

increment_b: 
    inc ebx
    inc esi
    jmp loop_start

increment_c:
    inc ecx
    inc esi
    jmp loop_start

countletters ENDP


start: 

    call countletters
    ; affichage du nombre de a
    push eax
    push offset nba
    invoke crt_printf
    ; affichage du nombre de b
    push ebx
    push offset nbb
    invoke crt_printf
    ; affichage du nombre de c
    push ecx
    push offset nbc 
    invoke crt_printf

    ; fin du programme
    push 0
    call ExitProcess

end start
