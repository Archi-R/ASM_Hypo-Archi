.386
.model flat, stdcall
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\msvcrt.inc

includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\msvcrt.lib

.data
  promptMsg db "Entrez le chemin de départ : ", 0
  errorMsg db "Erreur lors de la lecture du chemin.", 0
  nl db 13, 10, 0 ; Caractères de retour à la ligne
  
.data?
  lpFolderPath db 256 dup(0) ; Variable pour stocker le chemin d'entrée
  hFind HANDLE ?
  win32fd WIN32_FIND_DATA <>
  
.code
start:
  ; Initialisation des registres et des variables
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  
  ; Affichage du message de prompt
  mov eax, STD_OUTPUT_HANDLE
  push eax
  call GetStdHandle
  add esp, 4
  
  lea ebx, promptMsg
  push ebx
  mov ecx, sizeof promptMsg
  push ecx
  push eax
  call WriteConsole
  add esp, 12
  
  ; Lecture du chemin de départ
  mov eax, STD_INPUT_HANDLE
  push eax
  call GetStdHandle
  add esp, 4
  
  lea ebx, lpFolderPath
  push ebx
  mov ecx, sizeof lpFolderPath
  push ecx
  push eax
  call ReadConsole
  add esp, 12
  
  ; Vérification des erreurs de lecture
  call check_error
  
  ; Suppression du caractère de retour à la ligne
  call remove_newline
  
  ; Listing récursif des fichiers
  call list_files
  
  ; Fin du programme
  xor eax, eax
  push eax
  call ExitProcess
  
check_error:
  ; Vérification de l'erreur de lecture du chemin
  cmp eax, 0
  jne check_error_end
  
  ; Affichage du message d'erreur
  mov eax, STD_OUTPUT_HANDLE
  push eax
  call GetStdHandle
  add esp, 4
  
  lea ebx, errorMsg
  push ebx
  mov ecx, sizeof errorMsg
  push ecx
  push eax
  call WriteConsole
  add esp, 12
  
  ; Fin du programme
  mov eax, 1
  push eax
  call ExitProcess
  
check_error_end:
  ret
  
remove_newline:
  ; Recherche du caractère de retour à la ligne
  mov ecx, sizeof lpFolderPath
  lea ebx, lpFolderPath
  dec ecx
  repne scasb ; Recherche du caractère null
  
  ; Remplacement du caractère de retour à la ligne par un caractère nul
  mov byte ptr [ebx - 2], 0
  
  ret
  
list_files:
  ; Construction du masque de recherche en concaténant le chemin d'entrée avec "*.*"
  lea ebx, lpFolderPath
  add ebx, eax
  mov byte ptr [ebx], '*'
  mov byte ptr [ebx + 1], '.'
  mov byte ptr [ebx + 2], '*'
  mov byte ptr [ebx + 3], 0
  
  ; Appel à la fonction FindFirstFile pour obtenir la première entrée
  push offset win32fd
  push ebx
  call FindFirstFile
  mov hFind, eax
  
  ; Vérification de l'erreur de recherche
  cmp eax, INVALID_HANDLE_VALUE
  je close_find_handle
  
loop_find_next_file:
  ; Vérification du type d'entrée
  test win32fd.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY
  jz is_file
  
is_directory:
  ; Construction du nouveau chemin en ajoutant le nom du répertoire à la fin du chemin d'entrée
  lea ebx, lpFolderPath
  add ebx, eax
  push ebx ; Sauvegarde du nouveau chemin sur la pile
  
  ; Appel récursif de list_files avec le nouveau chemin
  call list_files
  
  ; Nettoyage de la pile après l'appel récursif
  add esp, 4
  
  jmp find_next_file ; Sauter à find_next_file pour traiter la prochaine entrée
  
is_file:
  ; Affichage du nom du fichier à l'écran
  push STD_OUTPUT_HANDLE
  call GetStdHandle
  mov ebx, eax
  
  push ebx ; Handle de sortie
  push offset win32fd.cFileName ; Pointeur vers le nom du fichier
  push sizeof win32fd.cFileName ; Taille du nom du fichier
  push ecx ; Nombre d'octets écrits (ignoré)
  push ecx ; Attributs (ignorés)
  call WriteConsole
  
find_next_file:
  ; Recherche de l'entrée suivante
  push offset win32fd
  push hFind
  call FindNextFile
  test eax, eax
  jnz loop_find_next_file ; Si une autre entrée est trouvée, sauter à loop_find_next_file
  
close_find_handle:
  ; Fermeture du handle de recherche
  push hFind
  call FindClose
  
  ret

end start
