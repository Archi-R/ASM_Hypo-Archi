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
    szPath     db    "F:\Images\*",0
    phTest  db    "AAAAA",10,0
    formatString db "%s",10,0
    fullPath db "F:\Images\*",0
    dot db ".", 0
    dotdot db "..", 0
	strCommand db "Pause",13,10,0


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
    invoke FindNextFile, searchHandle, addr findData
    invoke FindNextFile, searchHandle, addr findData
	cmp eax, 0
	je fin
	
	
    test findData.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
    jnz ItsADirectory ; si c'est un dossier on appelle la fonction d
    ;si le dossier n'est pas . ou .. on affiche le nom du fichier
    ; sinon on affiche le nom du fichier
    invoke crt_printf, addr formatString, addr findData.cFileName
    
        
    our_next_file:
        invoke FindNextFile, searchHandle, addr findData
        cmp eax, 0
		jne testDirectory
        ; sinon c'est ciao    
        jmp fin
		
	testDirectory:
		test findData.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
		jnz ItsADirectory ; si c'est un dossier on appelle la fonction d
		jmp our_next_file


    
    ItsADirectory:
        ; Or you could append "\*" to the directory name and start a new FindFirstFile/FindNextFile loop to list its contents
        
        ;jmp our_dir currPath ;ou autre avec en input le path du nouveau dossier 
        ;currPath : le chemin que l'on veut explorer
        mov byte ptr [fullPath + 1023], 0 ; on met le dernier byte a 0
        lea eax, fullPath ; on recup le path
        push eax ; YEET sur la pile
        push offset findData.cFileName ; on met le nom du dossier sur la pile
        call our_strcat ; fuuuuUUUUUUSIUOONNNNN (oe la ref DBZ tavu)
        

        ; et on recommence avec le \*
        
        push "\\*"
        call our_strcat
        mov eax, esp ; on recup le path

        push eax ; on met le path sur la pile
        call our_dir ; et c'est reparti pour un tour
            

    fin:
        ; Close the search handle
        invoke FindClose, searchHandle

        mov esp, ebp ; nettoyer la pile
        pop ebp ; restaurer la base de la pile
        ret 4 ; nettoyer l'argument de la pile et retourner

        invoke ExitProcess, 0

; Routine strcat en assembly
our_strcat:
    push ebp              ; Save the base pointer
    mov ebp, esp          ; Set up a new stack frame

    ; Retrieve the source and destination strings from the stack
    mov esi, [ebp+8]      ; source (string to be added)
    mov edi, [ebp+12]     ; destination (string to be modified)

    ; Find the end of the destination string
    mov ecx, edi
    xor al, al            ; Set AL to null byte (0x00)
    repne scasb           ; Search for the null byte in the destination string
    dec edi               ; Decrement edi to point to the null byte

    ; Copy the source string to the end of the destination string
    call count            ; load the lenght of esi into ecx
    mov esi, [ebp+8]      ; Reset esi to point to the source string
    xor al, al            ; Set AL to null byte (0x00)
    rep movsb             ; Copy the source string to the destination string // movsb boucle un nombre de fois égal a la valeur de ecx !

    pop ebp               ; Restore the base pointer
    ret                   ; Return from the function


count: 
    mov ecx,0 ; initialisation du compteur

    loop_start: 
        mov al, [esi] ; charge la valeur de esi dans al
        cmp al, 0
        je loop_end

        inc ecx
        inc esi
        jmp loop_start

    loop_end: 
        ; on ne fait rien puisque la valeur du compteur est dans le regisre ecx
        ret
start:
    
    push offset szPath
    call our_dir
	invoke crt_system, offset strCommand

    invoke ExitProcess, 0


end start