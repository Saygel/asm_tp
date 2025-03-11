
section .data
    out_msg db "Hello Universe!", 10
    out_size equ $ - out_msg
    err_str db "Usage: ./asm14 <filename>", 10
    err_size equ $ - err_str

section .bss
    fileName resb 128

section .text
    global _start

_start:
    pop rax              ; Récupérer le nombre d'arguments
    cmp rax, 2
    jne usage_error
    pop rax              ; Ignorer le nom du programme
    pop rdi              ; Charger le nom du fichier

    mov rax, 2           ; sys_open
    mov rsi, 0x241       ; Flags: O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, 0o644       ; Mode: rw-r--r--
    syscall

    cmp rax, 0
    jl exit_fail

    mov rdi, rax         ; Utiliser le descripteur de fichier obtenu
    mov rax, 1           ; sys_write
    mov rsi, out_msg
    mov rdx, out_size
    syscall

    mov rax, 3           ; sys_close
    syscall

    mov rax, 60          ; sys_exit (succès)
    xor rdi, rdi
    syscall

usage_error:
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, err_str
    mov rdx, err_size
    syscall
    jmp exit_fail

exit_fail:
    mov rax, 60          ; sys_exit (erreur)
    mov rdi, 1
    syscall
