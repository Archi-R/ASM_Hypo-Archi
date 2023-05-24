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
mot db "cbabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacca",0

nba db "nombre de a : %d",10,0
nbb db "nombre de b : %d",10,0
nbc db "nombre de c : %d",10,0

.DATA?
; variables non-initialisees (bss)

.CODE
;code

countletters PROC
    push ebp
    mov ebp, esp
    pushad

    ; initialisation des 3 compteurs :
    mov ebx, 0  ; Compteur pour 'a'
    mov esi, 0  ; Compteur pour 'b'
    mov edi, 0  ; Compteur pour 'c'

    mov ecx, [ebp+8] ; on met le pointeur sur le mot dans eax

loop_start: 
    mov al, [ecx]
    or al, al ; vérifie si al est égal à la fin de la chaîne
	jz loop_end			; si oui, alors on quitte
    
    cmp al, 'a'
    je increment_a
    cmp al, 'b'
    je increment_b
    cmp al, 'c'
    je increment_c

    inc ecx ; on passe au caractère suivla boucle

loop_end:
    
     ; affichage du nombre de a
    push ebx
    push offset nba
    call crt_printf
    add esp, 8
    ; affichage du nombre de b
    push esi
    push offset nbb
    call crt_printf
    add esp, 8
    ; affichage du nombre de c
    push edi
    push offset nbc 
    call crt_printf
    add esp, 8

    popad ; clear les registres
    pop ebp ; clear de ebp 
    ret ; return

increment_a:

    inc ebx ; incrementation de a 
    inc ecx
    jmp loop_start ; retour a la boucle principale

increment_b:

    inc esi
    inc ecx
    jmp loop_start

increment_c:

    inc edi
    inc ecx
    jmp loop_start

countletters ENDP


start: 
    push offset mot

    call countletters
   
    ; fin du programme
    push 0
    call ExitProcess

end start
