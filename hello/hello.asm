section .data 
    message db "Hello World", 10  ; 10 = newline \n
    msg_len equ $-message   ; calculate message length

section .text
    global _start

_start:
    mov rax, 1     
    mov rdi, 1          ;file descriptor stdout
    mov rsi, message    ;pointer to message
    mov rdx, msg_len    ;msg length
    syscall

    ;exit
    mov rax, 60
    xor rdi, rdi        ;exit code 0
    syscall



