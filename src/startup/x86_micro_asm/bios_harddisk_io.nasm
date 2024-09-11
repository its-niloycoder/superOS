; #include <bios_print.nasm>

; Routine: read_data_range
; Description: Reads data from the disk into memory.
; Input: 
;   - Starting sector (passed on the stack).
;   - Number of sectors to read (passed on the stack).
;   - Destination memory buffer (passed on the stack).
; Output:
;   - Data read from the disk is stored in the memory buffer.
read_data_range:
    pusha                  ; Save all registers
    mov bp, sp             ; Set up `bp` to access stack frame

    mov ax, [bp+6]         ; Load the starting sector from stack (position)
    mov cx, [bp+4]         ; Load the number of sectors to read
    mov di, [bp+2]         ; Load the memory buffer address

    read_loop:
        cmp cx, 0              ; Check if any sectors remain to read
        je .done_reading        ; If no more sectors, exit the loop

        call .lba_to_chs        ; Convert the current sector (LBA) to CHS

        ; Set up BIOS interrupt to read the sector
        mov ah, 0x02           ; BIOS service: Read sectors
        mov al, 0x01           ; Read 1 sector at a time
        mov bx, di             ; Load destination memory buffer into BX
        int 0x13               ; BIOS interrupt 13h to read the disk

        jc .disk_error          ; If an error occurs, jump to error handling

        ; Increment DI by 512 bytes (since each sector is 512 bytes)
        add di, 256            ; Add 256 (0x100) twice to increment by 512 bytes
        add di, 256

        inc ax                 ; Move to the next sector
        dec cx                 ; Decrease the number of remaining sectors
        jmp read_loop          ; Repeat the loop

    .done_reading:
        popa                   ; Restore all registers
        ret                    ; Return from the function

    .disk_error:
        mov si, disk_err_msg    ; Load error message
        call print              ; Print error message
        hlt                     ; Halt the system

    ; Convert Logical Block Addressing (LBA) to CHS
    .lba_to_chs:
        ; Convert sector number (LBA) to CHS
        ; Assuming 36 sectors per track, 2 heads

    mov bx, 36             ; 36 sectors per track
    div bx                 ; Divide ax by 36 (ax / 36), remainder is in dx
    mov cl, dl             ; Sector number (from remainder)
    inc cl                 ; Sector numbers start at 1

    mov bx, 2              ; 2 heads (standard setup)
    div bx                 ; Divide ax by 2, remainder is in dx
    mov dh, dl             ; Head number (from remainder)

    mov ch, al             ; Cylinder number (from quotient)
    ret                    ; Return from LBA to CHS conversion



