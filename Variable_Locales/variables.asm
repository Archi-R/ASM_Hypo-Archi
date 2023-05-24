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
format db "%d",0

.DATA?
; variables non-initialisees (bss)

.CODE
;code
myst PROC
    ; Prologue de la fonction
    push ebp
    mov ebp, esp
    
    ; Déclaration des variables locales
    pushad ; Sauvegarde des registres généraux

    ; Variables locales
    mov ecx, [ebp+8] ; Récupère la valeur de l'argument 'n'

    ; Initialisation des variables
    mov eax, 1 ; j = 1
    mov ebx, 1 ; k = 1
    ; edx sera l

    ; Boucle principale
    mov esi, 3 ; i = 3
    jmp loop_check ; Aller directement à la vérification de la boucle

loop_start:
    ; Corps de la boucle
    ;h  add eax, ebx ; l = j + k
    ;h  mov ebx, eax ; j = k
    ;h  mov eax, ebx ; k = l

    mov edx, eax ; l = j
    add edx, ebx ; l += k
    mov eax, ebx ; j = k
    mov ebx, edx ; k = l

    ; Incrément de i
    inc esi

loop_check:
    ; Vérification de la condition de boucle
    cmp esi, ecx ; Compare i et n
    jle loop_start ; Sauter à loop_start si i <= n

    ; Retour de la fonction
    mov eax, ebx ; Résultat dans eax (k)
    popad ; Restauration des registres généraux
    pop ebp
    ret

myst ENDP

; Point d'entrée du programme principal
start:
    ; Appel de la fonction myst avec un argument
    push 5 ; Exemple d'appel avec n = 10
    call myst
    ; Récupération du résultat de la fonction depuis eax
    ; et affichage du résultat
    push ebx
    push offset format
    call crt_printf
    add esp, 8 

    ; Suite du code principal

    ; Fin du programme
    push 0
    call ExitProcess
end start