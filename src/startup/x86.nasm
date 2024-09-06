; this is the final stage boot loader
; it can be run by direct bios
; or from a treaditonal boot loader
; if direct bios then we cant loade and arguments
; but if bootloder pass flages and configuration then we can parse here
; it mean this file can part of kernal or can be mbr sector

;TODO: i am thinking about create a os for just x86_16 bit world

; 16 bit real mode code for boot up

; configutaion and standards
BASE EQU 7c00h
;********************************************************************;
;*                           NASM settings                          *;
;********************************************************************;

[BITS 16]                    ; Enable 16-bit real mode
[ORG BASE]                   ; Set the base address for MBR


jmp _start
message: db "hello world my name is niloy", 0
msg_dev_by_zero: db "Error: devied by zero", 0
msg_disk_err: db "Faild to load from disk", 0

_start:
    jmp 0x7c0:step2


handle_zero:
    mov si, msg_dev_by_zero
    call print
    iret


step2:
    cli
    ; ss = es = ds = 0x7c0
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00 
    sti

    xor ax, ax



    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0

    xor ax, ax ; mov ax, 0x0000
    ;this line will set the error flag so jc will always fire
    ;div ax
    mov si, message
    call print

    mov ax, 0x0201
    mov bx, buffer
    mov cx, 0x0002
    mov dh, 0x0000
    int 0x13
    
    jc disk_err
    jnc disk_success

    call print
    hlt  ;jmp $

    ; jmp disk_success; it's also dont need because disk success is next to it
    
disk_success:
        mov si, buffer
        ret
        ; jmp print_hlt; it' neads here

disk_err:
    mov si, msg_disk_err
    ret
    ; jmp print_hlt; actualy that not need because it automaticaly goes in to next instruction

print_hlt:
    call print
    hlt  ;jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret


times 510-($ - $$) db 0
dw 0xAA55

buffer: db 13


; 32 bit protected mode for kernel space




; 64 bit is not incuded here because it is just x86_32 universe
; we can chake 64 bit from 32 bit and flow our code into 64 bit
; but thats not for now