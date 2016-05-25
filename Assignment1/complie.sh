#!/bin/bash

echo '[+] Assembling with asm ... '
nasm -f elf32 -o $1.o $1.asm

echo '[+] Linking ...'
ld -m elf_i386 -o $1 $1.o

echo '[+] Done!'