section .bss
    in_buf resb 128

section .data
    nl db 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, in_buf
    mov rdx, 128
    syscall

    cmp rax, 1
    jle done

    sub rax, 1
    mov rcx, rax
    mov rsi, in_buf
    mov rdi, in_buf
    add rdi, rcx
    dec rdi

rev_loop:
    cmp rsi, rdi
    jge show
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp rev_loop

show:
    mov rax, 1
    mov rdi, 1
    mov rsi, in_buf
    mov rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

done:
    mov rax, 60
    xor rdi, rdi
    syscall
