section .data   
    msg db "Hello World", 0xA
    len equ $ - msg
    filename db "output.txt", 0         ; null-terminated filename
    len_f equ $ - filename
    fd dq 0                             ;file descriptor

section .text
    global _start                       ;for linker ld

_start:
    mov rdi, filename
    mov rsi, 0102o      ;O_CREAT, man open
    mov rdx, 0666o      ;umode_t
    mov rax, 2
    syscall

    mov [fd], rax
    mov rdx, len        ;message length
    mov rsi, msg    ;message to write
    mov rdi, [fd]       ;file descriptor
    mov rax, 1          ;syscall: write
    syscall

    mov rdi, [fd]
    mov rax, 3          ;sys_close
    syscall

    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall



