global _start

section .data

section .bss
    inp resb 11

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inp
    mov rdx, 11
    syscall

    mov rdi, inp
    add rdi, 10

find_digit:
    cmp rdi, inp
    jl bad_input

    cmp byte [rdi], 0x30
    jb skip_digit
    cmp byte [rdi], 0x39
    ja skip_digit
    jmp extract_digit

skip_digit:
    dec rdi
    jmp find_digit

extract_digit:
    movzx eax, byte [rdi]
    sub eax, '0'
    and eax, 1
    jnz odd

even:
    mov rax, 60
    mov rdi, 0
    syscall

odd:
    mov rax, 60
    mov rdi, 1
    syscall

bad_input:
    mov rax, 60
    mov rdi, 2
    syscall