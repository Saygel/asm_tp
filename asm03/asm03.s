section .data
valid db '1337', 10

section .text
global _start

_start:
    mov rdi, [rsp+8]          ; adresse du premier argument argv[1]
    cmp dword [rdi], '42'     ; comparer à '42'
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