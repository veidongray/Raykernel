BOOTFOUT=bootloader.bin

build:
	nasm -f bin ./bootloader.asm -o ${BOOTFOUT}

clean:
	sudo rm -rf ${BOOTFOUT}