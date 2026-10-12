; TinyOS - ultra small os under 512 bytes (x86 / BIOS boot)
; build: nasm -f bin boot.asm -o tinyos.img
; execute  : qemu-system-i386 -drive format=raw,file=tinyos.img
[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, banner
    call print

main:
    xor ah, ah
    int 0x16
    cmp al, 13
    je .enter
    cmp al, 8
    je .bs
    mov ah, 0x0E
    int 0x10
    jmp main
.enter:
    mov si, newline
    call print
    jmp main
.bs:
    mov si, erase
    call print
    jmp main

print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

banner:  db "TinyOS booted! Type something:", 13, 10, "> ", 0
newline: db 13, 10, "> ", 0
erase:   db 8, " ", 8, 0

times 510-($-$$) db 0
dw 0xAA55