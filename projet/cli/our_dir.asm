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
    dot db ".", 0
    dotdot db "..", 0
    tes db "here", 0



.DATA?
; variables non-initialisees (bss)

.CODE
our_dir: 
    push ebp ; sauvegarder la base de la pile
    mov ebp, esp ; établir un nouveau cadre de pile

    
    mov ecx, [ebp+8] ; recup de  l'arg
    
    ; Find the first file
    invoke FindFirstFile, ecx, addr findData
    mov searchHandle, eax
    ; Print file name
    

    test findData.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
    jnz ItsADirectory ; si c'est un dossier on appelle la fonction d
    ;si le dossier n'est pas . ou .. on affiche le nom du fichier
    ; sinon on affiche le nom du fichier
    invoke crt_printf, addr formatString, addr findData.cFileName
    
        
    our_next_file:
        invoke FindNextFile, searchHandle, addr findData
        cmp eax, 0
        jne our_dir ; appel récursif
        ; sinon c'est ciao    
        jmp fin

    
    ItsADirectory:
        ; Or you could append "\*" to the directory name and start a new FindFirstFile/FindNextFile loop to list its contents
        
        ;jmp our_dir currPath ;ou autre avec en input le path du nouveau dossier 
        ;currPath : le chemin que l'on veut explorer

        lea eax, fullPath ; on recup le path
        push eax ; YEET sur la pile
        push offset findData.cFileName; YEET nom du dossier courant
        call our_strcat ; fuuuuUUUUUUSIUOONNNNN (oe la ref DBZ tavu)
        add esp, 8 ; nettoyage de la pile car on est les boniches de l'assembleur
        ; et on recommence avec le \*

        push eax
        push "\*"
        call our_strcat
        add esp, 8

        push eax
        push 0h
        call our_strcat
        add esp, 8

        push eax ; on met le path sur la pile
        call r_dir ; et c'est reparti pour un tour
            
    fin:
        ; Close the search handle
        invoke FindClose, searchHandle

        mov esp, ebp ; nettoyer la pile
        pop ebp ; restaurer la base de la pile
        ret 4 ; nettoyer l'argument de la pile et retourner

        invoke ExitProcess, 0

; Routine strcat en assembly

r_dir:
    ; Find the first file
    invoke FindFirstFile, addr szPath, addr findData
    invoke FindNextFile, searchHandle, addr findData ; on passe . et ..
    mov searchHandle, eax
    
    ; Loop through all files
    boucle:
        ; Print file name
        invoke crt_printf, addr formatString, addr findData.cFileName
        ; Find the next file
        invoke FindNextFile, searchHandle, addr findData
        ;si on trouve un dossier on appelle la fonction
        test findData.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
        jnz ItsADirectory ; la fin call our_dir


        cmp eax, 0;si ya plus de fichier
        jne boucle

    ; Close the search handle
    invoke FindClose, searchHandle




our_strcat:
    ; Sauvegarder les registres que nous allons utiliser
    push esi
    push edi

    ; Prendre les deux chaînes à partir de la pile
    mov esi, [esp + 12]  ; source (chaîne à ajouter)
    mov edi, [esp + 16]  ; destination (chaîne à modifier)

    ; Trouver le caractère de fin (0x00) dans la destination
    xor eax, eax
    not eax
    cld
    repne scasb
    dec edi

    ; Copier la source à la fin de la destination
    xor ecx, ecx
    not ecx
    repne scasb
    not ecx
    dec ecx
    mov esi, [esp + 12]
    rep movsb

    ; Restaurer les registres et quitter
    pop edi
    pop esi
    ret 8

start:
    push offset szPath
    call r_dir

    
    invoke ExitProcess, 0


end start