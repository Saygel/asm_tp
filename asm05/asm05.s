section .text
global _start

_start:
    mov rax, [rsp]        
    cmp rax, 1             
    jle no_argument      


    mov rsi, [rsp + 16]    


    call string_length    

 
    mov rax, 1           
    mov rdi, 1            
    mov rdx, rax        
    syscall             


    xor rdi, rdi     
    mov rax, 60         
    syscall               

no_argument:
    mov rdi, 1             
    mov rax, 60            
    syscall                

string_length:
    xor rax, rax           
count_loop:
    cmp byte [rsi + rax], 0 
    je end_count           
    inc rax                
    jmp count_loop         
end_count:
    ret                    
