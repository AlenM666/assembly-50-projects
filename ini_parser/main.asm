section .data
    filename db 'config.ini', 0
    newline db 10, 0
    equals_msg db 'Found value: ', 0
    
    ; Storage for extracted values
    username_value times 64 db 0
    timeout_value times 16 db 0

section .bss
    file_buffer resb 1024
    file_descriptor resd 1
    bytes_read resd 1

section .text
    global _start

_start:
    ; Open file
    mov rax, 2          ; sys_open
    mov rdi, filename   ; filename
    mov rsi, 0          ; O_RDONLY
    mov rdx, 0          ; mode (not needed for read)
    syscall
    
    cmp rax, 0
    jl exit_error       ; Jump if file open failed
    mov [file_descriptor], eax
    
    ; Read file content
    mov rax, 0          ; sys_read
    mov rdi, [file_descriptor]
    mov rsi, file_buffer
    mov rdx, 1024       ; max bytes to read
    syscall
    
    mov [bytes_read], eax
    
    ; Close file
    mov rax, 3          ; sys_close
    mov rdi, [file_descriptor]
    syscall
    
    ; Parse the file content
    call parse_ini
    
    ; Print extracted values for demonstration
    call print_values
    
    ; Exit successfully
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; exit code
    syscall

exit_error:
    mov rax, 60         ; sys_exit
    mov rdi, 1          ; exit code (error)
    syscall

parse_ini:
    push rbp
    mov rbp, rsp
    
    mov rsi, file_buffer    ; Source pointer
    mov rcx, [bytes_read]   ; Number of bytes to process
    
parse_loop:
    cmp rcx, 0
    je parse_done
    
    ; Check for 'username=' line
    mov rdi, rsi
    mov rdx, username_key
    call check_key
    cmp rax, 1
    je found_username
    
    ; Check for 'timeout=' line
    mov rdi, rsi
    mov rdx, timeout_key
    call check_key
    cmp rax, 1
    je found_timeout
    
    ; Move to next character
    inc rsi
    dec rcx
    jmp parse_loop

found_username:
    ; Extract value after 'username='
    add rsi, 9          ; Skip 'username='
    mov rdi, username_value
    call extract_value
    jmp continue_parse

found_timeout:
    ; Extract value after 'timeout='
    add rsi, 8          ; Skip 'timeout='
    mov rdi, timeout_value
    call extract_value
    jmp continue_parse

continue_parse:
    ; Find next newline
    call skip_to_newline
    jmp parse_loop

parse_done:
    pop rbp
    ret

; Check if current position matches a key
; rdi = current position, rdx = key to check
; Returns: rax = 1 if match, 0 if no match
check_key:
    push rsi
    push rcx
    push rdi
    push rdx
    
    mov rsi, rdi        ; Current position
    mov rdi, rdx        ; Key to check
    
check_loop:
    mov al, [rdi]       ; Load char from key
    cmp al, 0           ; End of key?
    je key_match
    
    mov bl, [rsi]       ; Load char from buffer
    cmp al, bl          ; Compare characters
    jne key_no_match
    
    inc rdi
    inc rsi
    jmp check_loop

key_match:
    mov rax, 1
    jmp check_end

key_no_match:
    mov rax, 0

check_end:
    pop rdx
    pop rdi
    pop rcx
    pop rsi
    ret

; Extract value until newline or end of buffer
; rsi = source position, rdi = destination buffer
extract_value:
    push rax
    push rbx
    
extract_loop:
    mov al, [rsi]       ; Load character
    cmp al, 10          ; Check for newline
    je extract_done
    cmp al, 13          ; Check for carriage return
    je extract_done
    cmp al, 0           ; Check for null terminator
    je extract_done
    
    mov [rdi], al       ; Store character
    inc rsi
    inc rdi
    jmp extract_loop

extract_done:
    mov byte [rdi], 0   ; Null terminate
    pop rbx
    pop rax
    ret

; Skip to next newline
skip_to_newline:
    push rax
    
skip_loop:
    mov al, [rsi]
    cmp al, 10          ; newline
    je skip_done
    cmp al, 0           ; end of buffer
    je skip_done
    inc rsi
    dec rcx
    cmp rcx, 0
    je skip_done
    jmp skip_loop

skip_done:
    inc rsi             ; Move past newline
    dec rcx
    pop rax
    ret

; Print extracted values (for demonstration)
print_values:
    ; Print "Username: "
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, username_msg
    mov rdx, 10         ; length
    syscall
    
    ; Print username value
    mov rdi, username_value
    call print_string
    
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Print "Timeout: "
    mov rax, 1
    mov rdi, 1
    mov rsi, timeout_msg
    mov rdx, 9
    syscall
    
    ; Print timeout value
    mov rdi, timeout_value
    call print_string
    
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ret

; Print null-terminated string
; rdi = string address
print_string:
    push rax
    push rsi
    push rdx
    push rcx
    
    mov rsi, rdi        ; String address
    mov rcx, 0          ; Length counter
    
    ; Calculate string length
strlen_loop:
    mov al, [rsi + rcx]
    cmp al, 0
    je strlen_done
    inc rcx
    jmp strlen_loop

strlen_done:
    ; Print the string
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    ; rsi already points to string
    mov rdx, rcx        ; length
    syscall
    
    pop rcx
    pop rdx
    pop rsi
    pop rax
    ret

section .rodata
    username_key db 'username=', 0
    timeout_key db 'timeout=', 0
    username_msg db 'Username: ', 0
    timeout_msg db 'Timeout: ', 0
