#BOOTFOUT=bootloader.bin
#KERNELFILES=./kernel.c
#OBJFILES=./kernel.o ./liba.o
#LDOUT=kernel.bin
#OCOUT=rayos.bin

#build:
#	nasm -f bin ./bootloader.asm -o ${BOOTFOUT}
#	nasm -f elf32 ./liba.asm -o liba.o
#	gcc -m32 -c ${KERNELFILES}
#	ld -m elf_i386 -Ttext 0x100000 -e _start ${OBJFILES} -o kernel.bin
#	objcopy -j .text -O binary ${LDOUT} ${OCOUT}
#clean:
#	sudo rm -rf ${BOOTFOUT} ./*.bin ./*.o
bootloader:
	nasm -f bin ./bootloader.asm -o bootloader.bin
	nasm -f elf32 ./entry.asm -o entry.o
	gcc -m32 -c ./printk.c -o printk.o
	ld ./printk.o -m elf_i386 -Ttext 0x100000 -e main -o entry.o
	objcopy -j .text -O binary entry.o rayos.bin