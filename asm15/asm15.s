section .data
    magic_bytes db 0x7F, 'E', 'L', 'F'
    magic_size  equ 4
    usage_str   db "Usage: ./asm15 <filename>", 10
    usage_len   equ $ - usage_str

section .bss
    header_buf resb 4

section .text
    global _start

_start:
    pop rcx               ; récupérer le nombre d'arguments
    cmp rcx, 2
    jne show_usage

    pop rdi               ; ignorer le nom du programme
    pop rdi               ; obtenir le nom du fichier

    mov rax, 2            ; sys_open
    xor rsi, rsi          ; O_RDONLY
    syscall

    cmp rax, 0
    jl sys_error

    mov rdi, rax          ; le descripteur de fichier est maintenant dans RDI

    mov rax, 0            ; sys_read
    mov rsi, header_buf   ; buffer pour les 4 premiers octets
    mov rdx, magic_size
    syscall

    mov rax, 3            ; sys_close
    syscall

    mov rsi, header_buf   ; début du buffer lu
    mov rdi, magic_bytes  ; début de la signature ELF
    mov rcx, magic_size

check_magic:
    cmp byte [rsi], byte [rdi]
    jne not_elf
    inc rsi
    inc rdi
    dec rcx
    jnz check_magic

    mov rax, 60           ; sys_exit(0) si tout est correct
    xor rdi, rdi
    syscall

not_elf:
    mov rax, 60           ; sys_exit(1) sinon
    mov rdi, 1
    syscall

show_usage:
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, usage_str
    mov rdx, usage_len
    syscall
    jmp sys_error

sys_error:
    mov rax, 60
    mov rdi, 1
    syscall
