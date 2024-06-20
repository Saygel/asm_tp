section .data
    msg_error db "Erreur: veuillez entrer un nombre entier positif.", 0
    buffer db "Veuillez entrer un nombre: ", 0
    msg_zero db "0", 0

section .bss
    num resb 5
    output resb 20

section .text
    global _start

_start:
    
    pop rax             
    pop rsi            

    cmp rax, 2         
    je _param_provided  
    cmp rax, 1          
    je _no_param_provided 

    jmp _error          

_param_provided:
    pop rsi             
    jmp _convert_param  

_no_param_provided:
    
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer     
    mov rdx, 27         
    syscall

    
    mov rax, 0          
    mov rdi, 0          
    mov rsi, num        
    mov rdx, 5          
    syscall

    
    cmp rax, 0
    je _error           

    
    dec rax
    cmp byte [rsi+rax], 10
    jne _check_empty_input
    mov byte [rsi+rax], 0

_check_empty_input:
    cmp byte [rsi], 0
    je _error           

    mov rsi, num        

_convert_param:
    
    xor rax, rax        
    xor rcx, rcx        
    xor rdx, rdx       
    mov r9, 10         

_AtoI:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 0          
    je _done_conversion 
    sub rbx, '0'
    cmp rbx, 0
    jb _error          
    cmp rbx, 9
    ja _error           

    imul rax, r9       
    add rax, rbx       
    inc rcx            
    jmp _AtoI           

_done_conversion:
    
    cmp rax, 0
    je _print_zero     

   
    mov r11, rax       
    xor rax, rax        
    xor rcx, rcx       

_calculate_sum:
    inc rcx           
    cmp rcx, r11
    jge _done_sum       
    add rax, rcx        
    jmp _calculate_sum  

_done_sum:
    
    lea rsi, [output + 20]
    mov byte [rsi], 0
    mov rbx, 10

_convert_to_string:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz _convert_to_string

_print_result:
    
    mov rax, 1         
    mov rdi, 1         
    lea rdx, [output + 20]
    sub rdx, rsi
    mov rsi, rsi
    syscall

   
    mov rax, 60         
    xor rdi, rdi
    syscall

_print_zero:
    ;afficher zéro
    mov rax, 1          
    mov rdi, 1          
    mov rsi, msg_zero
    mov rdx, 1          
    syscall

    mov rax, 60         
    syscall

_error:
    ;sorti 1 si erreur
    mov rax, 1          
    mov rdi, 1          
    mov rsi, msg_error
    mov rdx, 48         
    syscall

    
    mov rax, 60         
    mov rdi, 1
    syscall