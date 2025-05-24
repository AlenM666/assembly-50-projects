; insclude both files
%include "string.asm"
%include "input.asm"

section .bass
    username        resb 32
    password        resb 32
    temp_user       resb 32
    temp_password   resb 32


section .data
    reg_msg         db "Register your account:", 10, 0   
    user_msg        db "Username: ", 0
    pass_msg        db "Password: ", 0
    login_msg       db "Login to your account:", 10, 0
    succ_msg        db "Login successful!", 10, 0
    fail_msg        db "Login failed!", 10, 0


section .text
    global _start

_start:
    ; Print register prompt
    mov rsi, reg_msg
    call print_string

    ; Get username
    mov rsi, user_msg
    call print_string
    mov rsi, username
    mov rdx, 32
    call get_input
    call strip_newline

    ; Get password
    mov rsi, pass_msg
    call print_string
    mov rsi, password
    mov rdx, 32
    call get_input
    call strip_newline

    ; Print login prompt
    mov rsi, login_msg
    call print_string

    ; Enter username
    mov rsi, user_msg
    call print_string
    mov rsi, temp_user
    mov rdx, 32
    call get_input
    call strip_newline

    ; Enter password
    mov rsi, pass_msg
    call print_string
    mov rsi, temp_pass
    mov rdx, 32
    call get_input
    call strip_newline

    ; Compare username
    mov rsi, username
    mov rdi, temp_user
    call compare_strings
    cmp rax, 1
    je login_fail

    ; Compare password
    mov rsi, password
    mov rdi, temp_pass
    call compare_strings
    cmp rax, 1
    je login_fail

login_success:
    mov rsi, succ_msg
    call print_string
    jmp done

login_fail:
    mov rsi, fail_msg
    call print_string

done:
    mov rax, 60
    xor rdi, rdi
    syscall

; Helper: print_string
print_string:
    mov rax, 1
    mov rdi, 1
    mov rdx, 256

.next_char:
    mov al, [rsi]
    cmp al, 0
    je .done
    mov rsi, rsi
    syscall
    ret

.done:
    ret

; Helper: strip newline
strip_newline:
    mov rcx, 0

.strip_loop:
    mov al, [rsi + rcx]
    cmp al, 10
    je .found
    cmp al, 0
    je .done
    inc rcx
    jmp .strip_loop

.found:
    mov byte [rsi + rcx], 0

.done:
    ret


