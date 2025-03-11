section .data
msgErr db "Veuillez entrer un nombre positif", 10, 0
lenErr equ $ - msgErr
nl db 10

section .bss
buff resb 16
buffLen resb 1

section .text
global _start

_start:
    pop rdi
    cmp rdi, 2
    jne exit_error
    pop rdi
    pop rdi
    mov al, byte [rdi]
    cmp al, '-'
    je exit_error
    xor rax, rax
    mov rsi, rdi

atoi_loop:
    movzx rcx, byte [rsi]
    test cl, cl
    jz check_trans
    cmp cl, '0'
    jb exit_error
    cmp cl, '9'
    ja exit_error
    sub cl, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp atoi_loop

check_trans:
    cmp rax, 5
    je case5
    cmp rax, 10
    je case10
    cmp rax, 1
    je case1
    jmp hex_conv

case5:
    mov rax, 16
    jmp hex_conv

case10:
    mov rax, 69
    jmp hex_conv

case1:
    xor rax, rax
    jmp hex_conv

hex_conv:
    mov rsi, buff
    mov byte [buffLen], 0

conv_loop:
    mov rdx, 0
    mov rcx, 16
    div rcx
    cmp dl, 10
    jb digit_conv
    add dl, 'A' - 10
    jmp store
digit_conv:
    add dl, '0'
store:
    mov [rsi], dl
    inc rsi
    inc byte [buffLen]
    test rax, rax
    jnz conv_loop

    movzx rcx, byte [buffLen]
    mov rsi, buff
    lea rdi, [rsi+rcx-1]

rev_loop:
    cmp rsi, rdi
    jge print_out
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp rev_loop

print_out:
    mov rax, 1
    mov rdi, 1
    movzx rdx, byte [buffLen]
    mov rsi, buff
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, msgErr
    mov rdx, lenErr
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
