; PerparvusOS v0.3 - ultratiny OS (x86 / BIOS boot)
; commands: help / cls / color / reboot   
; build: nasm -f bin boot.asm -o tinyos.img
; execute  : qemu-system-i386 -drive format=raw,file=tinyos.img
[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    cwd
    xchg ax, bx
cls:
    mov ax, 3
    int 0x10
help:
    mov si, helptxt
pr:
    lodsb
    test al, al
    jz key
    mov ah, 0x0E
    int 0x10
    jmp pr

key:
    xor ah, ah
    int 0x16
    mov ah, 0x0E
    int 0x10
    cmp al, 13
    je enter
    mov dl, al
    jmp key

enter:
    mov ax, 0x0E0A
    int 0x10
    sub dx, 'p'
    jz help
    dec dx
    dec dx
    jz color
    dec dx
    jz cls
    dec dx
    jnz prompt
    int 0x19

color:
    mov ah, 2
    int 0x1A
    mov ax, 0x1010
    mov bl, 7
    int 0x10
prompt:
    mov si, pmt
    jmp pr

helptxt: db "help cls color reboot", 13, 10
pmt:     db "> ", 0

times 510-($-$$) db 0
dw 0xAA55