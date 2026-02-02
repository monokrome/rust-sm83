ENTRY(_start)

MEMORY {
    /* Fixed ROM bank 0: interrupt vectors + entry point */
    rom0  (rx)  : ORIGIN = 0x0000, LENGTH = 0x4000

    /* Switchable ROM bank (bank 1 default) */
    romx  (rx)  : ORIGIN = 0x4000, LENGTH = 0x4000

    /* Video RAM */
    vram  (rw)  : ORIGIN = 0x8000, LENGTH = 0x2000

    /* External (cartridge) RAM */
    sram  (rw)  : ORIGIN = 0xA000, LENGTH = 0x2000

    /* Work RAM bank 0 */
    wram0 (rwx) : ORIGIN = 0xC000, LENGTH = 0x1000

    /* Work RAM bank 1 (switchable on GBC) */
    wramx (rwx) : ORIGIN = 0xD000, LENGTH = 0x1000

    /* High RAM (accessible during DMA) */
    hram  (rwx) : ORIGIN = 0xFF80, LENGTH = 0x007F
}

SECTIONS {
    /* ROM header: Nintendo logo check, title, cart type live at 0x0100-0x014F.
       The entry point at 0x0100 jumps to _start. */
    .header 0x0100 : {
        KEEP(*(.header))
    } > rom0

    .text : {
        *(.text .text.*)
    } > rom0

    .rodata : {
        *(.rodata .rodata.*)
    } > rom0

    .data : {
        __data_start = .;
        *(.data .data.*)
        __data_end = .;
    } > wram0 AT> rom0

    __data_load = LOADADDR(.data);

    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > wram0

    .hram (NOLOAD) : {
        *(.hram .hram.*)
    } > hram

    /* Stack grows downward from top of WRAM */
    __stack_top = ORIGIN(wramx) + LENGTH(wramx);

    /DISCARD/ : {
        *(.comment)
        *(.eh_frame)
        *(.eh_frame_hdr)
    }
}
