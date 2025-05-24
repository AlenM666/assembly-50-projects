; string asm
global compare_strings


section .text
compare_strings:
    ; inputs:
    ; rsi = pointer to string 1
    ; rdi = pointer to string 2
    ; output
    ; rax = 0 if == 0 if != 1
    
next_char:
    mov al, [rsi]       ; bytes of memory pointer by the rsi register
    mov bl, [rdi]       ; bytes of memory pointer by the rsi register
    cmp al, bl          ; compare the value al and bl
    jne .not_equal      ; if not equal jump to .not_equal
    cmp al, 0           ; compare if null terminator, exit program
    je .equal           ; if equal jump to .equal
    inc rsi             ; move pointer to next character ( increment by 1) string 1
    inc rdi             ; move pointer to next character ( increment by 1) string 2  
    jmp .next_char      ; jump to next_char

.equal:
    mov rax, 0          ; syscall read
    ret                 ; ret

.not_equal: 
    mov rax, 1
    ret                 ; return
