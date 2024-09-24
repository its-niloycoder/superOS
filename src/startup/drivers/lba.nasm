num_DB: DB      0xFF      
num_DW: DW      0xFFFF    
num_DD: DD      0xFFFFFFFF
num_DQ: DQ      0xFFFFFFFFFFFFFFFF
num_DT: DT      0xFFFFFFFFFFFFFFFF

lba_addr: dd 0xFFFFFFFF

lba_read:
    mov dx, 0x1F6        ; Select master drive and send high LBA bits (24-27)
    mov al, 0xE0         ; Top 4 bits of LBA, drive=master
    out dx, al

    mov dx, 0x1F2        ; Sector count register
    mov al, 1            ; Read 1 sector
    out dx, al

    mov dx, 0x1F3        ; LBA low byte (bits 0-7)
    mov al, [lba_addr]   ; LBA address lower byte
    out dx, al

    mov dx, 0x1F4        ; LBA mid byte (bits 8-15)
    mov al, [lba_addr+1] ; LBA address mid byte
    out dx, al

    mov dx, 0x1F5        ; LBA high byte (bits 16-23)
    mov al, [lba_addr+2] ; LBA address high byte
    out dx, al

    mov dx, 0x1F7        ; Command register
    mov al, 0x20         ; Command: Read sector
    out dx, al

.wait_ready:
    in al, dx
    test al, 0x08        ; Check if drive is ready (BSY and DRQ flags)
    jz .wait_ready

    mov dx, 0x1F0        ; Data register
    ; Read 512 bytes (one sector) into memory
    mov cx, 256          ; 512 bytes / 2 bytes per read = 256 words
    ; cx just tell loop time but di actualy knows how much at a time
    ; 2 = 16 bit; for 64 bit it could be 8 but it is good to use 4 for compatablity
    ; with lagacy systems with 32 bit only
.read_loop:
    in ax, dx
    mov [di], ax         ; Store data in memory
    add di, 2            ; Increment destination pointer
    loop .read_loop
ret
