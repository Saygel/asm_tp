section .bss
    inBuf resb 128

section .data
    vowStr db "aeiouyAEIOUY", 0
    nl db 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inBuf
    mov rdx, 128
    syscall

    cmp rax, 1
    jle noData

    xor rcx, rcx
    mov rsi, inBuf

vCount:
    movzx rax, byte [rsi]
    test al, al
    jz printRes
    push rsi
    mov rdi, vowStr

vCheck:
    movzx rdx, byte [rdi]
    test dl, dl
    jz nextChar
    cmp al, dl
    je addOne
    inc rdi
    jmp vCheck

addOne:
    inc rcx

nextChar:
    pop rsi
    inc rsi
    jmp vCount

noData:
    xor rcx, rcx

printRes:
    mov rax, rcx
    mov rsi, inBuf
    call convInt

    mov rdx, rsi
    sub rdx, inBuf
    mov rax, 1
    mov rdi, 1
    mov rsi, inBuf
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    jmp endProg

endProg:
    mov rax, 60
    xor rdi, rdi
    syscall

convInt:
    mov rbx, 0
    test rax, rax
    jns convLoop

convLoop:
    mov rdx, 0
    mov rcx, 10
    div rcx
    add dl, '0'
    push rdx
    inc rbx
    test rax, rax
    jnz convLoop

convPop:
    pop rax
    mov [rsi], al
    inc rsi
    dec rbx
    jnz convPop
    ret
