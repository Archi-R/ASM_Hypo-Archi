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
    szPath     db    'F:\Images\*',0
    phTest  db    "AAAAA",10,0
    formatString db "%s",10,0
    fullPath db 1024 dup(0)
    antislash db "\*", 0



.DATA?
; variables non-initialisees (bss)

.CODE
ItsADirectory:
    ; Sauvegarder ebp et établir un nouveau cadre de pile
    
    push ebp
    mov ebp, esp
    ;push esi
    ;le probleme c'est que c'est pas un call propre y'a
    ;pas d'adresse de retour propre
    ; Récupérer l'argument depuis la pile
    mov eax, [ebp+8] ;currently ca vise pas le bon truc


    push offset findData.cFileName ; YEET nom du dossier courant
    push eax ; YEET sur la pile
    call our_strcat ; fuuuuUUUUUUSIUOONNNNN (oe la ref DBZ tavu)
    add esp, 8 ; nettoyage de la pile car on est les boniches de l'assembleur
    ; et on recommence avec le \*


    push offset antislash
    push eax
    call our_strcat
    add esp, 8

    push eax ; on met le path sur la pile
    call r_dir ; et c'est reparti pour un tour
    ; Restaurer le cadre de pile précédent
    mov esp, ebp
    pop ebp

    ; Retourner
    ret 4

r_dir:
    push ebp ; sauvegarder la base de la pile
    mov ebp, esp ; établir un nouveau cadre de pile    
    mov ecx, [ebp+8] ; recup de  l'arg
    
    ; Find the first file
    invoke FindFirstFile, ecx, addr findData
    mov searchHandle, eax
    invoke FindNextFile, searchHandle, addr findData ; on passe . et ..

    
    ; Loop through all files
    boucle:
        invoke FindNextFile, searchHandle, addr findData ; 2e next pour chopper le premier fichier
        ; Print file name
        invoke crt_printf, addr formatString, addr findData.cFileName
        
        
        ;si on trouve un dossier on appelle la fonction
        test findData.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        ;mettre sur la pile le path
        jnz dir_founded ; la fin call our_dir

        cmp eax, 0;si ya plus de fichier
        jne boucle

        dir_founded:
            ; mise du path dans eax
            mov eax, [ebp+8]
            push eax ; on met le path sur la pile
            call ItsADirectory
        
    ; Close the search handle
    invoke FindClose, searchHandle



our_strcat:
    ; Sauvegarder les registres que nous allons utiliser
    push esi
    push edi

    ; Prendre les deux chaînes à partir de la pile
    mov esi, [esp + 12]  ; source (chaîne à ajouter)
    mov edi, [esp + 16]  ; destination (chaîne à modifier)
    ; print les parametres

     ; Trouver le caractère de fin (0x00) dans la destination
    mov ecx, 800h
    xor eax, eax
    cld
    repne scasb
    dec edi

    ; Copier la source à la fin de la destination
    mov ecx, 800h  ; Reset ecx before searching for the end of source string
    repne scasb
    not ecx
    dec ecx
    mov esi, [esp + 12]
    rep movsb

    ; Restaurer les registres et quitter
    pop edi
    pop esi
    ; print le resultat

    ret 8

start:
    push offset szPath
    call r_dir

    invoke ExitProcess, 0

end start