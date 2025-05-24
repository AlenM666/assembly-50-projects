#!/bin/bash

nasm -f elf64 ./hello_name.asm -o hello_name.o
ld hello_name.o -o hello_name
./hello_name
