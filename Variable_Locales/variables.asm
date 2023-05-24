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
resultmessage db "res = %d",0

.DATA?
; variables non-initialisees (bss)

.CODE
    myst PROC
        ; Prologue de la fonction
        push ebp
        mov ebp, esp

        ; Déclaration des variables locales
        pushad ; Sauvegarde des registres généraux

        ; Variables locales
        mov ecx, [ebp+8] ; Récupère la valeur de l'argument 'n'
        add ecx, 1 ; on add 1 sinon on a un résultat au rand n-1

        ; Initialisation des variables
        mov eax, 1 ; j = 1
        mov ebx, 1 ; k = 1
        ; edx sera l

        ; Boucle principale
        mov esi, 3 ; i = 3
        jmp loop_start ; Aller directement à la vérification de la boucle

    loop_start:
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


        push eax
        push offset resultmessage
        call crt_printf
        add esp, 8 ;si on nettoir pas, le popad prends du temps

        ; Retour de la fonction
        popad ; Restauration des registres généraux
        pop ebp
        ret

    myst ENDP

    ; Point d'entrée du programme principal
    start:
        ; Appel de la fonction myst avec un argument
        push 10
        call myst

        ; Fin du programme
        push 0
        call ExitProcess
    end start
