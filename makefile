bootloader:
	nasm -f bin ./bootloader.asm -o bootloader.bin
	nasm -f elf32 ./entry.asm -o entry.o
	gcc -m32 -c ./printk.c -o printk.o
	ld ./printk.o -m elf_i386 -Ttext 0x100000 -e main -o entry.o
	objcopy -j .text -O binary entry.o rayos.bin
clean:
	sudo rm -rf ./*.o ./*.bin