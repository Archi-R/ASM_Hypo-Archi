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

.DATA ;variable initialisées

    format_int db "%d", 0
    message db "le resultat est : %d ",0
    number dd 0

    buffer db 256 DUP(0) ; buffer de lecture

.DATA?

.CODE


factojitas: 
    push ebp ; sauvegarder la base de la pile
    mov ebp, esp ; établir un nouveau cadre de pile

    
    mov ecx, [ebp+8] ; recup de  l'arg
    cmp ecx, 1
    je cas_de_base ; si égal à 1, c'est le cas de base
    
    dec ecx ; on décrémente le nombre
    push ecx ; YEET ecx sur la pile
    call factojitas ; et c'est reparti pour un tour
    inc ecx ; on readd 1 à ecx car on l'a dec juste au dessus pour piler les appels
    mul ecx ; on fait enfin l'opération qui finit sur eax

    jmp fin

    cas_de_base:
        mov eax, 1 ; on met 1 dans eax (quyi sera appelé par les appels plus profonds

    fin:
        mov esp, ebp ; nettoyer la pile
        pop ebp ; restaurer la base de la pile
        ret 4 ; nettoyer l'argument de la pile et retourner
start: 

    lea eax, [number] ; obtenir l'adresse de 'number'
    push eax ; push l'adresse de 'number'
    push offset format_int
    call crt_scanf ; appelle scanf
    add esp, 8 ; nettoie la pile

    ; afficher le nombre
    mov eax, [number] ; obtenir le nombre stocké
    push eax ; push le nombre
    
    call factojitas ; appel de factojitas 

    push eax
    push offset message
    call crt_printf
    add esp, 8

    push 0
    call ExitProcess

end start
