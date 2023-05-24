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

nba db "nombre de a : %d", 0
nbb db "nombre de b : %d", 0
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
    mov edi, esi

loop_start: 
    mov al, byte ptr [edi]
    cmp al, 'a'
    je increment_a
    cmp al, 'b'
    je increment_b
    cmp al, 'c'
    je increment_c

    inc edi ; on passe au caractère suivant
    cmp byte ptr [edi], 0 ; on le compare avec 0 (fin de chaine)
    jne loop_start ; si non on retourne au debut de la boucle

loop_end:
    popad ; clear les registres
    pop ebp ; clear de ebp 
    ret ; return 

increment_a: 
    inc eax ; incrementation de a 
    jmp loop_start ; retour a la boucle principale

increment_b: 
    inc ebx 
    jmp loop_start

increment_c:
    inc ecx 
    jmp loop_start

countletters ENDP


start: 

    call countletters

    mov eax, eax 
    mov ebx, ebx 
    mov ecx, ecx 


    ; affichage du nombre de a
    push eax
    push offset nba
    call crt_printf
    add esp, 8 ; nettoyage de la pile
    ; affichage du nombre de b
    push ebx
    push offset nbb
    call crt_printf
    add esp, 8
    ; affichage du nombre de c
    push ecx
    push offset nbc 
    call crt_printf
    add esp, 8

    ; fin du programme
    push 0
    call ExitProcess

end start
