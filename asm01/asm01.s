section .data
message db '1337', 10

section .text
global _start

_start:
    mov eax, 1
    mov edi, 1
    mov rsi, message
    mov edx, 5
    syscall

    mov eax, 60
    xor edi, edi
    syscall
