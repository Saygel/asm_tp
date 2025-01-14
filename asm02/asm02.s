section .bss
    input resb 3

section .data
    valid db '1337', 10

section .text
global _start

_start:
    mov eax, 0
    mov edi, 0
    mov rsi, input
    mov edx, 3
    syscall

    cmp dword [input], '42'
    jne wrong_input

    mov eax, 1
    mov edi, 1
    mov rsi, valid
    mov edx, 5
    syscall

    mov eax, 60
    xor edi, edi
    syscall

wrong_input:
    mov eax, 60
    mov edi, 1
    syscall
