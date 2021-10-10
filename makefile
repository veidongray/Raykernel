build:
	nasm -f bin ./bootloader.asm -o bootloader.bin
	gcc -std=c11 -m32 -c ./kernel.c -o kernel.o
	ld -s ./kernel.o -m elf_i386 -Ttext 0x200000 -e main -o tmpk.o
	objcopy -j .text -O binary tmpk.o rayos.bin
clean:
	sudo rm -rf ./*.o ./*.bin