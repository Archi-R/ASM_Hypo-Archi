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


.DATA?
; variables non-initialisees (bss)

.CODE
;code

diviseur PROC
    push ebp
    mov ebp, esp
    pushad

    mov ecx, [ebp+8] ; on met le pointeur sur le nombre dans ecx
    ; save de eax
    push eax
    mov eax, 0
    loop_increment:

    
    MOV EAX, dividend ; mettez le dividende dans EAX
    MOV ECX, divisor ; mettez le diviseur dans ECX
    XOR EDX, EDX ; videz EDX (nécessaire car DIV divise le nombre 64 bits dans EDX:EAX par le diviseur)
    DIV ECX ; divisez EAX par ECX, le quotient est stocké dans EAX, le reste dans EDX


    ;restauration de eax
    pop eax
    

    est_divisible:

    non_divisible:

diviseur ENDP


start: 
    
    ; obtenir un handle sur l'entrée standard
    push -10 ; STD_INPUT_HANDLE
    call GetStdHandle
    mov ebx, eax ; sauvegarde le handle dans ebx

    ; appelle ReadConsoleA pour lire l'entrée de l'utilisateur
    push 0 ; lpNumberOfCharsRead, inutile ici
    push 256 ; nNumberOfCharsToRead, taille du buffer
    push offset buffer ; lpBuffer, pointe vers notre buffer
    push ebx ; hConsoleInput, handle sur l'entrée standard
    call ReadConsoleA

    ; ... ici vous pouvez manipuler les données entrées par l'utilisateur dans 'buffer'

    ; terminer le programme


    push 0
    call ExitProcess
end start
