; input asm 
global get_input


section .text
get_input: 
    ; inputs :
    ; rsi = buffer adress
    ; rdx = max size
    
    mov rax, 0          ; syscall read
    mov rdi, 0          ; from stdin
    syscall
    ret

