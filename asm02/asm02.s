section .bss
input resb 3              ; reserve 3 bytes for input

section .data
valid_message db '1337', 0xA

section .text
global _start

_start:
    mov eax, 0           
    mov edi, 0           
    mov rsi, input       
    mov edx, 2           
    syscall

    mov eax, 1          

    ; Compare input to "42"
    movzx edi, word [input]
    cmp edi, 0x3432      
    jne exit_failure

    ; If input is "42"
    mov edi, 1           
    mov rsi, valid_message
    mov edx, 5        
    syscall

    xor edi, edi        
    mov eax, 60          
    syscall

exit_failure:
    mov edi, 1          
    mov eax, 60         
    syscall
