section .text
global _start

_start:
    ; Vérifier si au moins un argument a été passé
    mov rax, [rsp]          ; nombre d'arguments dans argc
    cmp rax, 1              ; argc doit être > 1 pour avoir au moins un argument
    jle no_argument         ; sauter si aucun argument n'est passé

    ; Préparer l'appel système write pour afficher l'argument
    mov rax, 1              ; syscall number for write
    mov rdi, 1              ; file descriptor 1 (stdout)
    mov rsi, [rsp + 16]     ; adresse du premier argument (argv[1])
    mov rdx, [rsp + 24]     ; taille du premier argument (argv[1] length)
    syscall                 ; effectuer l'appel système

    ; Terminer le programme avec le code de retour 0
    xor rdi, rdi            ; code de retour 0
    mov rax, 60             ; syscall number for exit
    syscall                 ; effectuer l'appel système

no_argument:
    ; Terminer le programme avec le code de retour 1 s'il n'y a pas d'argument
    mov rdi, 1              ; code de retour 1
    mov rax, 60             ; syscall number for exit
    syscall                 ; effectuer l'appel système
