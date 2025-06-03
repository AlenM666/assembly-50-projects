run: game
	./game

game: game.o
	ld -o game game.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L./raylib/ -lc -lraylib -lm

game.o: game.asm
	nasm -f elf64 game.asm -o game.o
