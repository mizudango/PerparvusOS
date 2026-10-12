; PerparvusOS v0.2 - ultra tiny 512byte os (x86 / BIOS boot)
; commands: help / cls / color / reboot
; build: nasm -f bin boot.asm -o tinyos.img
; execute  : qemu-system-i386 -drive format=raw,file=tinyos.img
[BITS 16]
[ORG 0x7C00]
buf  equ 0x7E00     
attr equ 0x7E20      

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    cli
    mov ss, ax
    mov sp, 0x7C00
    sti
    cld
    mov byte [attr], 0x07
    call cls
    mov si, banner
    call print

prompt:
    mov si, pmt
    call print
    mov di, buf

key:
    xor ah, ah
    int 0x16
    cmp al, 13
    je enter
    cmp al, 8
    je bs
    cmp di, buf+31
    jae key
    stosb
    mov ah, 0x0E
    int 0x10
    jmp key

bs:
    cmp di, buf
    je key
    dec di
    mov si, erase
    call print
    jmp key

enter:
    xor al, al
    stosb           
    mov si, crlf
    call print
    cmp byte [buf], 0
    je prompt
    mov bx, table
.next:
    mov di, bx
    mov si, buf
.cmp:
    lodsb
    scasb
    jne .skip
    test al, al
    jnz .cmp
    jmp [di]       
.skip:
    mov di, bx
    xor al, al
.scan:
    scasb
    jne .scan
    lea bx, [di+2]
    cmp byte [bx], 0
    jne .next
    mov si, unk
    call print
    jmp prompt

c_help:
    mov si, helptxt
    call print
    jmp prompt
c_cls:
    call cls
    jmp prompt
c_color:
    mov al, [attr]
    inc al
    and al, 0x0F
    jnz .ok
    inc al
.ok:
    mov [attr], al
    call cls
    jmp prompt
c_reboot:
    int 0x19

cls:
    mov ax, 0x0600
    mov bh, [attr]
    xor cx, cx
    mov dx, 0x184F
    int 0x10
    mov ah, 2
    xor bx, bx
    xor dx, dx
    int 0x10
    ret

print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

table:
    db "help", 0
    dw c_help
    db "cls", 0
    dw c_cls
    db "color", 0
    dw c_color
    db "reboot", 0
    dw c_reboot
    db 0

banner:  db "PerparvusOS v0.2 - type help", 13, 10, 0
helptxt: db "help cls color reboot", 13, 10, 0
unk:     db "?", 13, 10, 0
crlf:    db 13, 10, 0
pmt:     db "> ", 0
erase:   db 8, " ", 8, 0

times 510-($-$$) db 0
dw 0xAA55