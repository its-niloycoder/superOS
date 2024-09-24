; 512 byte program layout
; 
; 2 byte boot signature
; A binary loader (depends on the system) but it is must
; if we want to run more then this 512 byte code
; and this file must awer about how long or how much other 
; sectors to load and where to load, nor it can make runtime
; probles 
; 
; mbr contain many partation reated thing
; some time at can contin file system metadata
; for full drive file system without and partin table
; 
; and we alos have some other standard thing in this 512 byte
; at list for real application this code should have a loader


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
[ORG 0x7C00]                   ; Set the base address for MBR ; cant be used in elf formate
; bios sets all register value so that we can run from this address
; if bios dont do that then we manly need to set those registers values
; that make our own origin becaue all lables and addembler identifires are offset with this values
; for exaple as _start holds the first instruction then _start address is value of the offset and
; next lables get those arress this offset + previously passed addresses
; if we dont change our origin then we need to manualy jump with currect fregment and ofset
; jumping like jmp lable + offset
; seting the values in origin is not use full if we dont have those address space
; this address is ram address not hardisk address
; this why harddisk fast address is 7c00 address in ram
; in early dayes i though that org may be provide paddings bitwine instruction
; so the index get shifted
; i sayed hard sisk becaue in qemu i am using -hda


; sections make addressing more easly and continious
; yes we can define various data into same code sequence
; and jump to next code if data is bittiwin those instruction
; but there are some problem like computer can't sence differnt in instruction
; and data if we forgote to put jump then computer runs those data as instruction
; wich causes unexpected behavior and putting jump makes code havey
; which can be proble in limited mamory space
; so it is good to separate code and data in different sequence as normal 
; so we need to manualy care about sections and structer code in standard sequence of
; readonly inctruction (text), data and more 

; so it is good to use sections. but like bin formate dont allow to have sections
; so we can make care of logical section i manage by lables



.text:
; [global _start]
_start:

    ; enabling a20 line by fast a20 gate mathod
    ; why enabling a20?
    ; because all modern x86 cpu thinks that it is just 8086
    ; if we need more weneed to enable those things
    ; like for 8086 it not need to have mode mamory that time
    ; but we need so we used offset:segment teqniue
    ; it isnot true that a 32 bit cpu can just load 4gb
    ; like we have very large storage device now but we can
    ; address them by using more offsets
    ; but by default ram is managed with a standard bus system
    ; and there ofsets lavel is fixed to by default it is not posible
    ; but with external solution we can do it

    in al, 0x92
    or al, 2
    out 0x92, al


    ; we have many segment:offset group
    ; by multiple segment:offset register
    ; we can have logical separation of our code
    ; which can make our code more fast and user freandly
    ; cs:ip for code section
    ; ds:bp for data section
    ; es:di for extra sections
    ; ss:sp for stack managment
    ; but this addresing teqnicq is used in only rela mode
    ; in protected mode (both 32 and 64 bit) we have linier addresing
    ; this why we are able to use 1 mb in real mode nor we have to use
    ; just 64kb, if we have this segmente based addresing in 32 bit
    ; then we could also use more then 4gb in 32bit
    


    ; jmp 0x7c0:step2

    ; in this stage this code is not neeed
    ; cli
    ; ; ss = es = ds = 0x7c0
    ; mov ax, 0x7c0
    ; mov ds, ax
    ; mov es, ax
    ; mov ss, ax
    ; mov sp, 0x7c00  ; stack pointer useed as back word 
    ; sti

    ; xor ax, ax ; cleaning ax

    ; protected mode
    cli

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ; sti; enabling sti can make a lot of problem if that is enabled

    ; jmp 0x08:kernal_start



[BITS 32]
protectyed_mode_loader:






ata_lba_read:
    mov ebx, eax ; Backup the LBA
    ; Send the highest 8 bits of the lba to hard disk controller
    shr eax, 24

    or eax, 0xE0 ; Select the  master drive
    mov dx, 0x1F6
    out dx, al
    ; Finished sending the highest 8 bits of the lba

    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ; Finished sending the total sectors to read


        mov dx, 0x1F3
        mov eax, ebx
        ; shr eax, 0
        out dx, al

        ; we can use ah in next section
        ; if we load into ax

        mov dx, 0x1F4
        mov eax, ebx
        shr eax, 8
        out dx, al

        mov dx, 0x1F5
        mov eax, ebx
        shr eax, 16
        out dx, al




    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; Read all sectors into memory
.next_sector:
    push ecx

; Checking if we need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

; We need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw
    pop ecx
    loop .next_sector
    ; End of reading sectors into memory
    ret




    ; at first we need to read from storage devices
    ; more simple mathod is logical block addraching
    ; which can be used in any storage devices. if we
    ; use chs then that is optimized for machnical hardisk

; [BITS 32]
; kernal_start:
;     mov ax, 0x10                     ; Load data segment selectors
;     mov ds, ax
;     mov es, ax
;     mov fs, ax
;     mov gs, ax
;     mov ss, ax
;     mov esp, 0x90000                 ; Set up the stack

;     call kernel_main                 ; Call the C kernel main function

;     hlt                          ; Halt the CPU

; ******************************************************************
; Global Descriptor Table (GDT)
; ******************************************************************
; align 8
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





    ;this line will set the error flag so jc will always fire
    ;div ax
    ; mov si, wellcome_message
    ; call print



    ; mov si, buffer1
    ; call print

    ; jmp $   ; hlt pause inturupt

    ; jmp disk_success; it's also dont need because disk success is next to it



; .data section
; wellcome_message: db "Wellcome to superOS", 0
; disk_err_msg: db "Faild to load from disk", 0

; static this is accaciable
; buffer:
;     times 20 db 'A'
;     db 0

; ******************************************************************
; Bootloader Padding and Signature
; ******************************************************************



__free:

; ; MBR Partition Table (64 bytes)
; times 446-($-$$) db 0   ; Fill the space before the partition table (446 bytes in total)

; ; Partition Table Entry 1 (16 bytes)
; partation_1:
;     db 0x80             ; Boot flag (0x80 = active/bootable, 0x00 = inactive)
;     db 0x01, 0x01, 0x00 ; CHS address of first sector (Cylinder-Head-Sector)
;     db 0x07             ; Partition type (0x07 = NTFS/exFAT)
;     db 0xFE, 0xFF, 0xFF ; CHS address of last sector
;     dd 0x00000001       ; LBA of first sector (starting at sector 1)
;     dd 0x00080000       ; Number of sectors (512 * 524,288 = 256 MB partition)

; ; Partition Table Entry 2-4 (Empty)
; partation_2: times 16 db 0x00        ; Empty partition entry 2
; partation_3: times 16 db 0x00        ; Empty partition entry 3
; partation_4: times 16 db 0x00        ; Empty partition entry 4




    times 510-($ - $$) db 0; for without mbr partations
free__:
; jmp boot_signeture_skiped

.data:
dw 0xAA55

; boot_signeture_skiped:
    ; farther

; [org 0x00100000]
; kernel_main:
;     jmp 0x1000:0x0000   ; 0x00100000

; boot secter ends here and under this line any thing dont get executed


; Dont works under those address because of i dont know 
; buffer2:
;     times 20 db 'A'
;     db 0



; 32 bit protected mode for kernel space
; extern kernel_main      ; Declare kernel_main as an external symbol



; 64 bit is not incuded here because it is just x86_32 universe
; we can chake 64 bit from 32 bit and flow our code into 64 bit
; but thats not for now