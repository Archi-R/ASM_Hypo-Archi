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
    searchHandle dd 0
    findData WIN32_FIND_DATA <>
    szPath     db    "F:\Images\",0
    phTest  db    "AAAAA",10,0
    formatString db "%s\n"0

.DATA?
; variables non-initialisees (bss)

.CODE
our_dir: 
    push ebp ; sauvegarder la base de la pile
    mov ebp, esp ; établir un nouveau cadre de pile

    
    mov ecx, [ebp+8] ; recup de  l'arg
    ;test de si on est au cas de base
    cmp ecx, 1
    je cas_de_base ; si égal à 1, c'est le cas de base
    
    ;execution
    dec ecx ; on décrémente le nombre
    push ecx ; YEET ecx sur la pile
    ; allep récursif
    call our_dir ; et c'est reparti pour un tour
    ; operations
    inc ecx ; on readd 1 à ecx car on l'a dec juste au dessus pour piler les appels
    mul ecx ; on fait enfin l'opération qui finit sur eax

    ;sortie et nettoyage	
    jmp fin

    cas_de_base:
        mov eax, 1 ; on met 1 dans eax (quyi sera appelé par les appels plus profonds

    fin:
        mov esp, ebp ; nettoyer la pile
        pop ebp ; restaurer la base de la pile
        ret 4 ; nettoyer l'argument de la pile et retourner



start:
    ; Find the first file
    invoke FindFirstFile, addr szPath, addr findData
    mov searchHandle, eax
    
    ; Loop through all files
    boucle:
        ; Print file name
        invoke crt_printf, addr formatString, addr findData.cFileName

        ; Find the next file
        invoke FindNextFile, searchHandle, addr findData
        cmp eax, 0
    jne boucle

    ; Close the search handle
    invoke FindClose, searchHandle

    invoke ExitProcess, 0


end start