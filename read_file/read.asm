section .data   
    filename db "output.txt", 0
    buffer db 0 dup(256)      ;buffer to read data into
    bytes_r dq 0                ;store the number of bytes read

section .text
    global _start                       ;for linker ld

_start:
    ;open file
    mov rax, 2
    mov rdi, filename   ;pointer to file
    mov rsi, 0          ; flag for open readonly
    mov rdx, 0          ; premmission read only not needed
    syscall
    cmp rax, 0          ; check if open succes
    jl error_open       ;jump to label error_open

    mov [fd], rax       ;store the file discriptor


;---read from file
read_loop:
    mov rax, 0          ;sys_read
    mov rdi,[fd]        ;file descriptor
    mov rsi, buffer     ;pointer to buffer
    mov rdx, 255        ;number of bytes to read
    syscall
    cmp rax, 0          ;check if endfile or error
    jl end_read

    ;print the read data to stdout
    mov rsi, buffer
    mov rdx, rax        ;number of bytes read in rax
    mov rdi, 1          ;stdout
    mov rax, 1          ;sys_read
    syscall
    jmp read_loop       ;jump to read_loop

end_read:
    ;close the file
    mov rax, 3
    mov rdi, [fd]       ;file descriptor
    syscall

    ;exit 
    mov rax, 60
    xor rdi, rdi        ;exit code 0
    syscall

error_open:
    ;handle error if file could not open
    mov rax, 60
    mov rdi, 1          ;error code
    syscall


section .bss
    fd resq 1           ;reserve 8 bytes for file discriptor
