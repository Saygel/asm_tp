global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]
    cmp rax, 3
    jl no_args

    mov rdi, [rsp+16]
    call str_to_int
    mov r8, rax

    mov rdi, [rsp+24]
    call str_to_int
    add r8, rax
    mov rdi, r8
    call int_to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx

    mov dl, [rdi]
    cmp dl, '-'
    jne parse_loop
    inc rdi
    mov rcx, 1

parse_loop:
    mov dl, [rdi]
    cmp dl, 0
    je str_done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rdi
    jmp parse_loop

str_done:
    cmp rcx, 1
    jne str_end
    neg rax

str_end:
    ret

int_to_str:
    mov rax, rdi
    mov rbx, buffer + 31
    mov byte [rbx], 10
    dec rbx

    xor rcx, rcx
    test rax, rax
    jge positive

    neg rax
    mov rcx, 1

positive:
itoa_loop:
    xor rdx, rdx
    mov r8, 10
    div r8
    add rdx, '0'
    mov [rbx], dl
    dec rbx
    test rax, rax
    jne itoa_loop

    cmp rcx, 1
    jne itoa_done
    mov byte [rbx], '-'
    dec rbx

itoa_done:
    lea rax, [rbx+1]
    ret

no_args:
    mov rax, 60
    mov rdi, 1
    syscall