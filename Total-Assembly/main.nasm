[ORG 0]
BITS 16

_start:
    jmp 0x7c0:step2

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

    load_disk_to_ram:
    mov ah, 0x02        ; BIOS read sector function
    mov al, 1           ; Read 1 sector
    mov bx, buffer
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2 (sector 1 is the boot sector)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; First hard drive


    ; mov bx, 0x1000      ; Load sector to address 0x1000
    ; mov es, bx          ; ES:BX will point to 0x1000
    ; xor bx, bx          ; BX should be 0 for ES:BX to point to 0x1000

    int 0x13            ; Call BIOS interrupt to read the sector

    jc .disk_err
    jmp main

    .disk_err:
        mov si, msg_disk_err
        call print
        jmp $

main:
    mov si, buffer
    call print
    jmp $

print:
    mov bx, 0x0
    .loop:
        lodsb
        cmp al, 0
        je .done
        call .print_char
        jmp .loop
    .done:
        ret
    .print_char:
        mov ah, 0x0E
        int 0x10
        ret

msg_disk_err: db "Faild to load from disk", 0

times 510-($ - $$) db 0
dw 0xAA55

buffer:
    times 5 db 'Niloy '
	;; THIS CODES LODES FROM SECEND SECTOR IN TO RAM
