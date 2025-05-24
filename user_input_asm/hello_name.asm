section .bss
	name resb 32					; reserve 32 bytes for user input

section .data
	prompt db "Enter your name: ", 0xA		; message + new line
	hello db "hello, ", 0				; null terminator (0) used later

section .text
	global _start

_start:
	; print enter your name
	mov rax, 1 		; syscall number 1 = write
	mov rdi, 1		; were to write 1=screen
	mov rsi, prompt		; pointer to message
	mov rdx, 18		; message length bytes
	syscall

	
	; read intpu form keyboard 
	mov rax, 0		; syscall number 0=read
	mov rdi, 0		; 0 = stdin
	mov rsi, name		; where to store input
	mov rdx, 32		; max number of bytes to read
	syscall
	; result now in rax

	
	; print hello
	mov rax, 1		; syscall write
	mov rdi, 1		; stdout
	mov rsi, hello 		; pointer to "hello, "
	mov rdx, 7		; lenght of "hello, "
	syscall 

	
	; print the users name
	mov rax, 1		; write 
	mov rdi, 1		; to screen
	mov rsi, name		; name is stored here
	mov rdx, 32		; max 32 bytes and new line
	syscall
	
	; exit
	mov rax, 60		; syscall exit
	mov rdi, rdi		; return code 0
	syscall
