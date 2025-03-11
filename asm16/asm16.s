section .data
    new_text    db "H4CK"               ; Chaîne à écrire
    new_text_sz equ 4                   ; Taille de la chaîne

    usage_msg   db "Usage: ./asm16 <filename>", 10
    usage_sz    equ $ - usage_msg

section .bss
    tempBuf     resb 1024               ; Tampon inutilisé

section .text
    global _start

_start:
    pop rax                           ; Nombre d'arguments
    cmp rax, 2
    jne show_usage

    pop rdi                           ; Ignorer le nom du programme
    pop rdi                           ; Récupérer le nom du fichier

    mov rax, 2                        ; sys_open
    mov rsi, 2                        ; O_RDWR (lecture et écriture)
    mov rdx, 0                        ; Aucun flag additionnel
    syscall

    cmp rax, 0
    jl fail_exit

    mov rdi, rax                      ; Descripteur de fichier

    mov rax, 8                        ; sys_lseek
    mov rsi, 8192                     ; Offset 0x2000
    mov rdx, 0                        ; SEEK_SET
    syscall

    mov rax, 1                        ; sys_write
    mov rsi, new_text
    mov rdx, new_text_sz
    syscall

    mov rax, 3                        ; sys_close
    syscall

    mov rax, 60                       ; sys_exit (succès)
    xor rdi, rdi
    syscall

show_usage:
    mov rax, 1                        ; sys_write
    mov rdi, 1                        ; stdout
    mov rsi, usage_msg
    mov rdx, usage_sz
    syscall
    jmp fail_exit

fail_exit:
    mov rax, 60                       ; sys_exit (erreur)
    mov rdi, 1
    syscall
