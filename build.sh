nasm -f bin boot.asm -o boot.bin
nasm -f bin keyboard.asm -o keyboard.bin
cat boot.bin > boot.raw
cat keyboard.bin >> boot.raw

qemu-system-i386 -fda boot.raw
