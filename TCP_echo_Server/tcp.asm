section .data
	;socket addres sructure for IPv4
	sockaddr:
        dw 2            ;AF_INET (family)
        dw 0x2823       ;port 9000
        dd 0            ;INADDR_ANY (0.0.0.0)
        times 8 db 0    ;padding

    ;Message
    server_start_msg db "TCP Echo Server started on port 9000", 10, 0
    server_start_len equ $ - server_start_msg -1

    waiting_msg db "Waiting for connection...", 10, 0
    waiting_len equ $ - waiting_msg -1

    client_connected_msg db "Connected to CLient...", 10, 0
    client_connected_len equ $ - client_connected_msg -1

    client_disconected_msg db "Client disconected...", 10 ,0
    client_disconected_len equ $ - client_disconected_msg -1


section .bss
    sockfd resq 1           ;server socket file descriptor
    clientfd resq 1         ;client socket file descriptor
    buffer resb 1024        ;buffer for recived data

section .text
    global _start

_start:
    ;print server message
    mov rax, 1              ;write
    mov rdi, 1              ;stdout
    mov rsi, server_start_msg
    mov rdx, server_start_len
    syscall

    ;create socket: socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41             ;sys_socket
    mov rdi, 2              ;AF_INET
    mov rsi, 1              ;SOCK_STREAM
    mov rdx, 0              ;protocol default 0
    syscall

    cmp rax, 0
    jl error_exit
    mov [sockfd], rax       ;save socket fd

    ;set SO_REUSEADDR options to allow immediate reuse of prot
    mov rax, 54             ;sys_setsockopt
    mov rdi, [sockfd]       ;socket fd
    mov rsi, 1              ;SOL_SOCKET
    mov rdx, 2              ;SO_REUSEADDR
    mov r10, rsp            ;point to stack (1 now)
    push 1                  ;value=1
    mov r8, 4               ;option length
    syscall
    add rsp, 8              ;clean up stack

    ;Bind socket: bind(sockfd, &sockaddr, sizeof(sockaddr))
    mov rax, 49             ;sys_bind
    mov rdi, [sockfd]
    mov rsi, sockaddr       
    mov rdx, 16             ;sizeof(sockaddr_in)
    syscall

    cmp rax, 0
    jl error_exit

    ;Listen listen(sockfd, 1)
    mov rax, 50             ;sys_listen
    mov rdi, [sockfd]
    mov rsi, 1              ;backlog
    syscall

    cmp rax, 0
    jl error_exit

    ;print waiting message
    mov rax, 1              ;sys_write
    mov rdi, 1              ;stdout
    mov rsi, waiting_msg    ;pointer to waiting_msg
    mov rdx, waiting_len
    syscall

wait_for_client:
    ;Accept connection: accept(sockfd, NULL, NULL)
    mov rax, 43             ;sys_accept
    mov rdi, [sockfd]
    mov rsi, 0              ;dont need client adress
    mov rdx, 0              ;dont need addr length
    syscall

    cmp rax, 0
    jl error_exit
    mov [clientfd], rax     ;save client socket fd

    ;print cliant waiting message
    mov rax, 1              ;sys_write
    mov rdi, 1              ;stdout
    mov rsi, [waiting_msg]
    mov rdx, waiting_len
    syscall

echo_loop:
    ;Recive data: recv(clientfd, buffer, 1024, 0)
    mov rax, 0              ;sys_read
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, 1024
    syscall

    cmp rax, 0
    jl client_disconnected

    mov r12, rax            ;ssave number of bytes recived

    ;send data back: send(clientfd, buffer, bytes_recived, 0)
    mov rax, 1              ;sys_write
    mov rdi, [clientfd]
    mov rsi, buffer
    mov rdx, r12            ;was saved in r12 number of bytes to send
    syscall

    cmp rax, 0
    jl client_disconnected

    jmp echo_loop           ;continue echoing

client_disconnected:
    ;close client socket
    mov rax, 3              ;sys_close
    mov rdi, [clientfd]
    syscall

    ;print cliinet message
    mov rax, 1              ;sys_write
    mov rdi, 1              ;stdout
    mov rsi, client_disconected_msg
    mov rdx, client_disconected_len
    syscall

    ;wait for another client
    jmp wait_for_client

error_exit:
    ;close server socket if it was created
    cmp qword [sockfd],0
    je exit_program
    mov rax, 3              ;sys_close
    mov rdi, [sockfd]
    syscall

exit_program:
    ;exit program
    mov rax, 60         ;sys_exit
    mov rdi, 1          ;exit code 
    syscall




