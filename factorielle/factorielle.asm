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

factojitas PROC ;code de la fonction factorielle
    push ebp
    mov ebp, esp
    pushad

    mov ecx , number
    mov eax, 0
    mov dword ptr [ebp-4], 0

    mov [ebp-4], ecx; on sauvegarde la première valeur dans
                    ; notre variable locale
    mov [ebp-8], ecx; premier resultat
    je boucle       ; puis on atteri dans la boucle récursive 

    boucle: ; recurssif

    mov ecx, [ebp-4] ; passe l'iterateur dans ecx 
    dec ecx          ; on le décrémente
    cmp ecx, 1       ; s'il vaut 1 
    je end_loop      ; on se dirige vers la fin du programme
    
    mov eax, [ebp-8] ; sinon on prends le dernier resultat
    imul eax, ecx    ; on le multiplie avec l'iterateur
    mov [ebp-8], eax ; on recupère les valeurs
    mov [ebp-4], ecx
    jmp boucle       ; on repasse dans la boucle
    
    end_loop: 
    popad
    mov eax, [ebp-4]    ; on sauvegarde le résultat dans eax

    pop ebp           ; clear de ebp
    ret 

factojitas ENDP ; fin de factojitas

start: 

    sub esp, 8 ; crée 8 octets d'espace pour stocker la valeur
               ; a calculer et le resultat

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
