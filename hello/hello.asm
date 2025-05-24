section .data 
    message db "Hello", 10      ; create variable hello and ad new line

section .text
    global _start

_start:
    ; Write to screen 
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; send output to sdout (screen)
    mov rsi, message    ; pointa to message in memory
    mov rdx, 6          ; how meany bytes to write / send 5 letters + new line 
    syscall              ; tell CPU to do the actionl

    ; exit program
    mov rax, 60         ; syscall 60=exit
    xor rdi, rdi        ; exit code 0
    syscall
