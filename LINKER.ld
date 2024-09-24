ENTRY(_start)

SECTIONS {
    . = 0x00100000;     /* Bootloader starts at 0x7C00 but kerel starts from
                            a hardcoded known address and for a20 line it can now address
                            almost 1 mb. and for protected mode it can be more*/
    .text : {
        *(.text)                   /* Place all code here */
    }
    .rodata :
    {
        *(.rodata)
    }
    .data : {
        *(.data)                   /* Place initialized data here */
    }
    .bss : {
        *(.bss)                    /* Place uninitialized data here */
    }
}