global _start

section .data
nombre dd '1337',0

section .bss
inp resb 3

section .text

_start:
mov eax, 0
mov edi, 0
mov rsi, inp
mov edx, 3
syscall


mov al, [inp]
cmp al, 0x34
jne not_equal


mov al, [inp + 1]
cmp al, 0x32
jne not_equal


mov al, [inp + 2]
cmp al, 0x0A
jne not_equal


mov rax, 1
mov rdi, 1
mov rsi, nombre
mov rdx, 4
syscall

mov rax, 60
mov rdi, 0
syscall

not_equal:
mov rax, 60
mov rdi, 1
syscall