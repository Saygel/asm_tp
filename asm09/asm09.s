section .data
    usage_msg db "Usage: ./asm09 [-b] <nombre>", 10, 0
    usage_len equ $ - usage_msg
    lf db 10

section .bss
    bin_buff resb 64
    hex_buff resb 16
    bin_sz resb 1
    hex_sz resb 1

section .text
    global _start

_start:
    pop rdi
    cmp rdi, 2
    jb err_exit
    pop rsi
    pop rsi
    mov rbx, 16
    cmp byte [rsi], '-'
    jne cont_exec
    cmp byte [rsi+1], 'b'
    jne err_exit
    cmp byte [rsi+2], 0
    jne err_exit
    pop rsi
    mov rbx, 2

cont_exec:
    xor rax, rax
    mov rdi, rsi

parse_num:
    movzx rcx, byte [rdi]
    test cl, cl
    jz choose_conv
    cmp cl, '0'
    jb err_exit
    cmp cl, '9'
    ja err_exit
    sub cl, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp parse_num

choose_conv:
    cmp rbx, 16
    je to_hex
    jmp to_bin

to_hex:
    mov rdi, hex_buff
    mov byte [hex_sz], 0

hex_loop:
    mov rdx, 0
    mov rcx, 16
    div rcx
    cmp dl, 10
    jb hex_digit
    add dl, 'A' - 10
    jmp hex_store
hex_digit:
    add dl, '0'
hex_store:
    mov [rdi], dl
    inc rdi
    inc byte [hex_sz]
    test rax, rax
    jnz hex_loop
    jmp rev_hex

to_bin:
    mov rdi, bin_buff
    mov byte [bin_sz], 0

bin_loop:
    mov rdx, 0
    mov rcx, 2
    div rcx
    add dl, '0'
    mov [rdi], dl
    inc rdi
    inc byte [bin_sz]
    test rax, rax
    jnz bin_loop
    jmp rev_bin

rev_hex:
    movzx rcx, byte [hex_sz]
    mov rsi, hex_buff
    lea rdi, [rsi+rcx-1]

rev_hex_loop:
    cmp rsi, rdi
    jge disp_hex
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp rev_hex_loop

disp_hex:
    mov rax, 1
    mov rdi, 1
    movzx rdx, byte [hex_sz]
    mov rsi, hex_buff
    syscall
    jmp clean_exit

rev_bin:
    movzx rcx, byte [bin_sz]
    mov rsi, bin_buff
    lea rdi, [rsi+rcx-1]

rev_bin_loop:
    cmp rsi, rdi
    jge disp_bin
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp rev_bin_loop

disp_bin:
    mov rax, 1
    mov rdi, 1
    movzx rdx, byte [bin_sz]
    mov rsi, bin_buff
    syscall
    jmp clean_exit

err_exit:
    mov rax, 1
    mov rdi, 1
    mov rsi, usage_msg
    mov rdx, usage_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

clean_exit:
    mov rax, 60
    xor rdi, rdi
    syscall
