build:
	nasm -f bin ./bootloader.asm -o bootloader.bin
	gcc -std=c11 -m32 -c ./kernel.c -o kernel.o
	ld -s ./kernel.o -m elf_i386 -Tkernel.lds -o tmpk.o
	objcopy -j .text -O binary tmpk.o rayos.bin
clean:
	rm -rf ./*.o ./*.bin
