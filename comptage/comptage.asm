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
mot db "abracadabarbarbabararafat",0

phrase db "nombre de a : %d, nombre de b : %d, nombre de c : %d",10,0

.DATA?
; variables non-initialisees (bss)

.CODE
;code

countletters PROC
    push ebp
    mov ebp, esp
    pushad

    ; Maintenant il faut utiliser
    ;[ebp-4], [ebp-8], [ebp-12] comme variables locales

    ; initialisation des 3 compteurs à 0
    mov eax, 0
    MOV DWORD PTR [ebp-4], 0
    MOV DWORD PTR [ebp-8], 0
    MOV DWORD PTR [ebp-12], 0

    mov esi, [ebp+8] ; on met le pointeur sur le mot dans eax

loop_start: 
    mov al, [esi]
    or al, al ; vérifie si al est égal à la fin de la chaîne
	jz loop_end			; si oui, alors on quitte
    
    cmp al, 'a'
    je increment_a
    cmp al, 'b'
    je increment_b
    cmp al, 'c'
    je increment_c

    inc esi ; on passe au caractère suivant
    jmp loop_start ; retour a la boucle principale

loop_end:
    popad ; clear les registres
    mov eax, [ebp-4] ; on met le nombre de a dans eax
    mov ebx, [ebp-8] ; on met le nombre de b dans ebx
    mov ecx, [ebp-12] ; on met le nombre de c dans esi
    
    pop ebp ; clear de ebp 
    
    ret ; return

increment_a:

    mov eax, [ebp-4] ; charger la valeur de ebp-4 dans eax
    inc eax ; incrementer eax
    mov [ebp-4], eax ; stocker la nouvelle valeur de eax à ebp-4
    inc esi
    jmp loop_start ; retour a la boucle principale

increment_b:

    mov eax, [ebp-8] ; charger la valeur de ebp-8 dans ebx
    inc eax ; incrementer ebx
    mov [ebp-8], eax ; stocker la nouvelle valeur de ebx à ebp-8
    inc esi
    jmp loop_start

increment_c:

    mov eax, [ebp-12] ; charger la valeur de ebp-12 dans ecx
    inc eax ; incrementer ecx
    mov [ebp-12], eax ; stocker la nouvelle valeur de ecx à ebp-12
    inc esi
    jmp loop_start

countletters ENDP


start:
    ; Créer de l'espace pour les variables locales
    sub esp, 12     ; Crée 12 octets d'espace (3 variables de 4 octets)

    ; Maintenant il faut utiliser
    ;[ebp-4], [ebp-8], [ebp-12] comme variables locales

    push offset mot

    call countletters
   
    ; affichage du nombre de a, b et c
    push ecx
    push ebx
    push eax
    push offset phrase
    call crt_printf
    add esp, 16

    push 0
    call ExitProcess

end start
