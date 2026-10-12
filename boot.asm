; PerparvusOS v0.4 - ultra tiny 82byte os (x86 / BIOS boot)
; commands: help / cls / color / reboot
; build: nasm -f bin boot.asm -o perparvusos.img
; execute  : qemu-system-i386 -drive format=raw,file=perparvusos.img
[BITS 16]
[ORG 0x7C00]
    push cs
    pop ds
cls:
    mov ax, 3
    int 0x10
color:
    mov ah, 2
    int 0x1A
    mov ax, 0x1010
    xor bx, bx
    int 0x10
help:
    mov si, txt
pr:
    lodsb
    mov ah, 0x0E
    int 0x10
    test al, al
    jnz pr
key:
    xor ah, ah
    mov di, ax
    int 0x16
    mov ah, 0x0E
    int 0x10
    cmp al, 13
    jne key
    sub di, 'r'
    jz color
    dec di
    jz cls
    dec di
    jnz help
    int 0x19
txt: db 10, "help cls color reboot", 13, 10, ">", 0
times 510-($-$$) db 0
dw 0xAA55