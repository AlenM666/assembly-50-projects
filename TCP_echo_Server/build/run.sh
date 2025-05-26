#!/bin/bash

nasm -f elf64 ./../tcp.asm -o tcp.o
ld tcp.o -o tcp
./tcp
