global _start

section .data
    nombre db '1337', 0x0A

section .text

_start:
 
    mov rdi, [rsp]
    cmp rdi, 1
    je nothing

   
    mov rsi, [rsp + 16]

 
    mov al, [rsi]
    cmp al, 0x34
    jne no42

  
    mov al, [rsi + 1]
    cmp al, 0x32
    jne no42

    
    mov al, [rsi + 2]
    cmp al, 0x00
    jne no42

   
    mov rax, 1
    mov rdi, 1
    mov rsi, nombre
    mov rdx, 5
    syscall


    mov rax, 60
    mov rdi, 0
    syscall

no42:
    mov rax, 60
    mov rdi, 1
    syscall

nothing:
    mov rax, 60
    mov rdi, 1
    syscall