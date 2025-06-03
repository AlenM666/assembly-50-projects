run: game
	./game

game: main.o raylib_helpers.o
	ld -o game main.o raylib_helpers.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L/usr/local/lib -lraylib -lm -lc

main.o: main.asm
	nasm -f elf64 main.asm -o main.o

raylib_helpers.o: raylib_helpers.c
	gcc -c raylib_helpers.c -o raylib_helpers.o -O2 -Wall -Wno-missing-braces

