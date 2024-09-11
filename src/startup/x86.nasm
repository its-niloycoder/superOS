; this is the final stage boot loader
; it can be run by direct bios
; or from a treaditonal boot loader
; if direct bios then we cant loade and arguments
; but if bootloder pass flages and configuration then we can parse here
; it mean this file can part of kernal or can be mbr sector

;TODO: i am thinking about create a os for just x86_16 bit world

; 16 bit real mode code for boot up

; configutaion and standards
; BASE EQU 7c00h
;********************************************************************;
;*                           NASM settings                          *;
;********************************************************************;

[BITS 16]                    ; Enable 16-bit real mode
[ORG 0]                   ; Set the base address for MBR

_start:
    ; jmp 0x7c0:step2

    cli
    ; ss = es = ds = 0x7c0
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00  ; stack pointer useed as back word 
    sti

    xor ax, ax ; cleaning ax

    ; protected mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax



; ******************************************************************
; Global Descriptor Table (GDT)
; ******************************************************************
align 8
gdt_start:
    ; Null descriptor
    dd 0x00000000                ; 0x00: Null segment
    dd 0x00000000                ; 0x04: Null segment

    ; Code segment descriptor (0x08)
    dw 0xFFFF                    ; Segment limit (0-15)
    dw 0x0000                    ; Base address (0-15)
    db 0x00                      ; Base address (16-23)
    db 10011010b                 ; Access byte: 1 00 1 1 0 0 1 0 (Code segment, Readable)
    db 11001111b                 ; Flags: 4-bit limit (16-19) and 32-bit segment (granularity)
    db 0x00                      ; Base address (24-31)

    ; Data segment descriptor (0x10)
    dw 0xFFFF                    ; Segment limit (0-15)
    dw 0x0000                    ; Base address (0-15)
    db 0x00                      ; Base address (16-23)
    db 10010010b                 ; Access byte: 1 00 1 1 0 0 1 0 (Data segment, Writable)
    db 11001111b                 ; Flags: 4-bit limit (16-19) and 32-bit segment (granularity)
    db 0x00                      ; Base address (24-31)

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Size of the GDT
    dd gdt_start                 ; Address of the GDT

; ******************************************************************
; Bootloader Padding and Signature
; ******************************************************************



[BITS 32]

    ;this line will set the error flag so jc will always fire
    ;div ax
    ; mov si, wellcome_message
    ; call print



    ; mov si, buffer1
    ; call print

    jmp $   ; hlt pause inturupt

    ; jmp disk_success; it's also dont need because disk success is next to it



; .data section
; wellcome_message: db "Wellcome to superOS", 0
; disk_err_msg: db "Faild to load from disk", 0

; static this is accaciable
; buffer:
;     times 20 db 'A'
;     db 0


times 510-($ - $$) db 0
dw 0xAA55
; boot secter ends here and under this line any thing dont get executed


; Dont works under those address because of i dont know 
; buffer2:
;     times 20 db 'A'
;     db 0



; 32 bit protected mode for kernel space




; 64 bit is not incuded here because it is just x86_32 universe
; we can chake 64 bit from 32 bit and flow our code into 64 bit
; but thats not for now