section .bss
    inputArea resb 128

section .data
    endLine db 10

section .text
    global _start

_start:
    ; Lire depuis STDIN dans inputArea
    mov rax, 0
    mov rdi, 0
    mov rsi, inputArea
    mov rdx, 128
    syscall

    ; Si aucun caractère (ou juste un retour chariot), considérer comme palindrome
    cmp rax, 1
    jle finish

    dec rax                 ; Exclure le '\n'
    mov rcx, rax            ; Taille effective de la chaîne
    mov rbx, inputArea      ; Pointeur début chaîne
    lea rdx, [inputArea + rcx - 1]  ; Pointeur fin chaîne

check_chars:
    cmp rbx, rdx
    jge valid_palindrome    ; Tous les caractères vérifiés
    mov al, [rbx]
    mov bl, [rdx]
    cmp al, bl
    jne invalid_palindrome  ; Caractères différents

    inc rbx
    dec rdx
    jmp check_chars

valid_palindrome:
    mov rax, 60           ; sys_exit(0)
    xor rdi, rdi
    syscall

invalid_palindrome:
    mov rax, 60           ; sys_exit(1)
    mov rdi, 1
    syscall

finish:
    mov rax, 60
    xor rdi, rdi
    syscall
