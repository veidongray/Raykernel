ENTRY(main)
SECTIONS
{
	. = 0x200000;
	kernel : {kernel.o(.text)}
}
