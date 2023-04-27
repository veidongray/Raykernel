ENTRY(main)
SECTIONS
{
    . = ALIGN(4);
    . = 0x200000;
    .text : {*(.text)}
    .data : {*(.data)}
    .rodata : {*(.rodata)}
    .bss : {*(.bss)}
}