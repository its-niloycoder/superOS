/* // binary format output can only single assembly file
// global and extern dont works in bin formate
// but there is one posibility we can load our code
// into some defined address and as we have physical address in real mode */

/* OUTPUT_FORMAT(elf32) */
ENTRY(_start)

SECTIONS
{
    . = 1M;


    /* // BIOS loads bootloader at 0x7C00 */

    /* // text section should be in first becuse for bin output
    // we need all code in seqence. historicaly text mean read only instruction
    // so that .text is the first section */

    .text : {
        *(.text)
    }

    /* .rodata : {
        *(.rodata)
    } */

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }

    /* /DISCARD/ : { *(.eh_frame) *(.comment) } */
}
