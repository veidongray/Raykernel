;;+++++++++++++++++++++++++++++++
;;	bootloader.asm
;;
;;	加载内核，创建全局描述附表
;;
;;	描述附表 0x7e00~0x17e00：
;;		全局数据段描述符： 0x0~0xffffffff 共 4GB
;;		BootLoader段描述符： 0x7c00~0x7dff 共 512Byte
;;		堆栈描述符： 0x0~0x7bff 共 31KB
;;		内核代码段描述符： 0x200000~0x5fffff 共 4MB
;;
;;	内核加载到：0x200000.
;;	硬盘读写使用 48 BIT 模式读写.
;;+++++++++++++++++++++++++++++++
[section bootloader align=16]
[global bootloader_start]
[global bootloader_end]
[global close_irp]
[global create_global_descriptions]
[global open_a20]
[global setup_gdt]
[global open_pm32]
[global kernel_init]
[global entry_32mode]
[global loader_kernel]
[global entry_kernel]
bootloader_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
close_irp:
	cli
;; close_irp_end

create_global_descriptions:
	mov bx, [cs:gdt_base + 0x7c00]

	;; empty description
	mov dword [bx + 0x0], 0x0
	mov dword [bx + 0x4], 0x0

	;; bootloader code description
	mov dword [bx + 0x8], 0x7c0001ff
	mov dword [bx + 0xc], 0x00409800

	;; stack description
	mov dword [bx + 0x10], 0x00007bff
	mov dword [bx + 0x14], 0x00409200

	;; global data description
	mov dword [bx + 0x18], 0x0000ffff
	mov dword [bx + 0x1c], 0x00cf9200

	;; kernel description
	mov dword [bx + 0x20], 0x00000400
	mov dword [bx + 0x24], 0x00c09820
;; create_global_descriptions_end

open_a20:
	mov dx, 0x92
	in al, dx
	or al, 0x2
	out dx, al
;; open_a20_end

setup_gdt:
	lgdt [ds:gdt_size + 0x7c00]
;; setup_gdt_end

open_pm32:
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
;; open_pm32_end

entry_32mode:
	jmp dword 0x0008:kernel_init
;; entry_32mode_end

[bits 32]
kernel_init:
	mov ax, 0x0010
	mov ss, ax
	mov esp, 0x7c00
	mov ax, 0x0018
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
;; kernel_init_end

loader_kernel:
	mov dx, 0x1f1
	mov al, 0x0
	out dx, al
	out dx, al

	mov dx, 0x1f2
	mov al, 0x20
	out dx, al
	mov al, 0x00
	out dx, al

	mov dx, 0x1f3
	mov al, 0x0
	out dx, al
	mov al, 0x1
	out dx, al

	mov dx, 0x1f4
	mov al, 0x0
	out dx, al
	mov al, 0x0
	out dx, al

	mov dx, 0x1f5
	mov al, 0x0
	out dx, al
	mov al, 0x0
	out dx, al

	mov dx, 0x1f6
	mov al, 0100_0000B
	out dx, al

	mov dx, 0x1f7
	mov al, 0x24
	out dx, al

	@check_status:
	mov dx, 0x1f7
	in al, dx
	and al, 0x88
	cmp al, 0x08
	jnz @check_status

	mov ecx, 0x200000
	mov dx, 0x1f0
	mov ebx, 0x200000
	@read_data:
	in ax, dx
	mov [ebx], ax
	add ebx, 0x2
	loop @read_data
;; read_kernel_end

entry_kernel:
	jmp dword 0x0020:0x0
;; entry_kernel_end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gdt_size: dw 0xffff
gdt_base: dd 0x00007e00
bootloader_end:
	times 510 - ($-$$) db 0x0
	db 0x55, 0xaa