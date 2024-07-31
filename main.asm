[org 0x7c00]

KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl

mov dh, 20

mov ah, 2
mov al, dh
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, [BOOT_DRIVE]
mov es, 0
mov bx, KERNEL_OFFSET
int 0x13

mov ah, 0
mov al, 0x3
int 0x10

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:Start

jmp $

GDT_Start:
    null_descriptor:
        dd  0x0
        dd  0x0
    code_descriptor:
        dw  0xffff
        dw  0x0
        db  0x0
        db  0b10011010
        db  0b11001111
        db  0x0
    data_descriptor:
        dw  0xffff
        dw  0x0
        db  0x0
        db  0x10010010
        db  0b11001111
        db  0x0

GDT_End:

GDT_Descriptor:
    dw  GDT_End - GDT_Start - 1
    dd  GDT_Start


[bits 32]
Start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_OFFSET

BOOT_DRIVE:
    db 0

times 510-($-$$) db 0
dw 0xaa55
