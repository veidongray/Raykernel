[global _start]
[global loader_gdt]
[global open_pm32]
[global open_a20]
_start:
;;==========Set GDT Start==========
	mov bx, [gdt_base + 0x7c00]
	mov ax, 0x0
	mov ds, ax
	mov dword [ds:bx + 0x0], 0x0
	mov dword [ds:bx + 0x4], 0x0
;;---Set Code Description---
	mov dword [ds:bx + 0x8], 0x7c001000
	mov dword [ds:bx + 0xc], 0x00c09800
;;---Set Data Description---
	mov dword [ds:bx + 0x10], 0x00001000
	mov dword [ds:bx + 0x14], 0x01c09202
;;---Set Videos Description---
	mov dword [ds:bx + 0x18], 0x80000fa0
	mov dword [ds:bx + 0x1c], 0x0040920b

;;==========Set GDT End==========
	loader_gdt:
	lgdt [cs:gdt_size + 0x7c00]
	
	open_a20:
	mov dx, 0x92
	in ax, dx
	or ax, 0x2
	out dx, ax
	
	cli

	open_pm32:
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax


	jmp dword 0x0008:pm32
[bits 32]
pm32:
	mov ax, 0x18
	mov es, ax
	mov byte [es:0x0], 'P'
	mov byte [es:0x2], 'm'
	mov byte [es:0x4], 'O'
	mov byte [es:0x6], 'K'
	hlt

gdt_size: dw 0xffff
gdt_base: dd 0x00007e00

times 510-($-$$) db 0x0
db 0x55, 0xaa