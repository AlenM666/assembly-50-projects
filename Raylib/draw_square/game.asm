;
;   Moving Square in x86_64 assembly using Raylib
;
;   2025, AlenM666
;

bits 64

extern GetRandomValue
extern InitWindow
extern SetTargetFPS
extern WindowShouldClose
extern IsKeyDown
extern IsKeyPressed
extern BeginDrawing
extern ClearBackground
extern DrawText
extern DrawRectangle
extern EndDrawing
extern CloseWindow
extern printf
extern _exit


section .data
    win_title	db "snake!",0
    ; red_color   dd 0xFF0000FF
    red_color dd 0xFF2891CC


section .text
    global _start

_start:
    ;InitWindow(int width, int height, const char *title) 
    mov rdi, 800
    mov rsi, 600
    mov rdx, win_title
    call InitWindow
    
.again:
    call WindowShouldClose
    test rax, rax
    jnz .over
    call BeginDrawing

    

    mov rdi, 0xFF181818
    call ClearBackground

    ;DrawRectangle(int posX, int posY, int width, int height, Color color)
    mov rdi, 0
    mov rsi, 0
    mov rdx, 100
    mov rcx, 100
    ; mov r8, 0xFF0000FF
    mov r8, [red_color]
    call DrawRectangle


    call EndDrawing
    jmp .again

.over:
    call CloseWindow
    mov rdi, 0
    call _exit

