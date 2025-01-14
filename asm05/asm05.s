section .text
global _start

_start:
    mov rax, [rsp]          ; Charge le nombre d'arguments
    cmp rax, 1              ; Vérifie s'il y a au moins un argument
    jle no_argument         ; S'il n'y en a pas, termine avec code d'erreur

    mov rsi, [rsp + 16]     ; Charge l'adresse du premier argument (argv[1])
    call string_length      ; Calcule la longueur de la chaîne

    mov rdx, rax            ; Place la longueur de la chaîne dans rdx
    mov rax, 1              ; Syscall pour write
    mov rdi, 1              ; Descripteur de fichier pour stdout
    syscall                 ; Appel système pour écrire la chaîne

    xor rdi, rdi            ; Code de sortie 0
    mov rax, 60             ; Syscall pour exit
    syscall                 ; Quitte le programme

no_argument:
    mov rdi, 1              ; Code de sortie 1 si aucun argument
    mov rax, 60             ; Syscall pour exit
    syscall                 ; Quitte le programme

; Calcule la longueur de la chaîne ASCII terminée par zéro
; Entrée: rsi = adresse de la chaîne
; Sortie: rax = longueur
string_length:
    xor rax, rax            ; RAZ le compteur de longueur
find_end:
    cmp byte [rsi + rax], 0 ; Compare avec le caractère nul
    je end_found            ; Si trouvé, fin de boucle
    inc rax                 ; Sinon, incrémente le compteur
    jmp find_end            ; Répète la boucle
end_found:
    ret                     ; Retourne avec la longueur dans rax
