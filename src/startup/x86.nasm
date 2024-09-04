;TODO: i am thinking about create a os for just x86_16 bit world

; 16 bit real mode code for boot up

;********************************************************************;
;*                           NASM settings                          *;
;********************************************************************;
BASE EQU 1
[BITS 16]                    ; Enable 16-bit real mode
[ORG BASE]                   ; Set the base address for MBR


; 32 bit protected mode for kernel space




; 64 bit is not incuded here because it is just x86_32 universe
; we can chake 64 bit from 32 bit and flow our code into 64 bit
; but thats not for now