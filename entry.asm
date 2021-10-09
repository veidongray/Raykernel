[section .text]
[bits 32]
[extern _start]
[global main]
mian:
    mov byte [es:0x0], '@'
    mov byte [es:0x2], '@'
    mov byte [es:0x4], '@'
    mov byte [es:0x6], '@'
    call _start
    hlt