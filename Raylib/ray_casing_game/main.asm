; x86_64 NASM + Raylib - Raycasting Game (Partial Assembly Version)
; 2025, AlenM666

bits 64

extern InitWindow
extern CloseWindow
extern WindowShouldClose
extern BeginDrawing
extern EndDrawing
extern ClearBackground
extern DrawCircle
extern DrawRectangle
extern SetTargetFPS
extern UpdatePlayer
extern CastRays
extern DrawMap
extern _exit

section .data
    title db "Raycasting ASM+C", 0
    screen_width  equ 960
    screen_height equ 480

section .text
    global main


main:
    ; InitWindow(width, height, title)
    mov rdi, screen_width
    mov rsi, screen_height
    mov rdx, title
    call InitWindow

    ; Set FPS
    mov rdi, 60
    call SetTargetFPS

.mainloop:
    call WindowShouldClose
    test rax, rax
    jnz .exit

    call UpdatePlayer

    call BeginDrawing
    mov rdi, 0xFF181818
    call ClearBackground

    call DrawMap
    call CastRays

    call EndDrawing
    jmp .mainloop

.exit:
    call CloseWindow
    xor rdi, rdi
    call _exit
