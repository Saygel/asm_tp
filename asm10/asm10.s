section .data
    usageMsg db "Usage: ./asm10 <num1> <num2> <num3>", 10, 0
    usageSize equ $ - usageMsg
    lf db 10

section .bss
    outBuffer resb 16

section .text
    global _start

_start:
    pop rdi
    cmp rdi, 4
    jne errExit
    pop rsi
    pop rsi
    call myAtoi
    mov r8, rax
    pop rsi
    call myAtoi
    mov r9, rax
    pop rsi
    call myAtoi
    mov r10, rax
    mov rax, r8
    cmp r9, rax
    cmovg rax, r9
    cmp r10, rax
    cmovg rax, r10
    mov rsi, outBuffer
    call myItoa
    mov rdx, rsi
    sub rdx, outBuffer
    mov rax, 1
    mov rdi, 1
    mov rsi, outBuffer
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, lf
    mov rdx, 1
    syscall
    jmp exitProg

errExit:
    mov rax, 1
    mov rdi, 1
    mov rsi, usageMsg
    mov rdx, usageSize
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

exitProg:
    mov rax, 60
    xor rdi, rdi
    syscall

myAtoi:
    xor rax, rax
    mov rbx, 1
    movzx rdx, byte [rsi]
    cmp dl, '-'
    jne atoiLoop
    mov rbx, -1
    inc rsi
atoiLoop:
    movzx rdx, byte [rsi]
    test dl, dl
    jz atoiEnd
    cmp dl, '0'
    jb errExit
    cmp dl, '9'
    ja errExit
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp atoiLoop
atoiEnd:
    imul rax, rbx
    ret

myItoa:
    mov rbx, 0
    test rax, rax
    jns itoaProc
    mov byte [rsi], '-'
    inc rsi
    neg rax
itoaProc:
    mov rdx, 0
    mov rcx, 10
    div rcx
    add dl, '0'
    push rdx
    inc rbx
    test rax, rax
    jnz itoaProc
itoaPop:
    pop rax
    mov [rsi], al
    inc rsi
    dec rbx
    jnz itoaPop
    ret
