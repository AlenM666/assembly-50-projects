#!/bin/bash

nasm -f elf64 read.asm -o read.o
ld read.o -o read
./read
