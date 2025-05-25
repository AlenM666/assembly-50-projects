section .bss
    buffer resb 100         ;reserve 100 bytes for user input

section .text
    global _start

_start:
    ; read input
    mov rax, 0
    mov rdi, 0      ; file descriptor stdin
    mov rsi, buffer ; pointer to buffer
    mov rdx, 100    ; max number of bytes to read
    syscall         ; after syscall rax = number of bytes acctualy read

    mov rbx, rax    ; save number of bytes read in rax

    ; write input
    mov rax, 1
    mov rdi, 1      ; stdout
    mov rsi, buffer ; pointer to buffer
    mov rdx, rbx    ; bytes to write (from read)
    syscall

    ;exit
    mov rax, 60
    xor rdi, rdi    ;exit code 0
    syscall

